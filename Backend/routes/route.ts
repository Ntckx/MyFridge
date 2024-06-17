import { Router } from "express";
import { getMyAllList } from "../controllers/controller";
import { getUserByUserId } from "../controllers/controller";
import { createList } from "../controllers/controller";
import { updateListByListId } from "../controllers/controller";
import { updateUsername } from "../controllers/controller";
import { updatePremium } from "../controllers/controller";
import { deleteListByListId } from "../controllers/controller";
import { deleteAllList } from "../controllers/controller";
import { createUser } from "../controllers/authen";
const router = Router();

//GET METHOD

//POST METHOD
router.post("/allList", getMyAllList);
router.post("/getUser", getUserByUserId);
router.post("/createList", createList);
router.post("/users", createUser);

//PUT METHOD
router.patch("/updateList", updateListByListId);
router.patch("/updateUsername", updateUsername);
router.patch("/updatePremium", updatePremium);

//DELETE METHOD
router.delete("/deleteList", deleteListByListId);
router.delete("/deleteAllList", deleteAllList);

export default router;
