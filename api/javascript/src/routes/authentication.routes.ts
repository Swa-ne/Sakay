import { Router } from "express";


import { checkEmailAvailabilityController, checkEmailVerifiedController, checkPhoneNumberValidityController, resendEmailCodeController, signupUserController, verifyEmailCodeController } from "../controllers/authentication/signup.controller";
import { authenticateToken } from "../middlewares/token.authentication";
import { changePasswordController, editProfileController, forgotPasswordController, loginUserController, postResetPasswordController } from "../controllers/authentication/login.controller";
import { logoutUserController } from "../controllers/authentication/logout.controller";
import { refreshAccessTokenController } from "../controllers/authentication/refresh.token.controller";
import { getCurrentUserController, getFile } from "../controllers/authentication/index.controller";
import { forgetPasswordLimiter, loginLimiter, sendCodeLimiter } from "../middlewares/rate.limiter";

const router = Router();

router.post("/check-email", checkEmailAvailabilityController);
router.post("/check-phone-number", checkPhoneNumberValidityController);

router.post("/signup", signupUserController);
router.put("/resend-verification", sendCodeLimiter, authenticateToken, resendEmailCodeController);
router.post("/verify-code", authenticateToken, verifyEmailCodeController);
router.post("/check-email-verification", authenticateToken, checkEmailVerifiedController);

router.post("/login", loginLimiter, loginUserController);
router.delete("/logout", authenticateToken, logoutUserController);
// TODO: add logout all devices

router.post("/access-token", refreshAccessTokenController);

router.put("/change-password", authenticateToken, changePasswordController);

router.put("/edit-profile", authenticateToken, editProfileController);
router.post("/forgot-password", forgetPasswordLimiter, forgotPasswordController);
router.post("/reset-password", authenticateToken, postResetPasswordController);

router.get("/current-user", authenticateToken, getCurrentUserController);

router.get('/fetch-file', getFile); //TODO: add access token

export default router;