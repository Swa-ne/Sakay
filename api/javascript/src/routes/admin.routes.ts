import { Router } from "express";

import { authenticateToken } from "../middlewares/token.authentication";
import { assignUserToBusController, deleteBusController, getBusController, getBussesController, postBusController, putBusController, reassignUserToBusController } from "../controllers/admin.controller";

const router = Router();

router.post("/create-bus", authenticateToken, postBusController);
router.get("/get-busses", authenticateToken, getBussesController);
router.get("/get-bus/:bus-id", authenticateToken, getBusController);
router.put("/edit-bus/:bus-id", authenticateToken, putBusController);
router.delete("/delete/:bus-id", authenticateToken, deleteBusController);

router.post("/assign-driver", authenticateToken, assignUserToBusController);
router.put("/reassign-driver", authenticateToken, reassignUserToBusController);

export default router;