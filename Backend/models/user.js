import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcrypt';

const prisma = new PrismaClient();

const saltRounds = 10;

export const hashPassword = async (password) => {
    const salt = await bcrypt.genSalt(saltRounds);
    return bcrypt.hash(password, salt);
};

export const comparePassword = async (enteredPassword, storedPassword) => {
    return bcrypt.compare(enteredPassword, storedPassword);
};
