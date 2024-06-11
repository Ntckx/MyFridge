import { Router } from "express";
import { getAllList } from "../controllers/controller";
import {
  getAllItems,
  getItemById,
  createItem,
  updateItem,
  deleteItem,
} from "../controllers/item";
import { getNotifications } from "../controllers/notificationController";
import { startScheduler } from "../controllers/notification";

const router = Router();

router.get("/allList", getAllList);
router.get("/items", getAllItems);
router.post("/items", createItem);
router.get("/items/:id", getItemById);
router.put("/items/:id", updateItem);
router.delete("/items/:id", deleteItem);
router.get("/notifications/:userId", getNotifications);

// Start the scheduler
startScheduler();

export default router;
