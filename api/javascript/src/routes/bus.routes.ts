import { Router } from "express";

import { authenticateToken } from "../middlewares/token.authentication";
import { assignUserToBusController, deleteBusController, getBusController, getBussesAndAllDriversController, getBussesController, postBusController, putBusController, removeAssignUserToBusController } from "../controllers/bus.controller";

const router = Router();

router.use(authenticateToken);

router.post("/create-bus", postBusController);
router.get("/get-busses", getBussesController);
router.get("/get-busses-and-all-drivers", getBussesAndAllDriversController);
router.get("/get-bus/:bus_id", getBusController);
router.put("/edit-bus/:bus_id", putBusController);
router.delete("/delete/:bus_id", deleteBusController);

router.post("/assign-driver", assignUserToBusController);
router.delete("/remove-assign-driver", removeAssignUserToBusController);

export default router;