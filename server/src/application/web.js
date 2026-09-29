import express from 'express';
import cors from 'cors';
import { publicRouter } from '../route/public-api.js';
import { errorMiddleware } from '../middleware/error-middleware.js';
import { customerRouter, driverRouter, adminRouter } from '../route/api.js';

export const web = express();

web.use(cors());
web.use(express.json());

web.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

web.use(publicRouter);

web.use(customerRouter);
web.use(driverRouter);
web.use(adminRouter);

web.use(errorMiddleware);
