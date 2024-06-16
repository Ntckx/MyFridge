import cron from "node-cron";
import { PrismaClient } from "@prisma/client";
import moment from "moment-timezone";
import Pushy from "pushy";
import dotenv from "dotenv";

// Load environment variables from .env file
dotenv.config();

const prisma = new PrismaClient();
const pushyAPIKey = process.env.PUSHY_API_KEY || ""; // Use the API key from the environment variable
const pushy = new Pushy(pushyAPIKey);
const BANGKOK_TIMEZONE = "Asia/Bangkok";

const startOfDay = (date: Date, timeZone: string) => {
  return moment.tz(date, timeZone).startOf("day").toDate();
};

const adjustExpirationDate = (date: Date | null) => {
  if (!date) {
    return null;
  }
  const adjustedDate = moment(date).subtract(7, "hours").toDate();
  return adjustedDate;
};

const scheduleNotifications = async () => {
  try {
    const now = new Date();
    const todayStart = startOfDay(now, BANGKOK_TIMEZONE);
    const tomorrowStart = moment(todayStart).add(1, "day").toDate();

    const allItems = await prisma.item.findMany({
      include: {
        User: true,
      },
    });

    const items = allItems.filter((item) => {
      if (!item.ExpirationDate) {
        return false;
      }
      const adjustedExpirationDate = adjustExpirationDate(item.ExpirationDate);
      if (!adjustedExpirationDate) {
        return false;
      }
      const notificationDate = moment(adjustedExpirationDate)
        .subtract(1, "day")
        .toDate();
      return notificationDate >= todayStart && notificationDate < tomorrowStart;
    });

    for (const item of items) {
      const existingNotification = await prisma.notification.findFirst({
        where: {
          ItemID: item.ItemID,
          UserID: item.UserID,
          isSent: true,
        },
      });

      if (existingNotification) {
        console.log(
          `Notification already sent for item: ${item.ItemName}, User: ${item.User.Email}`
        );
        continue; // Skip this item if notification has already been sent
      }

      const message = `Your ${item.ItemName} is about to expire in 1 day.`;

      const notification = await prisma.notification.create({
        data: {
          ItemID: item.ItemID,
          UserID: item.UserID,
          message,
          sendAt: moment().tz(BANGKOK_TIMEZONE).toDate(),
          isSent: true,
        },
      });

      console.log(
        `Scheduled notification for ${item.User.Email} at ${now}: ${message}`
      );

      // Logic to send notification to the user using Pushy
      if (item.User.pushyToken) {
        const data = {
          message: message,
        };

        const options: any = {
          notification: {
            title: "MyFridge Notification",
            body: message,
            badge: 1,
            sound: "default",
          },
        };

        console.log(
          `Sending Pushy notification with data: ${JSON.stringify(
            data
          )} and options: ${JSON.stringify(options)}`
        );
        pushy.sendPushNotification(
          data,
          [item.User.pushyToken],
          options,
          (err, id) => {
            if (err) {
              console.error("Pushy send error:", err);
              return;
            }
            console.log(
              `Pushy notification sent successfully! ID: ${JSON.stringify(id)}`
            );

            // Check the status of the notification
            pushy.getNotificationStatus(id.id, (err, status) => {
              if (err) {
                console.error("Pushy notification status error:", err);
                return;
              }
              console.log(
                `Pushy notification status: ${JSON.stringify(status)}`
              );
            });
          }
        );
      } else {
        console.log(`User ${item.User.Email} does not have a Pushy token.`);
      }
    }
  } catch (err) {
    console.error("Error retrieving items:", err);
  }
};

const startScheduler = () => {
  cron.schedule(
    "* * * * *",
    async () => {
      console.log("Checking for items to notify...");
      await scheduleNotifications();
    },
    {
      timezone: "Asia/Bangkok",
    }
  );
};

export { scheduleNotifications, startScheduler };
