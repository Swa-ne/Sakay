import { Router } from "express"
import { createPrivateInboxController, openInboxByUserIDController, openCreatedInboxContentByChatIDController, getMessagesController, saveMessageController, getAllInboxesController, isReadChatController } from "../controllers/chat.controller"
import { authenticateToken } from "../middlewares/token.authentication"


const router = Router()

router.use(authenticateToken);

router.post("/create-private-inbox", createPrivateInboxController)
router.get("/open-inbox-details/:chat_id", openCreatedInboxContentByChatIDController)
router.post("/save-message", saveMessageController)
router.get("/get-messages/:chat_id/:page", getMessagesController)
router.get("/open-inbox", openInboxByUserIDController)
router.get("/get-all-inbox/:page", getAllInboxesController)
router.put("/is-read/:chat_id", isReadChatController)

export default router