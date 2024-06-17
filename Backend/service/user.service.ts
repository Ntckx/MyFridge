// Userservice.ts
import { PrismaClient, User } from '@prisma/client';
import jwt from 'jsonwebtoken';

const prisma = new PrismaClient();

export default class Userservice {
    static async checkuser(email: string): Promise<User | null> {
        try {
            return await prisma.user.findUnique({
                where: { Email: email }
            });
        } catch (error) {
            throw error;
        }
    }

    static async generateToken(tokenData: object, secreteKey: string, jwt_expire: string): Promise<string> {
        return jwt.sign(tokenData, secreteKey, { expiresIn: jwt_expire });
    }
}
