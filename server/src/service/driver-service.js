import moment from 'moment';
import bcrypt from 'bcryptjs';
import { v4 as uuid } from 'uuid';
import { initializeApp } from 'firebase/app';
import {
  getStorage,
  ref,
  getDownloadURL,
  uploadBytesResumable,
} from 'firebase/storage';
import { prismaClient } from '../application/database.js';
import { validate } from '../validation/validation.js';
import {
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
} from '../validation/driver-validation.js';
import { ResponseError } from '../error/response-error.js';
import { sendOTPRegisterDriverByEmail } from '../utils/sendEmailRegister.js';
import { sendOTPForgotPasswordDriverByEmail } from '../utils/sendEmailForgotPassword.js';
import config from '../config/firebase.config.js';

initializeApp(config.firebaseConfig);

const storage = getStorage();

const register = async (request) => {
  const driver = validate(registerDriverValidation, request);

  const countDriver = await prismaClient.driver.count({
    where: {
      email: driver.email,
    },
  });

  const driverDatabase = await prismaClient.driver.findUnique({
    where: {
      email: driver.email,
    },
  });

  if (countDriver === 1) {
    if (driverDatabase.verifiedEmail) {
      throw new ResponseError(400, 'registered', driver.email);
    }

    throw new ResponseError(400, 'unverified', driver.email);

    // return {
    //   status:'error',
    //   info: 'unverified-email',
    //   email: driver.email
    // }
  }

  const bcryptSaltRounds = 10;
  driver.password = await bcrypt.hash(driver.password, bcryptSaltRounds);

  const photo = 'https://firebasestorage.googleapis.com/v0/b/airport-taxi-sharing-ce9e9.appspot.com/o/driver_profiles%2Fprofile_default.png?alt=media&token=efa3bd81-8bff-4bf0-8868-5ea52f81afe4';
  driver.photo = photo;

  const otp = Math.floor(1000 + Math.random() * 9000).toString();
  driver.otp = otp;

  const expirationTime = moment().add(1, 'minutes').toISOString();
  driver.otpExpiry = expirationTime;

  driver.verifiedEmail = false;
  driver.status = false;

  // Kirim OTP via email
  try {
    await sendOTPRegisterDriverByEmail(driver.email, otp, driver.name);
    console.log('Email sent successfully.');
  } catch (error) {
    console.error('Error sending email:', error);
    throw new ResponseError(500, 'Internal Server Error');
  }

  return prismaClient.driver.create({
    data: driver,
    select: {
      // id: true,
      email: true,
    },
  });
};

const resendOTPEmailRegister = async (request) => {
  const { email } = validate(resendOTPEmailRegisterDriverValidation, request);

  const existingDriver = await prismaClient.driver.findUnique({
    where: {
      email,
    },
  });

  if (!existingDriver) {
    throw new ResponseError(404, 'Driver tidak ditemukan', email);
  }

  if (existingDriver.verifiedEmail) {
    throw new ResponseError(400, 'Email sudah diverifikasi', email);
  }

  const otp = Math.floor(1000 + Math.random() * 9000).toString();
  const expirationTime = moment().add(1, 'minutes').toISOString();

  try {
    await sendOTPRegisterDriverByEmail(email, otp, existingDriver.name);
    console.log('Email sent successfully.');
  } catch (error) {
    console.error('Error sending email:', error);
    throw new ResponseError(500, 'Internal Server Error');
  }

  return await prismaClient.driver.update({
    where: {
      email,
    },
    data: {
      otp,
      otpExpiry: expirationTime,
    },
    select: {
      email: true,
    },
  });
};

const verificationEmailRegister = async (request) => {
  const { email, otp } = validate(
    verificationEmailRegisterDriverValidation,
    request,
  );

  const existingDriver = await prismaClient.driver.findUnique({
    where: {
      email,
    },
  });

  if (!existingDriver) {
    throw new ResponseError(404, 'Driver tidak ditemukan', email);
  }

  if (
    existingDriver.otp != otp
    || moment(existingDriver.otpExpiry).isBefore(moment())
  ) {
    throw new ResponseError(
      400,
      'Kode OTP tidak valid atau telah kadaluarsa',
      existingDriver.email,
    );
  }

  return await prismaClient.driver.update({
    where: {
      email,
    },
    data: {
      otp: null,
      otpExpiry: null,
      verifiedEmail: true,
    },
    select: {
      email: true,
    },
  });
};

