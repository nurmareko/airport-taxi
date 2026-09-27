import { validate } from "../validation/validation.js";
import {
  registerCustomerValidation,
  resendOTPEmailRegisterCustomerValidation,
  verificationEmailRegisterCustomerValidation,
  forgotPasswordCustomerValidation,
  verificationEmailForgotPasswordCustomerValidation,
  resendOTPEmailForgotPasswordCustomerValidation,
  resetPasswordCustomerValidation,
  loginCustomerValidation,
  checkAuthenticationCustomerValidation,
  getCustomerValidation,
  updateCustomerValidation,
  changePasswordCustomerValidation,
  updateLocationCustomerValidation,
  updateDeviceTokenCustomerValidation,
} from "../validation/customer-validation.js";
import { prismaClient } from "../application/database.js";
import { ResponseError } from "../error/response-error.js";
import moment from "moment";
import bcrypt from "bcryptjs";
import { v4 as uuid } from "uuid";
import { sendOTPRegisterCustomerByEmail } from "../utils/sendEmailRegister.js";
import { sendOTPForgotPasswordCustomerByEmail } from "../utils/sendEmailForgotPassword.js";
import { initializeApp } from "firebase/app";
import {
  getStorage,
  ref,
  getDownloadURL,
  uploadBytesResumable,
} from "firebase/storage";
import config from "../config/firebase.config.js";

initializeApp(config.firebaseConfig);

const storage = getStorage();

const register = async (request) => {
  const customer = validate(registerCustomerValidation, request);

  const countCustomer = await prismaClient.customer.count({
    where: {
      email: customer.email,
    },
  });

  const customerDatabase = await prismaClient.customer.findUnique({
    where: {
      email: customer.email,
    },
  });

  if (countCustomer === 1) {
    if (customerDatabase.verifiedEmail) {
      throw new ResponseError(400, "registered", customer.email);
    }

    throw new ResponseError(400, "unverified", customer.email);

    // return {
    //   status:'error',
    //   info: 'unverified-email',
    //   email: customer.email
    // }
  }

  const bcryptSaltRounds = 10;
  customer.password = await bcrypt.hash(customer.password, bcryptSaltRounds);

  const photo =
    "https://firebasestorage.googleapis.com/v0/b/airport-taxi-sharing-ce9e9.appspot.com/o/customer_profiles%2Fprofile_default.png?alt=media&token=0f07b40a-0f19-4229-9d37-084ec3414336";
  customer.photo = photo;

  const otp = Math.floor(1000 + Math.random() * 9000).toString();
  customer.otp = otp;

  const expirationTime = moment().add(1, "minutes").toISOString();
  customer.otpExpiry = expirationTime;

  customer.verifiedEmail = false;
  customer.status = false;

  // Kirim OTP via email
  try {
    await sendOTPRegisterCustomerByEmail(customer.email, otp, customer.name);
    console.log("Email sent successfully.");
  } catch (error) {
    console.error("Error sending email:", error);
    throw new ResponseError(500, "Internal Server Error");
  }

  return prismaClient.customer.create({
    data: customer,
    select: {
      // id: true,
      email: true,
    },
  });
};

const resendOTPEmailRegister = async (request) => {
  const { email } = validate(resendOTPEmailRegisterCustomerValidation, request);

  const existingCustomer = await prismaClient.customer.findUnique({
    where: {
      email: email,
    },
  });

  if (!existingCustomer) {
    throw new ResponseError(404, "Customer tidak ditemukan", email);
  }

  if (existingCustomer.verifiedEmail) {
    throw new ResponseError(400, "Email sudah diverifikasi", email);
  }

  const otp = Math.floor(1000 + Math.random() * 9000).toString();
  const expirationTime = moment().add(1, "minutes").toISOString();

  try {
    await sendOTPRegisterCustomerByEmail(email, otp, existingCustomer.name);
    console.log("Email sent successfully.");
  } catch (error) {
    console.error("Error sending email:", error);
    throw new ResponseError(500, "Internal Server Error");
  }

  return await prismaClient.customer.update({
    where: {
      email: email,
    },
    data: {
      otp: otp,
      otpExpiry: expirationTime,
    },
    select: {
      email: true,
    },
  });
};

const verificationEmailRegister = async (request) => {
  const { email, otp } = validate(
    verificationEmailRegisterCustomerValidation,
    request
  );

  const existingCustomer = await prismaClient.customer.findUnique({
    where: {
      email: email,
    },
  });

  if (!existingCustomer) {
    throw new ResponseError(404, "Customer tidak ditemukan", email);
  }

  if (
    existingCustomer.otp != otp ||
    moment(existingCustomer.otpExpiry).isBefore(moment())
  ) {
    throw new ResponseError(
      400,
      "Kode OTP tidak valid atau telah kadaluarsa",
      existingCustomer.email
    );
  }

  return await prismaClient.customer.update({
    where: {
      email: email,
    },
    data: {
      otp: null,
      otpExpiry: null,
      verifiedEmail: true,
      status: true,
    },
    select: {
      email: true,
    },
  });
};

