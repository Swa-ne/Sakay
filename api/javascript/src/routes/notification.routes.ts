import { Router } from "express"
import { authenticateToken } from "../middlewares/token.authentication"
import { saveNotificationController, deleteNotificationController, editNotificationController, getAllNotificationsController, getNotificationController } from "../controllers/notification.controller";
import { uploadFiles } from "../middlewares/save.config";


const router = Router()

router.use(authenticateToken);

router.post("/save-notification", uploadFiles.array('file'), saveNotificationController);
router.get("/get-all-notifications/:user_type/:page", getAllNotificationsController);
router.get("/get-notification/:notif_id", getNotificationController);
router.put("/edit-notification/:notif_id", uploadFiles.array('file'), editNotificationController);
router.delete("/delete-notification/:notif_id", deleteNotificationController);

export default router