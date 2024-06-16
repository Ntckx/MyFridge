import { Request, Response } from "express";
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export const getNotifications = async (req: Request, res: Response) => {
  const userId = parseInt(req.params.userId);

  try {
    const notifications = await prisma.notification.findMany({
      where: {
        UserID: userId,
        isSent: true,
      },
    });

    console.log(`Fetched notifications for user ${userId}:`, notifications);

    res.status(200).json(notifications);
  } catch (error) {
    console.error("Error fetching notifications:", error);
    res.status(500).json({ error: "Failed to fetch notifications" });
  }
};