const forgotPassword = async (request) => {
  const { email } = validate(forgotPasswordCustomerValidation, request);

  const existingCustomer = await prismaClient.customer.findUnique({
    where: {
      email: email,
    },
  });

  if (!existingCustomer) {
    throw new ResponseError(404, "Customer tidak ditemukan", email);
  }

  if (!existingCustomer.verifiedEmail) {
    throw new ResponseError(404, "Customer tidak ditemukan", email);
  }

  const otp = Math.floor(1000 + Math.random() * 9000).toString();
  const expirationTime = moment().add(1, "minutes").toISOString();

  try {
    await sendOTPForgotPasswordCustomerByEmail(
      email,
      otp,
      existingCustomer.name
    );
    console.log("Email sent successfully.");
  } catch (error) {
    console.error("Error sending email:", error);
    throw new ResponseError(500, "Internal Server Error");
  }

  return await prismaClient.customer.update({
    where: {
      email: email,
    },
    data: {
      otp: otp,
      otpExpiry: expirationTime,
    },
    select: {
      email: true,
    },
  });
};
const resendOTPEmailForgotPassword = async (request) => {
  const { email } = validate(
    resendOTPEmailForgotPasswordCustomerValidation,
    request
  );

  const existingCustomer = await prismaClient.customer.findUnique({
    where: {
      email: email,
    },
  });

  if (!existingCustomer) {
    throw new ResponseError(404, "Customer tidak ditemukan", email);
  }

  const otp = Math.floor(1000 + Math.random() * 9000).toString();
  const expirationTime = moment().add(1, "minutes").toISOString();

  try {
    await sendOTPForgotPasswordCustomerByEmail(
      email,
      otp,
      existingCustomer.name
    );
    console.log("Email sent successfully.");
  } catch (error) {
    console.error("Error sending email:", error);
    throw new ResponseError(500, "Internal Server Error");
  }

  return await prismaClient.customer.update({
    where: {
      email: email,
    },
    data: {
      otp: otp,
      otpExpiry: expirationTime,
    },
    select: {
      email: true,
    },
  });
};

