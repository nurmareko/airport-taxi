// get taxi based on driver's current position

import orderanService from '../service/orderan-service.js';

// driver part

const getCurrentOrderan = async (req, res, next) => {
  try {
    const { email } = req.driver;
    const result = await orderanService.getCurrentOrderan(email);

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const rejectOrderan = async (req, res, next) => {
  try {
    const { email } = req.driver;
    const { orderId } = req.body;
    const result = await orderanService.rejectOrderan(email, orderId);

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const acceptOrderan = async (req, res, next) => {
  try {
    const { email } = req.driver;
    const { orderId } = req.body;
    const result = await orderanService.acceptOrderan(email, orderId);

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const cancelOrderan = async (req, res, next) => {
  try {
    const { email } = req.driver;
    const { orderId } = req.body;
    const result = await orderanService.cancelOrderan(email, orderId);

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const getHistoryOrderan = async (req, res, next) => {
  try {
    const { email } = req.driver;
    const result = await orderanService.getHistoryOrderan(email);

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const updateStatusOrderan = async (req, res, next) => {
  try {
    const { email } = req.driver;
    const { orderId } = req.body;
    const orderStatus = req.body.status;
    const result = await orderanService.updateStatusOrderan(
      email,
      orderId,
      orderStatus,
    );

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const updateLocationOrderan = async (req, res, next) => {
  try {
    const { email } = req.driver;
    const requestData = req.body;
    const result = await orderanService.updateLocationOrderan(
      email,
      requestData,
    );

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const sendMessage = async (req, res, next) => {
  try {
    const { email } = req.driver;
    const { orderId } = req.body;
    const { message } = req.body;

    const result = await orderanService.sendMessage(email, orderId, message);

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const sendReport = async (req, res, next) => {
  try {
    const { email } = req.driver;
    const { orderId } = req.body;
    const { message } = req.body;

    const result = await orderanService.sendReport(email, orderId, message);

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const sendReview = async (req, res, next) => {
  try {
    const { email } = req.driver;
    const { orderId } = req.body;
    const { rating } = req.body;
    const { review } = req.body;

    const result = await orderanService.sendReview(
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
  getCurrentOrderan,
  rejectOrderan,
  acceptOrderan,
  cancelOrderan,
  getHistoryOrderan,
  updateStatusOrderan,
  updateLocationOrderan,
  sendMessage,
  sendReport,
  sendReview,
};
