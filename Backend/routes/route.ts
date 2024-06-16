import { Router } from "express";
import { getUserById } from "../controllers/user";
import {
  getAllItems,
  getItemById,
  createItem,
  updateItem,
  deleteItem,
  markItemAsEaten
} from "../controllers/item";
import { getNotifications } from "../controllers/notificationController";
import { startScheduler } from "../controllers/notification";
import { registerDevice } from "../controllers/registerController";

const router = Router();

router.get("/users/:id", getUserById);
router.get("/items", getAllItems);
router.post("/items", createItem);
router.get("/items/:id", getItemById);
router.put("/items/:id", updateItem);
router.put("/items/eaten/:id", markItemAsEaten);
router.delete("/items/:id", deleteItem);
router.get("/notifications/:userId", getNotifications);
router.post("/register", registerDevice);

// Start the scheduler
startScheduler();

export default router;
