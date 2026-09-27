// add ride by driver

import rideService from '../service/ride-service.js';

const getCurrentRide = async (req, res, next) => {
  try {
    const { email } = req.driver;
    const result = await rideService.getCurrentRide(email);

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const addRide = async (req, res, next) => {
  try {
    const { email } = req.driver;
    const requestData = req.body;

    const result = await rideService.addRide(email, requestData);
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const completeRide = async (req, res, next) => {
  try {
    const { email } = req.driver;
    const { rideId } = req.body;

    const result = await rideService.completeRide(email, rideId);

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const cancelRide = async (req, res, next) => {
  try {
    const { email } = req.driver;
    const { rideId } = req.body;

    const result = await rideService.cancelRide(email, rideId);

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const completeAndCloseRide = async (req, res, next) => {
  try {
    const { email } = req.driver;
    const { rideId } = req.body;

    const result = await rideService.completeAndCloseRide(email, rideId);

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const getHistoryRide = async (req, res, next) => {
  try {
    const { email } = req.driver;
    const result = await rideService.getHistoryRide(email);

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

export default {
  getCurrentRide,
  addRide,
  completeRide,
  completeAndCloseRide,
  cancelRide,
  getHistoryRide,
};
