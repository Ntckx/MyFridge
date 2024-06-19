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
import {
  getAllItems,
  getItemById,
  createItem,
  updateItem,
  deleteItem,
  markItemAsEaten,
} from "../controllers/item";
import { getNotifications } from "../controllers/notificationController";
import { startScheduler } from "../controllers/notification";
import { registerDevice } from "../controllers/registerController";
import { createLogin } from "../controllers/authen";


const router = Router();

//GET METHOD
router.get("/items", getAllItems);
router.get("/items/:id", getItemById);
router.get("/notifications/:userId", getNotifications);
//POST METHOD
router.post("/allList", getMyAllList);
router.post("/getUser", getUserByUserId);
router.post("/createList", createList);
router.post("/users", createUser);
router.post("/items", createItem);
router.post("/register", registerDevice);
router.post('/login', createLogin);

//PUT METHOD
router.patch("/updateList", updateListByListId);
router.patch("/updateUsername", updateUsername);
router.patch("/updatePremium", updatePremium);
router.put("/items/:id", updateItem);
router.put("/items/eaten/:id", markItemAsEaten);

//DELETE METHOD
router.delete("/deleteList", deleteListByListId);
router.delete("/deleteAllList", deleteAllList);
router.delete("/items/:id", deleteItem);

startScheduler();



export default router;
