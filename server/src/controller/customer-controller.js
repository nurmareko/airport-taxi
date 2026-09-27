import customerService from '../service/customer-service.js';

// register account

const register = async (req, res, next) => {
  try {
    const result = await customerService.register(req.body);
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
    const result = await customerService.verificationEmailRegister(req.body);
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
    const result = await customerService.resendOTPEmailRegister(req.body);
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
    const result = await customerService.forgotPassword(req.body);
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
    const result = await customerService.resendOTPEmailForgotPassword(req.body);
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
    const result = await customerService.verificationEmailForgotPassword(
      req.body,
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
    const result = await customerService.resetPassword(req.body);
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
    const result = await customerService.login(req.body);
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
    const result = await customerService.checkAuthentication(
      req.customer.email,
    );
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
    const { email } = req.customer;
    const result = await customerService.get(email);
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

// update data

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
    const { email } = req.customer;
    const requestData = req.body;

    // Memperbarui data email pada permintaan dengan email pelanggan
    requestData.email = email;

    const requestFiles = req.file;
    console.log(requestFiles);

    // Memanggil service untuk memperbarui data pelanggan
    const result = await customerService.update(requestData, requestFiles);

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
    const { email } = req.customer;
    const result = await customerService.changePassword(email, req.body);

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
    const { email } = req.customer;
    const requestData = req.body;
    const result = await customerService.updateLocation(email, requestData);

    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

// update token device
const updateDeviceToken = async (req, res, next) => {
  try {
    const { email } = req.customer;
    const requestData = req.body;
    const result = await customerService.updateDeviceToken(email, requestData);

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
    await customerService.logout(req.customer.email);
    res.status(200).json({
      data: 'OK',
    });
  } catch (e) {
    next(e);
  }
};

export default {
  register,
  resendOTPEmailRegister,
  verificationEmailRegister,
  forgotPassword,
  verificationEmailForgotPassword,
  resendOTPEmailForgotPassword,
  resetPassword,
  login,
  checkAuthentication,
  get,
  update,
  changePassword,
  updateLocation,
  updateDeviceToken,
  logout,
};
