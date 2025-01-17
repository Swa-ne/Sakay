import { Router } from "express";

import { authenticateToken } from "../middlewares/token.authentication";
import { changePasswordController, editProfileController, forgotPasswordController, loginUserController, postResetPasswordController } from "../controllers/authentication/login.controller";
import { forgetPasswordLimiter, loginLimiter } from "../middlewares/rate.limiter";

const router = Router();


router.post("/login", loginLimiter, loginUserController);

router.put("/change-password", authenticateToken, changePasswordController);

router.put("/edit-profile", authenticateToken, editProfileController);
router.post("/forgot-password", forgetPasswordLimiter, forgotPasswordController);
router.post("/reset-password", authenticateToken, postResetPasswordController);


export default router;