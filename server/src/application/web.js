import express from "express";
import { publicRouter } from "../route/public-api.js";
import { errorMiddleware } from "../middleware/error-middleware.js";
import cors from "cors";
import { customerRouter, driverRouter, adminRouter } from "../route/api.js";

export const web = express();

web.use(cors());
web.use(express.json());
web.use(publicRouter);

web.use(customerRouter);
web.use(driverRouter);
web.use(adminRouter);

web.use(errorMiddleware);
