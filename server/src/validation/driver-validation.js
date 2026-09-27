import Joi from 'joi';

const registerDriverValidation = Joi.object({
  email: Joi.string().email().required(),
  name: Joi.string().required(),
  noMembership: Joi.string().required(),
  licensePlate: Joi.string().required(),
  phoneNumber: Joi.string().required(),
  password: Joi.string().required(),
});

const resendOTPEmailRegisterDriverValidation = Joi.object({
  email: Joi.string().email().required(),
});

const verificationEmailRegisterDriverValidation = Joi.object({
  email: Joi.string().email().required(),
  otp: Joi.string()
    .length(4)
    .pattern(/^[0-9]+$/)
    .required(),
});

const forgotPasswordDriverValidation = Joi.object({
  email: Joi.string().email().required(),
});

const resendOTPEmailForgotPasswordDriverValidation = Joi.object({
  email: Joi.string().email().required(),
});

const verificationEmailForgotPasswordDriverValidation = Joi.object({
  email: Joi.string().email().required(),
  otp: Joi.string()
    .length(4)
    .pattern(/^[0-9]+$/)
    .required(),
});

const resetPasswordDriverValidation = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().required(),
});

const loginDriverValidation = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().required(),
});

const checkAuthenticationDriverValidation = Joi.string().email().required();

const getDriverValidation = Joi.string().email().required();

const updateDriverValidation = Joi.object({
  noMembership: Joi.string().required(),
  licensePlate: Joi.string().required(),
  email: Joi.string().email().required(),
  name: Joi.string().required(),
  phoneNumber: Joi.string().required(),
});

const updateLocationDriverValidation = Joi.object({
  latitude: Joi.number().required(),
  longitude: Joi.number().required(),
});

const changePasswordDriverValidation = Joi.object({
  oldPassword: Joi.string().required(),
  newPassword: Joi.string().required().disallow(Joi.ref('oldPassword')),
});

const updateDeviceTokenDriverValidation = Joi.object({
  deviceToken: Joi.string().required(),
});

export {
  registerDriverValidation,
  resendOTPEmailRegisterDriverValidation,
  verificationEmailRegisterDriverValidation,
  forgotPasswordDriverValidation,
  resendOTPEmailForgotPasswordDriverValidation,
  verificationEmailForgotPasswordDriverValidation,
  resetPasswordDriverValidation,
  loginDriverValidation,
  checkAuthenticationDriverValidation,
  getDriverValidation,
  updateDriverValidation,
  updateLocationDriverValidation,
  changePasswordDriverValidation,
  updateDeviceTokenDriverValidation,
};
