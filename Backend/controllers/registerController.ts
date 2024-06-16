// import { Request, Response } from "express";
// import { PrismaClient } from "@prisma/client";

// const prisma = new PrismaClient();

// export const registerDevice = async (req: Request, res: Response) => {
//   const { userId, token } = req.body;

//   if (!userId || !token) {
//     return res.status(400).json({ error: "Missing userId or token" });
//   }

//   try {
//     // Convert userId to an integer
//     const userIdInt = parseInt(userId, 10);

//     console.log(
//       `Received request to register device: ${JSON.stringify(req.body)}`
//     );
//     await prisma.user.update({
//       where: { UserID: userIdInt },
//       data: { pushyToken: token },
//     });
//     console.log(`Token for user ${userIdInt} saved: ${token}`);
//     res.json({ success: true });
//   } catch (error) {
//     console.error("Error saving token:", error);
//     const err = error as any; // Cast error to any to access its properties
//     res
//       .status(500)
//       .json({ error: "Internal server error", details: err.message });
//   }
// };

import { Request, Response } from "express";
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export const registerDevice = async (req: Request, res: Response) => {
  const { userId, token } = req.body;

  if (!userId || !token) {
    return res.status(400).json({ error: "Missing userId or token" });
  }

  try {
    console.log(
      `Received request to register device: ${JSON.stringify(req.body)}`
    );
    const userIdInt = parseInt(userId, 10);
    await prisma.user.update({
      where: { UserID: userIdInt },
      data: { pushyToken: token },
    });
    console.log(`Token for user ${userIdInt} saved: ${token}`);
    res.json({ success: true });
  } catch (error) {
    console.error("Error saving token:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};
