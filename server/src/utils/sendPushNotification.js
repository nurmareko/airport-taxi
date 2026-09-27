import admin from "firebase-admin";
import { readFileSync } from "fs";

// Membaca dan menginisialisasi Firebase Admin SDK
const serviceAccount = JSON.parse(
  readFileSync("./src/config/push-notification-key.json")
);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: "airport-taxi-sharing-ce9e9",
});

/**
 * Fungsi untuk mengirim notifikasi push
 * @param {string} title - Judul notifikasi
 * @param {string} body - Isi notifikasi
 * @param {string} token - Token perangkat yang akan menerima notifikasi
 * @param {object} data - Data tambahan (opsional, misalnya orderId)
 * @returns {Promise<void>}
 */
const sendPushNotification = async (title, body, token, data = {}) => {
  // Konversi semua nilai dalam data menjadi string
  const stringifiedData = Object.fromEntries(
    Object.entries(data).map(([key, value]) => [key, String(value)])
  );

  const message = {
    notification: {
      title,
      body,
    },
    token,
    data: stringifiedData,
  };

  console.log("Sending message with payload:", JSON.stringify(message, null, 2)); // Logging payload data

  try {
    const response = await admin.messaging().send(message);
    console.log("Successfully sent message:", response);
  } catch (error) {
    console.error("Error sending message:", error);
  }
};

export default sendPushNotification;
