// import { PrismaClient } from "@prisma/client";
// import { Request, Response } from "express";
// import express from 'express';
// import bcrypt from "bcrypt";
// import Userservice from "../service/user.service";

// const app = express();
// const prisma = new PrismaClient();

// app.use(express.json()); // Middleware for parsing JSON bodies

// // Create user function
// export const createUser = async (req: Request, res: Response) => {
//     try {
//         const { username, email, password, pushyToken } = req.body;
//         const hashedPassword = await bcrypt.hash(password, 8);
//         const existingUser = await prisma.user.findUnique({ where: { Email: email } });
//         if (existingUser) {
//             return res.status(400).json({ msg: "User with same email already exists!" });
//         }
//         const user = await prisma.user.create({
//             data: {
//                 Username: username,
//                 Email: email,
//                 Password: hashedPassword,
//                 pushyToken: pushyToken,
//             },
//         });

//         return res.status(201).json({ message: "User created" });
//     } catch (e) {
//         console.error("Error:", e);
//         return res.status(400).json({ message: "Cannot create user" });
//     }
// };

// // Login function remains unchanged
// export const createLogin = async (req: Request, res: Response) => {
//     try {
//         const { email, password } = req.body;
//         const user = await Userservice.checkuser(email);

//         if (!user) {
//             return res.status(404).json({ message: 'User does not exist' });
//         }

//         const isMatch = await bcrypt.compare(password, user.Password);
//         if (!isMatch) {
//             return res.status(400).json({ msg: "Incorrect password" });
//         }

//         const tokenData = { _id: user.UserID, email: user.Email, username: user.Username };
//         const token = await Userservice.generateToken(tokenData, "secretkey", '1h');
//         res.status(200).json({ status: true, token: token, user: user.UserID, username: user.Username });

//     } catch (e) {
//         console.error(e);
//         res.status(500).json({ message: 'Internal server error' });
//     }
// }

import { PrismaClient } from "@prisma/client";
import { Request, Response } from "express";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
// import Userservice from "../service/user.service";

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

        const token = jwt.sign({ userId: user.UserID }, "your_secret_key", {
            expiresIn: "1h",
        });

        res.json({ userId: user.UserID, token });
    } catch (error) {
        console.error("Error signing in:", error);
        res.status(500).json({ message: "Server error" });
    }
};

export { createUser, createLogin };

