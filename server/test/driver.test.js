import supertest from "supertest";
import { logger } from "../src/application/logging.js";
import { web } from "../src/application/web";

// testing to register driver
describe("POST /api/drivers", function () {
  it("should can register new driver", async () => {
    const result = await supertest(web).post("/api/drivers").send({
      email: "crystalezord@gmail.com",
      name: "masrudini",
      noMembership: "member123",
      licensePlate: "AB 1234 CD",
      phoneNumber: "082122562049",
      password: "masrudini@01",
    });

    logger.info(result.body.data);
    expect(result.status).toBe(200);
    expect(result.body.data.email).toBe("crystalezord@gmail.com");
    expect(result.body.data.password).toBeUndefined();
  });
});

// testing to resend OTP

describe("POST /api/drivers/resendOTPEmailRegister", function () {
  it("should can resend OTP email register", async () => {
    const result = await supertest(web)
      .post("/api/drivers/resendOTPEmailRegister")
      .send({
        email: "crystarore08@gmail.com",
      });

    logger.info(result.body);
    expect(result.status).toBe(200);
    expect(result.body.data.email).toBe("crystarore08@gmail.com");
  });
});

// testing to verify email with OTP
describe("POST /api/drivers/verificationEmailRegister", function () {
  it("should can verify email register using OTP", async () => {
    const result = await supertest(web)
      .post("/api/drivers/verificationEmailRegister")
      .send({
        email: "crystalezord@gmail.com",
        otp: "9872",
      });

    logger.info(result.body);
    expect(result.status).toBe(200);
    expect(result.body.data.email).toBe("crystalezord@gmail.com");
  });
});

// testing to forgot password

describe("POST /api/drivers/forgotPassword", function () {
  it("should can do forgot password", async () => {
    const result = await supertest(web)
      .post("/api/drivers/forgotPassword")
      .send({
        email: "crystarore08@gmail.com",
      });

    logger.info(result.body);
    expect(result.status).toBe(200);
    expect(result.body.data.email).toBe("crystarore08@gmail.com");
  });
});

// testing to resend OTP forgot password

describe("POST /api/drivers/resendOTPEmailForgotPassword", function () {
  it("should can resend OTP email forgot password", async () => {
    const result = await supertest(web)
      .post("/api/drivers/resendOTPEmailForgotPassword")
      .send({
        email: "crystarore08@gmail.com",
      });

    logger.info(result.body);
    expect(result.status).toBe(200);
    expect(result.body.data.email).toBe("crystarore08@gmail.com");
  });
});

// testing to verification email forgot password

describe("POST /api/drivers/verificationEmailForgotPassword", function () {
  it("should can verify email forgot password", async () => {
    const result = await supertest(web)
      .post("/api/drivers/verificationEmailForgotPassword")
      .send({
        email: "crystarore08@gmail.com",
        otp: "3993",
      });

    logger.info(result.body);
    expect(result.status).toBe(200);
    expect(result.body.data.email).toBe("crystarore08@gmail.com");
  });
});

// testing to verification email forgot password

describe("PATCH /api/drivers/resetPassword", function () {
  it("should can reset password", async () => {
    const result = await supertest(web)
      .patch("/api/drivers/resetPassword")
      .send({
        email: "crystarore08@gmail.com",
        password: "russy@08",
      });

    logger.info(result.body);
    expect(result.status).toBe(200);
    expect(result.body.data.email).toBe("crystarore08@gmail.com");
  });
});

// testing login

describe("POST /api/drivers/login", function () {
  it("should can login", async () => {
    const result = await supertest(web).post("/api/drivers/login").send({
      email: "crystalezord@gmail.com",
      password: "masrudini@01",
    });

    logger.info(result.body);

    expect(result.status).toBe(200);
    expect(result.body.data.token).toBeDefined();
    expect(result.body.data.token).not.toBe("test");
  });
});

// check authentication

describe("GET /api/drivers/checkAuthentication", function () {
  it("should can check authentication", async () => {
    const result = await supertest(web)
      .get("/api/drivers/checkAuthentication")
      .set("Authorization", "d0453847-6a1d-4e2e-9b14-a9e5a6aa0972");

    logger.info(result.body);
    expect(result.status).toBe(200);
    expect(result.body.data.token).toBeDefined();
    expect(result.body.data.token).not.toBe("test");
  });
});

// testing get data

describe("GET /api/drivers/current", function () {
  it("should can check authentication", async () => {
    const result = await supertest(web)
      .get("/api/drivers/current")
      .set("Authorization", "d0453847-6a1d-4e2e-9b14-a9e5a6aa0972");

    logger.info(result.body);
    expect(result.status).toBe(200);
    expect(result.body.data.token).toBeDefined();
  });
});

// testing update driver data

// testing update driver location

describe("PATCH /api/drivers/updateLocation", function () {
  it("should can update location", async () => {
    const result = await supertest(web)
      .patch("/api/drivers/updateLocation")
      .set("Authorization", "7bb9cee9-b556-4038-9808-0b0ebefbdb27")
      .send({
        latitude: -0.038002,
        longitude: 109.310296,
      });

    logger.info(result.body);
    expect(result.status).toBe(200);
  });
});

// testing change password

describe("PATCH /api/drivers/changePassword", function () {
  it("should can check authentication", async () => {
    const result = await supertest(web)
      .patch("/api/drivers/changePassword")
      .set("Authorization", "9b1b8495-ca86-4e9a-a237-d71290c335ab")
      .send({
        oldPassword: "russy@08",
        newPassword: "russy@01",
      });

    logger.info(result.body);
    expect(result.status).toBe(200);
    expect(result.body.data.token).toBeDefined();
  });
});

// update device token

describe("PATCH /api/drivers/updateDeviceToken", function () {
  it("should can update location", async () => {
    const result = await supertest(web)
      .patch("/api/drivers/updateDeviceToken")
      .set("Authorization", "ec75162f-b56a-4326-b8b1-5c2900661306")
      .send({
        deviceToken:
          "e7Tk2qWARPG-bW6nN36owM:APA91bHWDaYowTQ3CUbBxSjNKpqtsPLLOJrZHuVtYNFNxUzad2jG0c3nJW3w_vNqtAqqRuMHPmB4F7bLxZW6SeKmevxBn474C9SThN1-nu7AnZmp2A7w-3dg3X0lWLLDslGwsDALCgXS",
      });

    logger.info(result.body);
    expect(result.status).toBe(200);
  });
});

// testing logout

describe("DELETE /api/drivers/logout", function () {
  it("should can logout", async () => {
    const result = await supertest(web)
      .delete("/api/drivers/logout")
      .set("Authorization", "0c38578e-f922-4d50-ae5a-194bbf50de82");

    expect(result.status).toBe(200);
    expect(result.body.data).toBe("OK");
  });
});
