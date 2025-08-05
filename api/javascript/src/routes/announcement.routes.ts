import { Router } from "express"
import { authenticateToken } from "../middlewares/token.authentication"
import { saveAnnouncementController, deleteAnnouncementController, editAnnouncementController, getAllAnnouncementsController, getAnnouncementController } from "../controllers/announcement.controller";
import { uploadFiles } from "../middlewares/save.config";


const router = Router()

router.use(authenticateToken);

router.post("/save-announcement", uploadFiles.array('file'), saveAnnouncementController);
router.get("/get-all-announcements", getAllAnnouncementsController);
router.get("/get-announcement/:announcement_id", getAnnouncementController);
router.put("/edit-announcement/:announcement_id", uploadFiles.array('file'), editAnnouncementController);
router.delete("/delete-announcement/:announcement_id", deleteAnnouncementController);

export default router