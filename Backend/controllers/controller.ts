import { PrismaClient } from "@prisma/client";
import { Request, Response } from "express";

const prisma = new PrismaClient();

//GET METHOD
export const getAllList = async (req: Request, res: Response) => {
    try {
        const lists = await prisma.shoppingList.findMany();
        return res.json(lists);
    } catch (e) {
        console.log(e);
        return res.status(500).json(e);
    }
};