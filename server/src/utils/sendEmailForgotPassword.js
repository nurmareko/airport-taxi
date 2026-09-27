import nodemailer from 'nodemailer';
import dotenv from 'dotenv';

dotenv.config();

const transporter = nodemailer.createTransport({
  service: 'gmail',
  host: process.env.EMAIL_HOST,
  port: process.env.EMAIL_PORT,
  secure: false,
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_APP_PASS,
  },
});

const sendOTPForgotPasswordCustomerByEmail = (email, otp, name) => {
  const mailOptions = {
    from: process.env.EMAIL_USER,
    to: email,
    subject: 'Verifikasi Email Reset Password',
    html: `
            <p>Hai ${name},</p>
            <p>Kami menerima permintaan untuk mereset password Anda. Gunakan kode verifikasi berikut:</p>
            <h1 style="text-align:center; font-size: 2em; color: #555;">${otp}</h1>
            <p>Masukkan kode ini di dalam aplikasi untuk menyelesaikan proses verifikasi.</p>
            <p>Harap tidak memberikan kode ini kepada siapa pun demi keamanan akun Anda.</p>
            <p>Jika Anda tidak meminta reset password, Anda dapat mengabaikan email ini.</p>
            <p>Terima kasih!</p>
        `,
  };

  return new Promise((resolve, reject) => {
    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        reject(error);
      } else {
        resolve(info);
      }
    });
  });
};

const sendOTPForgotPasswordDriverByEmail = (email, otp, name) => {
  const mailOptions = {
    from: process.env.EMAIL_USER,
    to: email,
    subject: 'Verifikasi Email Reset Password',
    html: `
            <p>Hai ${name},</p>
            <p>Kami menerima permintaan untuk mereset password Anda. Gunakan kode verifikasi berikut:</p>
            <h1 style="text-align:center; font-size: 2em; color: #555;">${otp}</h1>
            <p>Masukkan kode ini di dalam aplikasi untuk menyelesaikan proses verifikasi.</p>
            <p>Harap tidak memberikan kode ini kepada siapa pun demi keamanan akun Anda.</p>
            <p>Jika Anda tidak meminta reset password, Anda dapat mengabaikan email ini.</p>
            <p>Terima kasih!</p>
        `,
  };

  return new Promise((resolve, reject) => {
    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        reject(error);
      } else {
        resolve(info);
      }
    });
  });
};

export {
  sendOTPForgotPasswordCustomerByEmail,
  sendOTPForgotPasswordDriverByEmail,
};
