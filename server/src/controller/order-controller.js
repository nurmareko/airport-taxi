// get taxi based on customer's current position

import orderService from '../service/order-service.js';

// customer part

const getTaxisWithinRadius = async (req, res, next) => {
  try {
    const { email } = req.customer;
    const result = await orderService.getTaxisWithinRadius(email);

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const getCurrentOrder = async (req, res, next) => {
  try {
    const { email } = req.customer;
    const result = await orderService.getCurrentOrder(email);

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const addOrder = async (req, res, next) => {
  try {
    const { email } = req.customer;
    const orderData = req.body;
    const result = await orderService.addOrder(email, orderData);
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const cancelOrder = async (req, res, next) => {
  try {
    const { email } = req.customer;
    const { orderId } = req.body;
    const result = await orderService.cancelOrder(email, orderId);
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const getHistoryOrder = async (req, res, next) => {
  try {
    const { email } = req.customer;
    const result = await orderService.getHistoryOrder(email);

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const sendMessage = async (req, res, next) => {
  try {
    const { email } = req.customer;
    const { orderId } = req.body;
    const { message } = req.body;

    const result = await orderService.sendMessage(email, orderId, message);

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const sendReport = async (req, res, next) => {
  try {
    const { email } = req.customer;
    const { orderId } = req.body;
    const { message } = req.body;

    const result = await orderService.sendReport(email, orderId, message);

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const sendReview = async (req, res, next) => {
  try {
    const { email } = req.customer;
    const { orderId } = req.body;
    const { rating } = req.body;
    const { review } = req.body;

    const result = await orderService.sendReview(
      email,
      orderId,
      rating,
      review,
    );

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

export default {
  getTaxisWithinRadius,
  getCurrentOrder,
  addOrder,
  cancelOrder,
  getHistoryOrder,
  sendMessage,
  sendReport,
  sendReview,
};
