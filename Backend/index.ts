import express, { Request, Response } from "express";
import cors from "cors";
import Routes from "./routes/route";
import dotenv from "dotenv";
dotenv.config();
const app = express();
const port = 8000;

app.use(cors());
app.use(express.json());

app.get("/", (req: Request, res: Response) => {
  return res.send("Hello Myfridge!!");
});

app.use("/", Routes);

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
