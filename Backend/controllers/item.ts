import { Request, Response } from "express";
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export const getAllItems = async (req: Request, res: Response) => {
  const { userId } = req.query;

  if (!userId) {
    return res.status(400).json({ message: "UserId is required" });
  }

  try {
    const items = await prisma.item.findMany({
      where: { UserID: parseInt(userId as string) },
    });
    console.log("Items retrieved:", items);
    res.status(200).json(items);
  } catch (error) {
    if (error instanceof Error) {
      console.error("Error fetching items:", error.message);
      res.status(500).json({ error: error.message });
    } else {
      console.error("Unknown error fetching items:", error);
      res.status(500).json({ error: "Unknown error occurred" });
    }
  }
};

export const createItem = async (req: Request, res: Response) => {
  const { ItemName, Quantity, ExpirationDate, Description, UserID } = req.body;

  if (!ItemName || !Quantity || !ExpirationDate || !Description || !UserID) {
    return res.status(400).json({ error: "All fields are required" });
  }

  try {
    const expiration = new Date(ExpirationDate);

    const newItem = await prisma.item.create({
      data: {
        ItemName,
        Quantity,
        ExpirationDate: expiration,
        Description,
        UserID,
      },
    });

    res.status(201).json(newItem);
  } catch (error) {
    if (error instanceof Error) {
      console.error("Error creating item:", error.message);
      res.status(500).json({ error: error.message });
    } else {
      console.error("Unknown error creating item:", error);
      res.status(500).json({ error: "Unknown error occurred" });
    }
  }
};

export const getItemById = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const item = await prisma.item.findUnique({
      where: { ItemID: parseInt(id) },
    });

    if (item) {
      res.status(200).json(item);
    } else {
      res.status(404).json({ error: "Item not found" });
    }
  } catch (error) {
    if (error instanceof Error) {
      console.error("Error fetching item:", error.message);
      res.status(500).json({ error: error.message });
    } else {
      console.error("Unknown error fetching item:", error);
      res.status(500).json({ error: "Unknown error occurred" });
    }
  }
};

export const updateItem = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { ItemName, Quantity, ExpirationDate, Description } = req.body;
    const item = await prisma.item.update({
      where: { ItemID: parseInt(id) },
      data: {
        ItemName,
        Quantity,
        ExpirationDate: new Date(ExpirationDate),
        Description,
      },
    });
    return res.json(item);
  } catch (e) {
    console.log(e);
    return res.status(500).json(e);
  }
};

export const deleteItem = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    await prisma.item.delete({ where: { ItemID: parseInt(id) } });
    return res.json({ message: "Item deleted" });
  } catch (e) {
    console.log(e);
    return res.status(500).json(e);
  }
};
export const markItemAsEaten = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { QuantityEaten } = req.body;

    if (!QuantityEaten || QuantityEaten < 1) {
      return res.status(400).json({ error: "Invalid quantity eaten" });
    }

    const item = await prisma.item.findUnique({
      where: { ItemID: parseInt(id) },
    });

    if (!item) {
      return res.status(404).json({ error: "Item not found" });
    }

    const updatedQuantity = item.Quantity - QuantityEaten;

    const updatedItem = await prisma.item.update({
      where: { ItemID: parseInt(id) },
      data: { Quantity: updatedQuantity < 0 ? 0 : updatedQuantity },
    });

    return res.json({ remainingQuantity: updatedItem.Quantity });
  } catch (e) {
    console.log(e);
    return res.status(500).json(e);
  }
};
