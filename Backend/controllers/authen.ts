import { PrismaClient } from "@prisma/client";
import { Request, Response } from "express";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";

const prisma = new PrismaClient();

const createUser = async (req: Request, res: Response) => {
    try {
        const { username, email, password, pushyToken } = req.body;
        const hashedPassword = await bcrypt.hash(password, 8);
        const existingUser = await prisma.user.findUnique({ where: { Email: email } });
        if (existingUser) {
            return res.status(400).json({ msg: "User with same email already exists!" });
        }
        const user = await prisma.user.create({
            data: {
                Username: username,
                Email: email,
                Password: hashedPassword,
                pushyToken: pushyToken,
            },
        });

        return res.status(201).json({ message: "User created" });
    } catch (e) {
        console.error("Error:", e);
        return res.status(400).json({ message: "Cannot create user" });
    }
};

const createLogin = async (req: Request, res: Response) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ message: "Email and password are required" });
    }

    try {
        const user = await prisma.user.findUnique({ where: { Email: email } });

        if (!user) {
            return res.status(400).json({ message: "Invalid credentials" });
        }

        const isMatch = await bcrypt.compare(password, user.Password);

        if (!isMatch) {
            return res.status(400).json({ message: "Invalid credentials" });
        }
        const secretKey = process.env.SECRET_KEY;
        if (!secretKey) {
            console.error("SECRET_KEY is not defined in the environment variables");
            return res.status(500).json({ message: "Server error" });
        }
        const token = jwt.sign({ userId: user.UserID }, secretKey, {
            expiresIn: "1h",
        });


        res.json({ userId: user.UserID, token });
    } catch (error) {
        console.error("Error signing in:", error);
        res.status(500).json({ message: "Server error" });
    }
};

export { createUser, createLogin };