const forgotPassword = async (request) => {
  const { email } = validate(forgotPasswordDriverValidation, request);

  const existingDriver = await prismaClient.driver.findUnique({
    where: {
      email,
    },
  });

  if (!existingDriver) {
    throw new ResponseError(404, 'Driver tidak ditemukan', email);
  }

  if (!existingDriver.verifiedEmail) {
    throw new ResponseError(404, 'Driver tidak ditemukan', email);
  }

  const otp = Math.floor(1000 + Math.random() * 9000).toString();
  const expirationTime = moment().add(1, 'minutes').toISOString();

  try {
    await sendOTPForgotPasswordDriverByEmail(email, otp, existingDriver.name);
    console.log('Email sent successfully.');
  } catch (error) {
    console.error('Error sending email:', error);
    throw new ResponseError(500, 'Internal Server Error');
  }

  return await prismaClient.driver.update({
    where: {
      email,
    },
    data: {
      otp,
      otpExpiry: expirationTime,
    },
    select: {
      email: true,
    },
  });
};

const resendOTPEmailForgotPassword = async (request) => {
  const { email } = validate(
    resendOTPEmailForgotPasswordDriverValidation,
    request,
  );

  const existingDriver = await prismaClient.driver.findUnique({
    where: {
      email,
    },
  });

  if (!existingDriver) {
    throw new ResponseError(404, 'Driver tidak ditemukan', email);
  }

  const otp = Math.floor(1000 + Math.random() * 9000).toString();
  const expirationTime = moment().add(1, 'minutes').toISOString();

  try {
    await sendOTPForgotPasswordDriverByEmail(email, otp, existingDriver.name);
    console.log('Email sent successfully.');
  } catch (error) {
    console.error('Error sending email:', error);
    throw new ResponseError(500, 'Internal Server Error');
  }

  return await prismaClient.driver.update({
    where: {
      email,
    },
    data: {
      otp,
      otpExpiry: expirationTime,
    },
    select: {
      email: true,
    },
  });
};

const verificationEmailForgotPassword = async (request) => {
  const { email, otp } = validate(
    verificationEmailForgotPasswordDriverValidation,
    request,
  );

  const existingDriver = await prismaClient.driver.findUnique({
    where: {
      email,
    },
  });

  if (!existingDriver) {
    throw new ResponseError(404, 'Driver tidak ditemukan', email);
  }

  if (
    existingDriver.otp != otp
    || moment(existingDriver.otpExpiry).isBefore(moment())
  ) {
    throw new ResponseError(
      400,
      'Kode OTP tidak valid atau telah kadaluarsa',
      existingDriver.email,
    );
  }

  return await prismaClient.driver.update({
    where: {
      email,
    },
    data: {
      otp: null,
      otpExpiry: null,
    },
    select: {
      email: true,
    },
  });
};

const resetPassword = async (request) => {
  const driver = validate(resetPasswordDriverValidation, request);

  const driverDatabase = await prismaClient.driver.findUnique({
    where: {
      email: driver.email,
    },
  });

  if (!driverDatabase || !driverDatabase.verifiedEmail) {
    throw new ResponseError(400, 'Driver tidak dapat ditemukan', driver.email);
  }

  const bcryptSaltRounds = 10;
  driver.password = await bcrypt.hash(driver.password, bcryptSaltRounds);

  return prismaClient.driver.update({
    where: {
      email: driver.email,
    },
    data: {
      password: driver.password,
    },
    select: {
      email: true,
    },
  });
};

const login = async (request) => {
  const loginRequest = validate(loginDriverValidation, request);

  const driver = await prismaClient.driver.findUnique({
    where: {
      email: loginRequest.email,
    },
  });

  if (!driver) {
    throw new ResponseError(401, 'Kredensial tidak valid', loginRequest.email);
  }

  if (driver.verifiedEmail) {
    const isPasswordValid = await bcrypt.compare(
      loginRequest.password,
      driver.password,
    );

    if (!isPasswordValid) {
      throw new ResponseError(
        401,
        'Kredensial tidak valid',
        loginRequest.email,
      );
    }
    if (!driver.status) {
      throw new ResponseError(401, 'Akun Anda dinonaktifkan', loginRequest.email);
    }
    const token = uuid().toString();
    const tokenExpiry = new Date();
    tokenExpiry.setDate(tokenExpiry.getDate() + 1);

    return prismaClient.driver.update({
      data: {
        token,
        tokenExpiry,
      },
      where: {
        email: driver.email,
      },
      select: {
        token: true,
      },
    });
  }
  throw new ResponseError(401, 'Kredensial tidak valid', loginRequest.email);
};

const checkAuthentication = async (email) => {
  email = validate(checkAuthenticationDriverValidation, email);

  const driver = await prismaClient.driver.findUnique({
    where: {
      email,
    },
    select: {
      token: true,
    },
  });

  if (!driver) {
    throw new ResponseError(404, 'Driver tidak dapat ditemukan', email);
  }

  return driver;
};

