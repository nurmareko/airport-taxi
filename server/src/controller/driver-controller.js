// register account

import driverService from "../service/driver-service.js";

const register = async (req, res, next) => {
  try {
    const result = await driverService.register(req.body);
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

// verification email (account)

const verificationEmailRegister = async (req, res, next) => {
  try {
    const result = await driverService.verificationEmailRegister(req.body);
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

// resend otp register

const resendOTPEmailRegister = async (req, res, next) => {
  try {
    const result = await driverService.resendOTPEmailRegister(req.body);
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

// forgot password

const forgotPassword = async (req, res, next) => {
  try {
    const result = await driverService.forgotPassword(req.body);
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

// resend otp forgot password

const resendOTPEmailForgotPassword = async (req, res, next) => {
  try {
    const result = await driverService.resendOTPEmailForgotPassword(req.body);
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

// verification email forgot password

const verificationEmailForgotPassword = async (req, res, next) => {
  try {
    const result = await driverService.verificationEmailForgotPassword(
      req.body
    );
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const resetPassword = async (req, res, next) => {
  try {
    const result = await driverService.resetPassword(req.body);
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

// login

const login = async (req, res, next) => {
  try {
    const result = await driverService.login(req.body);
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

// isAuthenticated

const checkAuthentication = async (req, res, next) => {
  try {
    const result = await driverService.checkAuthentication(req.driver.email);
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

// get data

const get = async (req, res, next) => {
  try {
    const email = req.driver.email;
    const result = await driverService.get(email);
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

// update

const update = async (req, res, next) => {
  try {
    // if (!req.file) {
    //   console.log("No file received");
    //   return res.send({
    //     success: false,
    //   });
    // } else {
    //   console.log(req.file);
    //   return res.send({
    //     success: true,
    //   });
    // }
    const email = req.driver.email;
    const requestData = req.body;

    // Memperbarui data email pada permintaan dengan email pelanggan
    requestData.email = email;

    const requestFiles = req.file;
    console.log(requestFiles);

    // Memanggil service untuk memperbarui data pelanggan
    const result = await driverService.update(requestData, requestFiles);

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

// update location
const updateLocation = async (req, res, next) => {
  try {
    const email = req.driver.email;
    const requestData = req.body;
    const result = await driverService.updateLocation(email, requestData);

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const updateDeviceToken = async (req, res, next) => {
  try {
    const email = req.driver.email;
    const requestData = req.body;
    const result = await driverService.updateDeviceToken(email, requestData);

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

// change password

const changePassword = async (req, res, next) => {
  try {
    const email = req.driver.email;
    const result = await driverService.changePassword(email, req.body);

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

// logout

const logout = async (req, res, next) => {
  try {
    await driverService.logout(req.driver.email);
    res.status(200).json({
      data: "OK",
    });
  } catch (e) {
    next(e);
  }
};

// update location
export default {
  register,
  verificationEmailRegister,
  resendOTPEmailRegister,
  forgotPassword,
  resendOTPEmailForgotPassword,
  verificationEmailForgotPassword,
  resetPassword,
  login,
  checkAuthentication,
  get,
  update,
  updateLocation,
  updateDeviceToken,
  changePassword,
  logout,
};
