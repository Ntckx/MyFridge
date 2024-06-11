import cron from "node-cron";
import { PrismaClient } from "@prisma/client";
import moment from "moment-timezone";

const prisma = new PrismaClient();

const BANGKOK_TIMEZONE = "Asia/Bangkok";

// Utility function to adjust date to only include date part (midnight) in the specified time zone
const startOfDay = (date: Date, timeZone: string) => {
  return moment.tz(date, timeZone).startOf("day").toDate();
};

// Function to convert UTC to local time after retrieving
const convertToLocalTime = (date: Date) => {
  return moment(date).tz(BANGKOK_TIMEZONE).toDate();
};

// Function to adjust expiration date by subtracting 7 hours
const adjustExpirationDate = (date: Date | null) => {
  if (!date) {
    return null;
  }
  const adjustedDate = moment(date).subtract(7, "hours").toDate();
  console.log(`Original Date: ${date}, Adjusted Date: ${adjustedDate}`);
  return adjustedDate;
};

// Function to schedule notifications
const scheduleNotifications = async () => {
  try {
    const now = new Date();
    const todayStart = startOfDay(now, BANGKOK_TIMEZONE);
    const tomorrowStart = moment(todayStart).add(1, "day").toDate();

    console.log(`Current Date: ${now}`);
    console.log(`Today's Start: ${todayStart}`);
    console.log(`Tomorrow's Start: ${tomorrowStart}`);

    // Fetch all items from the database
    const allItems = await prisma.item.findMany({
      include: {
        User: true,
      },
    });

    console.log(`Found ${allItems.length} item(s) in the database.`);

    // Log all items
    allItems.forEach((item) => {
      const adjustedExpirationDate = adjustExpirationDate(item.ExpirationDate);
      console.log(
        `Item: ${item.ItemName}, ExpirationDate: ${adjustedExpirationDate}, UserID: ${item.UserID}`
      );
    });

    // Filter items within the date range
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
      console.log(
        `Comparing: ${notificationDate.toISOString()} >= ${todayStart.toISOString()} && ${notificationDate.toISOString()} < ${tomorrowStart.toISOString()}`
      );
      return notificationDate >= todayStart && notificationDate < tomorrowStart;
    });

    console.log(
      `Found ${items.length} item(s) with expiration dates within the next day.`
    );

    items.forEach((item) => {
      const adjustedExpirationDate = adjustExpirationDate(item.ExpirationDate);
      console.log(
        `Item: ${item.ItemName}, ExpirationDate: ${adjustedExpirationDate}`
      );
    });

    for (const item of items) {
      // Check if a notification has already been sent or exists for this item
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

      // Create a notification in the database
      const notification = await prisma.notification.create({
        data: {
          ItemID: item.ItemID,
          UserID: item.UserID,
          message,
          sendAt: moment().tz(BANGKOK_TIMEZONE).toDate(),
          isSent: true, // Mark as sent immediately
        },
      });

      console.log(
        `Scheduled notification for ${item.User.Email} at ${now}: ${message}`
      );

      // Logic to send notification to the user, e.g., via email, push notification, etc.
      // For demonstration, we're just logging the message
      console.log(`Sending notification to ${item.User.Email}: ${message}`);
    }
  } catch (err) {
    console.error("Error retrieving items:", err);
  }
};

// Schedule the notification check every minute for testing
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