const get = async (email) => {
  email = validate(getDriverValidation, email);

  const driver = await prismaClient.driver.findUnique({
    where: {
      email,
    },
    select: {
      token: true,
      email: true,
      name: true,
      noMembership: true,
      licensePlate: true,
      phoneNumber: true,
      photo: true,
      lat: true,
      long: true,
    },
  });

  if (!driver) {
    throw new ResponseError(404, 'Driver tidak dapat ditemukan', email);
  }

  return driver;
};

const update = async (requestData, requestFiles) => {
  const updateRequest = validate(updateDriverValidation, requestData);

  const driver = await prismaClient.driver.findUnique({
    where: {
      email: updateRequest.email,
    },
  });

  if (!driver) {
    throw new ResponseError(
      404,
      'Driver tidak dapat ditemukan',
      updateRequest.email,
    );
  }

  const updatedDriverData = {
    noMembership: updateRequest.noMembership,
    licensePlate: updateRequest.licensePlate,
    name: updateRequest.name,
    phoneNumber: updateRequest.phoneNumber,
  };

  if (requestFiles) {
    const dateTime = giveCurrentDateTime();

    const storageRef = ref(
      storage,
      `driver_profiles/${`${requestFiles.originalname} ${dateTime}`}`,
    );

    const metadata = {
      contentType: 'image/jpeg',
    };

    // Upload the file to Firebase Storage
    const snapshot = await uploadBytesResumable(
      storageRef,
      requestFiles.buffer,
      metadata,
    );

    const imageURL = await getDownloadURL(snapshot.ref);

    updatedDriverData.photo = imageURL;
  }

  const updatedDriver = await prismaClient.driver.update({
    where: {
      email: driver.email,
    },
    data: updatedDriverData,
    select: {
      email: true,
    },
  });

  return updatedDriver;
};

const giveCurrentDateTime = () => {
  const today = new Date();
  const date = `${today.getFullYear()}-${today.getMonth() + 1}-${today.getDate()}`;
  const time = `${today.getHours()}:${today.getMinutes()}:${today.getSeconds()}`;
  const dateTime = `${date} ${time}`;
  return dateTime;
};

const updateLocation = async (email, requestData) => {
  const updateLocationRequest = validate(
    updateLocationDriverValidation,
    requestData,
  );

  const driver = await prismaClient.driver.findUnique({
    where: {
      email,
    },
  });

  if (!driver) {
    throw new ResponseError(
      404,
      'Driver tidak dapat ditemukan',
      updateRequest.email,
    );
  }

  const data = {
    lat: updateLocationRequest.latitude,
    long: updateLocationRequest.longitude,
  };
  const updatedDriver = await prismaClient.driver.update({
    where: {
      email: driver.email,
    },
    data,
    select: {
      email: true,
    },
  });

  return updatedDriver;
};

const updateDeviceToken = async (email, requestData) => {
  const updateDeviceTokenRequest = validate(
    updateDeviceTokenDriverValidation,
    requestData,
  );

  const driver = await prismaClient.driver.findUnique({
    where: {
      email,
    },
  });

  if (!driver) {
    throw new ResponseError(
      404,
      'Driver tidak dapat ditemukan',
      updateDeviceTokenRequest.email,
    );
  }

  const data = {
    deviceToken: updateDeviceTokenRequest.deviceToken,
  };
  const updatedDriver = await prismaClient.driver.update({
    where: {
      email: driver.email,
    },
    data,
    select: {
      deviceToken: true,
    },
  });

  return updatedDriver;
};

const changePassword = async (email, request) => {
  const changePasswordRequest = validate(
    changePasswordDriverValidation,
    request,
  );

  const driver = await prismaClient.driver.findUnique({
    where: {
      email,
    },
  });

  if (!driver) {
    throw new ResponseError(404, 'Driver tidak ditemukan', email);
  }

  const isOldPasswordValid = await bcrypt.compare(
    changePasswordRequest.oldPassword,
    driver.password,
  );

  if (!isOldPasswordValid) {
    throw new ResponseError(401, 'Password lama tidak valid', driver.email);
  }

  const newPasswordHash = await bcrypt.hash(
    changePasswordRequest.newPassword,
    10,
  );

  const updatedDriver = await prismaClient.driver.update({
    where: {
      email: driver.email,
    },
    data: {
      password: newPasswordHash,
    },
  });

  return updatedDriver;
};

const logout = async (email) => {
  email = validate(getDriverValidation, email);

  const driver = await prismaClient.driver.findUnique({
    where: {
      email,
    },
  });

  if (!driver) {
    throw new ResponseError(404, 'Driver tidak ditemukan');
  }

  return prismaClient.driver.update({
    where: {
      email,
    },
    data: {
      token: null,
    },
  });
};

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
