import { PrismaClient } from "@prisma/client";
import { Request, Response } from "express";
import express from 'express';
import bcrypt from "bcrypt";
//import jwt from "jsonwebtoken";
//const Userservice = require ('../service/user.service');
//import { hashPassword, comparePassword } from "../models/user";
import Userservice from "../service/user.service";
//import { comparePassword } from "../models/user";
//const { hashPassword, comparePassword } = require ('../models/user');


const app = express();
const prisma = new PrismaClient();

app.use(express.json()); // Middleware for parsing JSON bodies

// Create user function
export const createUser = async (req: Request, res: Response) => {
    try {
        const { username, email, password } = req.body;
        const hashedPassword = await bcrypt.hash(password, 8);
        const existingUser = await prisma.user.findUnique({ where: { Email: email } });
        if (existingUser){
            return res
            .status(400)
            .json({msg: "User with same email already exists!"});
        }
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

// Login function
// export const createLogin = async (req: Request, res: Response) => {
//     try {
//         const { username, password } = req.body;
//         if (!username) {
//             return res.status(400).json({ message: 'Email is required' });
//         }
//         const user = await prisma.user.findUnique({
//             where: {
//                 Username: any,
//             }
//         });

//         if (!user) {
//             return res.status(400).json({ message: 'User does not exist' });
//         }

//         const isMatch = await bcrypt.compare(password, user.Password);

//         if (!isMatch) {
//             return res.status(400).json({ message: 'Invalid password' });
//         }

//         const tokenData = { _id: user.UserID, email: user.Email };
//         const token = await generateAccessToken(tokenData, "secreteKey", "1h"); // Adjust JWT_EXPIRE as needed

//         return res.status(200).json({ status: true, token: token });
//     } catch (error) {
//         console.error("Error:", error);
//         return res.status(500).json({ message: 'Internal server error' });
//     }
// };

// // UserServices class
// async function generateAccessToken(tokenData: any, JWTSecret_Key: string, JWT_EXPIRE: string) {
//     return jwt.sign(tokenData, JWTSecret_Key, { expiresIn: JWT_EXPIRE });
// }

// module.exports = { createUser, createLogin };



// export const createLogin = async (req: Request, res: Response) => {
//     try{
//         const { email, password } = req.body;

//         const user = await prisma.user.findUnique({ where: { Email: email } });
//         if (!user){
//             return res
//             .status(400)
//             .json({msg: "User with this email does not exists!"});
//         }

//         const isMatch = await bcrypt.compare(password, user.Password);
//         if (!isMatch){
//             return res.status(400).json({msg:"Incorrect password"});
//         }
//         const token = jwt.sign({ id: user.UserID}, "passwordKey" );
//         res.json({ token, user: { id: user.UserID, email: user.Email } });

//     }catch (e){
//         res.status(500).json({ message: 'Internal server error' });
//     }
// }



export const createLogin = async (req: Request, res: Response) => {
    try {
        const { email, password } = req.body;

        const user = await Userservice.checkuser(email);

        if (!user) {
            return res.status(404).json({ message: 'User does not exist' });
        }
        
        const isMatch = await bcrypt.compare(password, user.Password);
        if (!isMatch){
            return res.status(400).json({msg:"Incorrect password"});
        }
                
        const tokenData = { _id: user.UserID, email: user.Email, username: user.Username};
        const token = await Userservice.generateToken(tokenData, "secretkey", '1h');
        res.status(200).json({ status: true, token: token, user: user.UserID, username: user.Username});
    
    } catch (e) {
        console.error(e);
        res.status(500).json({ message: 'Internal server error' });
    }
}    