const verificationEmailForgotPassword = async (request) => {
  const { email, otp } = validate(
    verificationEmailForgotPasswordCustomerValidation,
    request
  );

  const existingCustomer = await prismaClient.customer.findUnique({
    where: {
      email: email,
    },
  });

  if (!existingCustomer) {
    throw new ResponseError(404, "Customer tidak ditemukan", email);
  }

  if (
    existingCustomer.otp != otp ||
    moment(existingCustomer.otpExpiry).isBefore(moment())
  ) {
    throw new ResponseError(
      400,
      "Kode OTP tidak valid atau telah kadaluarsa",
      existingCustomer.email
    );
  }

  return await prismaClient.customer.update({
    where: {
      email: email,
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
  const customer = validate(resetPasswordCustomerValidation, request);

  const customerDatabase = await prismaClient.customer.findUnique({
    where: {
      email: customer.email,
    },
  });

  if (!customerDatabase || !customerDatabase.verifiedEmail) {
    throw new ResponseError(
      400,
      "customer tidak dapat ditemukan",
      customer.email
    );
  }

  const bcryptSaltRounds = 10;
  customer.password = await bcrypt.hash(customer.password, bcryptSaltRounds);

  return prismaClient.customer.update({
    where: {
      email: customer.email,
    },
    data: {
      password: customer.password,
    },
    select: {
      email: true,
    },
  });
};

const login = async (request) => {
  const loginRequest = validate(loginCustomerValidation, request);

  const customer = await prismaClient.customer.findUnique({
    where: {
      email: loginRequest.email,
    },
  });

  if (!customer) {
    throw new ResponseError(401, "Kredensial tidak valid", loginRequest.email);
  }

  if (customer.status === false) {
    throw new ResponseError(403, "Akun Anda dinonaktifkan", loginRequest.email);
  }

  if (customer.verifiedEmail) {
    const isPasswordValid = await bcrypt.compare(
      loginRequest.password,
      customer.password
    );

    if (!isPasswordValid) {
      throw new ResponseError(
        401,
        "Kredensial tidak valid",
        loginRequest.email
      );
    }

    const token = uuid().toString();
    const tokenExpiry = new Date();
    tokenExpiry.setDate(tokenExpiry.getDate() + 1);

    return prismaClient.customer.update({
      data: {
        token: token,
        tokenExpiry: tokenExpiry,
      },
      where: {
        email: customer.email,
      },
      select: {
        token: true,
      },
    });
  } else {
    throw new ResponseError(401, "Kredensial tidak valid", loginRequest.email);
  }
};

const checkAuthentication = async (email) => {
  email = validate(checkAuthenticationCustomerValidation, email);

  const customer = await prismaClient.customer.findUnique({
    where: {
      email: email,
    },
    select: {
      token: true,
    },
  });

  if (!customer) {
    throw new ResponseError(404, "Customer tidak dapat ditemukan", email);
  }

  return customer;
};

const get = async (email) => {
  email = validate(getCustomerValidation, email);

  const customer = await prismaClient.customer.findUnique({
    where: {
      email: email,
    },
    select: {
      token: true,
      email: true,
      name: true,
      phoneNumber: true,
      photo: true,
      lat: true,
      long: true,
    },
  });

  if (!customer) {
    throw new ResponseError(404, "Customer tidak dapat ditemukan", email);
  }

  return customer;
};

const update = async (requestData, requestFiles) => {
  const updateRequest = validate(updateCustomerValidation, requestData);

  const customer = await prismaClient.customer.findUnique({
    where: {
      email: updateRequest.email,
    },
  });

  if (!customer) {
    throw new ResponseError(
      404,
      "Customer tidak dapat ditemukan",
      updateRequest.email
    );
  }

  let updatedCustomerData = {
    name: updateRequest.name,
    phoneNumber: updateRequest.phoneNumber,
  };

  if (requestFiles) {
    const dateTime = giveCurrentDateTime();

    const storageRef = ref(
      storage,
      `customer_profiles/${requestFiles.originalname + " " + dateTime}`
    );

    const metadata = {
      contentType: "image/jpeg",
    };

    // Upload the file to Firebase Storage
    const snapshot = await uploadBytesResumable(
      storageRef,
      requestFiles.buffer,
      metadata
    );

    const imageURL = await getDownloadURL(snapshot.ref);

    updatedCustomerData.photo = imageURL;
  }

  const updatedCustomer = await prismaClient.customer.update({
    where: {
      email: customer.email,
    },
    data: updatedCustomerData,
    select: {
      email: true,
    },
  });

  return updatedCustomer;
};

const giveCurrentDateTime = () => {
  const today = new Date();
  const date =
    today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
  const time =
    today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
  const dateTime = date + " " + time;
  return dateTime;
};

const changePassword = async (email, request) => {
  const changePasswordRequest = validate(
    changePasswordCustomerValidation,
    request
  );

  const customer = await prismaClient.customer.findUnique({
    where: {
      email: email,
    },
  });

  if (!customer) {
    throw new ResponseError(404, "Customer tidak ditemukan", email);
  }

  const isOldPasswordValid = await bcrypt.compare(
    changePasswordRequest.oldPassword,
    customer.password
  );

  if (!isOldPasswordValid) {
    throw new ResponseError(401, "Password lama tidak valid", customer.email);
  }

  const newPasswordHash = await bcrypt.hash(
    changePasswordRequest.newPassword,
    10
  );

  const changePassword = await prismaClient.customer.update({
    where: {
      email: customer.email,
    },
    data: {
      password: newPasswordHash,
    },
  });

  return changePassword;
};

const updateLocation = async (email, requestData) => {
  const updateLocationRequest = validate(
    updateLocationCustomerValidation,
    requestData
  );

  const customer = await prismaClient.customer.findUnique({
    where: {
      email: email,
    },
  });

  if (!customer) {
    throw new ResponseError(
      404,
      "Customer tidak dapat ditemukan",
      updateRequest.email
    );
  }

  let data = {
    lat: updateLocationRequest.latitude,
    long: updateLocationRequest.longitude,
  };
  const updatedCustomer = await prismaClient.customer.update({
    where: {
      email: customer.email,
    },
    data: data,
    select: {
      email: true,
    },
  });

  return updatedCustomer;
};

const updateDeviceToken = async (email, requestData) => {
  const updateDeviceTokenRequest = validate(
    updateDeviceTokenCustomerValidation,
    requestData
  );

  const customer = await prismaClient.customer.findUnique({
    where: {
      email: email,
    },
  });

  if (!customer) {
    throw new ResponseError(
      404,
      "Customer tidak dapat ditemukan",
      updateDeviceTokenRequest.email
    );
  }

  let data = {
    deviceToken: updateDeviceTokenRequest.deviceToken,
  };
  const updatedCustomer = await prismaClient.customer.update({
    where: {
      email: customer.email,
    },
    data: data,
    select: {
      deviceToken: true,
    },
  });

  return updatedCustomer;
};

const logout = async (email) => {
  email = validate(getCustomerValidation, email);

  const customer = await prismaClient.customer.findUnique({
    where: {
      email: email,
    },
  });

  if (!customer) {
    throw new ResponseError(404, "customer is not found");
  }

  return prismaClient.customer.update({
    where: {
      email: email,
    },
    data: {
      token: null,
    },
    // select: {
    //   email: true,
    // },
  });
};

export default {
  register,
  resendOTPEmailRegister,
  verificationEmailRegister,
  login,
  checkAuthentication,
  forgotPassword,
  verificationEmailForgotPassword,
  resendOTPEmailForgotPassword,
  resetPassword,
  get,
  update,
  changePassword,
  updateLocation,
  updateDeviceToken,
  logout,
};
