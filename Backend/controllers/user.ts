import { Request, Response } from "express";
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export const getUserById = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const user = await prisma.user.findUnique({
      where: { UserID: parseInt(id) },
    });

    if (user) {
      res.status(200).json(user);
    } else {
      res.status(404).json({ error: "User not found" });
    }
  } catch (error) {
    if (error instanceof Error) {
      console.error("Error fetching user:", error.message);
      res.status(500).json({ error: error.message });
    } else {
      console.error("Unknown error fetching user:", error);
      res.status(500).json({ error: "Unknown error occurred" });
    }
  }
};
