import { Router } from "express";

import { authenticateToken } from "../middlewares/token.authentication";
import { assignUserToBusController, deleteBusController, getBusController, getBussesController, postBusController, putBusController, reassignUserToBusController } from "../controllers/bus.controller";

const router = Router();

router.use(authenticateToken);

router.post("/create-bus", postBusController);
router.get("/get-busses", getBussesController);
router.get("/get-bus/:bus_id", getBusController);
router.put("/edit-bus/:bus_id", putBusController);
router.delete("/delete/:bus_id", deleteBusController);

router.post("/assign-driver", assignUserToBusController);
router.put("/reassign-driver", reassignUserToBusController);

export default router;