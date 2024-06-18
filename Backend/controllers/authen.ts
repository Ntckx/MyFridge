import { PrismaClient } from "@prisma/client";
import { Request, Response } from "express";
import express from 'express';
import bcrypt from "bcrypt";
// import jwt from "jsonwebtoken";

const app = express();
const prisma = new PrismaClient();

app.use(express.json()); // Middleware for parsing JSON bodies

export const createUser = async (req: Request, res: Response) => {
    try {
        const { username, email, password } = req.body;
        const hashedPassword = await bcrypt.hash(password, 10);
        const user = await prisma.user.create({
            data: {
                Username: username,
                Email: email,
                Password: hashedPassword,
            },
        });

        return res.status(201).json({ message: "User created" });
    } catch (e) {
        console.error("Error:", e);
        return res.status(400).json({ message: "Cannot create user" });
    }
};