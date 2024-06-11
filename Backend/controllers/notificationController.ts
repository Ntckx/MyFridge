import { Request, Response } from "express";
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

// Endpoint to get notifications for a user
export const getNotifications = async (req: Request, res: Response) => {
  const userId = parseInt(req.params.userId);

  try {
    const notifications = await prisma.notification.findMany({
      where: {
        UserID: userId,
        isSent: false,
      },
    });

    // Update notifications to mark them as sent
    await prisma.notification.updateMany({
      where: {
        UserID: userId,
        NotificationID: { in: notifications.map((n) => n.NotificationID) },
        isSent: false,
      },
      data: {
        isSent: true,
      },
    });

    res.status(200).json(notifications);
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch notifications" });
  }
};
