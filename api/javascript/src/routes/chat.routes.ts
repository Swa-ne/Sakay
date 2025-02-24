import { Router } from "express"
import { createPrivateInboxController, openInboxByUserIDController, openCreatedInboxContentByChatIDController, getMessagesController, saveMessageController, getAllInboxesController } from "../controllers/chat.controller"
import { authenticateToken } from "../middlewares/token.authentication"


const router = Router()

router.post("/create-private-inbox", authenticateToken, createPrivateInboxController)
router.get("/open-inbox-details/:chat_id", authenticateToken, openCreatedInboxContentByChatIDController)
router.post("/save-message", authenticateToken, saveMessageController)
router.get("/get-messages/:chat_id/:page", authenticateToken, getMessagesController)
router.get("/open-inbox", authenticateToken, openInboxByUserIDController)
router.get("/get-all-inbox/:page", authenticateToken, getAllInboxesController)

export default router