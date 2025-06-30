import { Router } from "express";

import { authenticateToken } from "../middlewares/token.authentication";
import { getDriverController, getDriversController, getUserController, getUsersController } from "../controllers/user.controller";
import { signupUserController } from "../controllers/authentication/signup.controller";

const router = Router();

router.use(authenticateToken);

router.get("/get-all-users", getUsersController);
router.get("/get-user/:user_id", getUserController);
// router.put("/deactivate-user/:user_id", decactivateUserController);

router.get("/get-drivers", getDriversController);
router.get("/get-driver/:user_id", getDriverController);

router.post("/create-driver", signupUserController)


export default router;