import { PrismaClient } from "@prisma/client";
import { Request, Response } from "express";

const prisma = new PrismaClient();

//GET METHOD
export const getMyAllList = async (req: Request, res: Response) => {
    const { UserID } = req.body;
    try {
        const lists = await prisma.shoppingList.findMany({
            where: { UserID: UserID },
        });
        return res.json(lists);
    } catch (e) {
        console.log(e);
        return res.status(500).json(e);
    }
};

export const getUserByUserId = async (req: Request, res: Response) => {
    const { UserID } = req.body;
    if (!UserID || typeof UserID !== 'number') {
        return res.status(400).json({ error: 'Invalid UserID' });
    }
    try {
        const user = await prisma.user.findUnique({
            where: { UserID: UserID },
        });
        return res.json(user);
    } catch (e) {
        console.log(e);
        return res.status(500).json(e);
    }
}

// POST METHOD
export const createList = async (req: Request, res: Response) => {
    const { Listname, Quantity, isChecked } = req.body;
    const { UserId } = req.body;
    try {
        const createdList = await prisma.shoppingList.create({
            data: {
                UserID: UserId,
                ListName: Listname,
                Quantity: Quantity,
                isChecked: isChecked,
            },
        });
        return res.json(createdList);
    } catch (e) {
        console.log(e);
        return res.status(500).json(e);
    }
};

// PUT METHOD
export const updateListByListId = async (req: Request, res: Response) => {
    const { ListId, isChecked } = req.body;
    const { UserId } = req.body;
    try {
        const updatedList = await prisma.shoppingList.update({
            where: { ListID: ListId, UserID: UserId },
            data: {
                isChecked: isChecked,
            },
        });
        return res.json(updatedList);
    } catch (e) {
        console.log(e);
        return res.status(500).json(e);
    }
};

export const updateUsername = async (req: Request, res: Response) => {
    const { UserId, Username } = req.body;
    try {
        const updatedUser = await prisma.user.update({
            where: { UserID: UserId },
            data: {
                Username: Username,
            },
        });
        return res.json(updatedUser);
    } catch (e) {
        console.log(e);
        return res.status(500).json(e);
    }
}

export const updatePremium = async (req: Request, res: Response) => {
    const { UserId, isPremium } = req.body;
    try {
        const updatedUser = await prisma.user.update({
            where: { UserID: UserId },
            data: {
                isPremium: isPremium,
            },
        });
        return res.json(updatedUser);
    } catch (e) {
        console.log(e);
        return res.status(500).json(e);
    }
}

// DELETE METHOD
export const deleteListByListId = async (req: Request, res: Response) => {
    const { ListId } = req.body;
    try {
        const deletedList = await prisma.shoppingList.delete({
            where: { ListID: ListId},
        });
        return res.json(deletedList);
    } catch (e) {
        console.log(e);
        return res.status(500).json(e);
    }
};

export const deleteAllList = async (req: Request, res: Response) => {
    const { UserId } = req.body;
    try {
        const deletedLists = await prisma.shoppingList.deleteMany({
            where: { UserID: UserId },
        });
        return res.json(deletedLists);
    } catch (e) {
        console.log(e);
        return res.status(500).json(e);
    }
};
