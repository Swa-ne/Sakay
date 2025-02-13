import { Router } from "express";

import { authenticateToken } from "../middlewares/token.authentication";
import { deleteBusController, getBusController, getBussesController, postBusController, putBusController } from "../controllers/admin.controller";

const router = Router();

router.post("/create_bus", authenticateToken, postBusController);
router.get("/get_busses", authenticateToken, getBussesController);
router.get("/get_bus/:bus_id", authenticateToken, getBusController);
router.put("/edit_bus/:bus_id", authenticateToken, putBusController);
router.delete("/delete/:bus_id", authenticateToken, deleteBusController);

export default router;