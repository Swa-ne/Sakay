import { Router } from "express"
import { authenticateToken } from "../middlewares/token.authentication"
import { getAllReportsController, getReportController, postIncidentReportController, postPerformanceReportController, toggleReportController } from "../controllers/report.controller";


const router = Router()

router.use(authenticateToken);

router.post("/create-incident-report", postIncidentReportController);
router.post("/create-performance-report", postPerformanceReportController);
router.get("/get-all-report/:page", getAllReportsController);
router.get("/get-report/:report_id", getReportController);
router.put("/toggle-report/:report_id", toggleReportController);

export default router