import { Router } from "express";
import { getAllList } from "../controllers/controller";

const router = Router();

//GET METHOD
router.get("/allList", getAllList);

export default router;