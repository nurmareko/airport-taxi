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

const sendOTPRegisterCustomerByEmail = (email, otp, name) => {
  const mailOptions = {
    from: process.env.EMAIL_USER,
    to: email,
    subject: 'Verifikasi Email Pendaftaran Customer',
    html: `
            <p>Hai ${name},</p>
            <p>Terima kasih telah mendaftar!</p>
            <p>Berikut adalah Kode OTP Anda untuk verifikasi:</p>
            <h1 style="text-align:center; font-size: 2em;  color: #555;">${otp}</h1>
            <p>Masukkan kode ini dalam aplikasi untuk menyelesaikan proses verifikasi.</p>
            <p>Harap jangan berikan kode ini kepada siapapun untuk menjaga keamanan akun Anda.</p>
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

const sendOTPRegisterDriverByEmail = (email, otp, name) => {
  const mailOptions = {
    from: process.env.EMAIL_USER,
    to: email,
    subject: 'Verifikasi Email Pendaftaran Driver',
    html: `
            <p>Hai ${name},</p>
            <p>Terima kasih telah mendaftar!</p>
            <p>Berikut adalah Kode OTP Anda untuk verifikasi:</p>
            <h1 style="text-align:center; font-size: 2em;  color: #555;">${otp}</h1>
            <p>Masukkan kode ini dalam aplikasi untuk menyelesaikan proses verifikasi.</p>
            <p>Harap jangan berikan kode ini kepada siapapun untuk menjaga keamanan akun Anda.</p>
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

export { sendOTPRegisterCustomerByEmail, sendOTPRegisterDriverByEmail };
