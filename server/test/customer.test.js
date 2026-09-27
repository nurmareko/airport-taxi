import supertest from "supertest";
import { logger } from "../src/application/logging.js";
import { web } from "../src/application/web";

// testing to register customer
describe("POST /api/customers", function () {
  it("should can register new customer", async () => {
    const result = await supertest(web).post("/api/customers").send({
      email: "russypranataa@gmail.com",
      name: "alhymnirussy",
      phoneNumber: "0895338170582",
      password: "password123",
    });

    logger.info(result.body.data);
    expect(result.status).toBe(200);
    expect(result.body.data.email).toBe("russypranata@gmail.com");
    expect(result.body.data.password).toBeUndefined();
  });

  it("should reject the registration if the email is already registered (email verified)", async () => {
    const result = await supertest(web).post("/api/customers").send({
      email: "ralhymni@gmail.com",
      name: "alhymnirussy",
      phoneNumber: "+6295338170582",
      password: "password123",
    });

    logger.info(result.body);
    expect(result.status).toBe(400);
    // expect(result.body.errors).toBeDefined();
  });

  it("registration if the email is already registered (email not verified)", async () => {
    const result = await supertest(web).post("/api/customers").send({
      email: "russypranata@gmail.com",
      name: "alhymnirussy",
      phoneNumber: "+6295338170582",
      password: "password123",
    });

    logger.info(result.body);
    expect(result.status).toBe(400);
    expect(result.body.errors).toBeUndefined();
  });
});

// testing to verify email with OTP
describe("POST /api/customers/verificationEmailRegister", function () {
  it("should can verify email using OTP", async () => {
    const result = await supertest(web)
      .post("/api/customers/verificationEmailRegister")
      .send({
        email: "russypranata@gmail.com",
        otp: "4365",
      });

    logger.info(result.body.email);
    expect(result.status).toBe(200);
    expect(result.body.data.email).toBe("russypranata@gmail.com");
  });
});

// testing to resend OTP

describe("POST /api/customers/resendOTPEmailRegister", function () {
  it("should can resend OTP", async () => {
    const result = await supertest(web)
      .post("/api/customers/resendOTPEmailRegister")
      .send({
        email: "russypranata@gmail.com",
      });

    logger.info(result.body);
    expect(result.status).toBe(200);
    expect(result.body.data.email).toBe("russypranata@gmail.com");
  });
});

// testing to login

describe("POST /api/customers/login", function () {
  // beforeEach(async () => {
  //   await createTestCustomer();
  // });

  // afterEach(async () => {
  //   await removeTestCustomer();
  // });

  it("should can login", async () => {
    const result = await supertest(web).post("/api/customers/login").send({
      email: "russypranata@gmail.com",
      password: "password123",
    });

    logger.info(result.body);

    expect(result.status).toBe(200);
    expect(result.body.data.token).toBeDefined();
    expect(result.body.data.token).not.toBe("test");
  });

  it("should cant login (email not verified)", async () => {
    const result = await supertest(web).post("/api/customers/login").send({
      email: "ralhymni@gmail.com",
      password: "password123",
    });

    logger.info(result.body);

    expect(result.status).toBe(401);
    expect(result.body.errors).toBeDefined();
  });

  // if email already verified

  it("should reject login if request is invalid", async () => {
    const result = await supertest(web).post("/api/customers/login").send({
      email: "",
      password: "",
    });

    logger.info(result.body);

    expect(result.status).toBe(400);
    expect(result.body.errors).toBeDefined();
  });

  it("should reject login if email is wrong", async () => {
    const result = await supertest(web).post("/api/customers/login").send({
      email: "russy@gmail.com",
      password: "password123",
    });

    logger.info(result.body);

    expect(result.status).toBe(401);
    expect(result.body.errors).toBeDefined();
  });

  it("should reject login if password is wrong", async () => {
    const result = await supertest(web).post("/api/customers/login").send({
      email: "ralhymni@gmail.com",
      password: "salah",
    });

    logger.info(result.body);

    expect(result.status).toBe(401);
    expect(result.body.errors).toBeDefined();
  });
});

// testing check authentication

describe("GET /api/customers/checkAuthentication", function () {
  it("should can check authentication", async () => {
    const result = await supertest(web)
      .get("/api/customers/checkAuthentication")
      .set("Authorization", "2a3e5a9e-761a-48a5-a98a-4870281f403a");

    logger.info(result.body);
    expect(result.status).toBe(200);
    expect(result.body.data.token).toBeDefined();
    expect(result.body.data.token).not.toBe("test");
  });
});

// testing get data customer

describe("GET /api/customers/current", function () {
  it("should can get current customer", async () => {
    const result = await supertest(web)
      .get("/api/customers/current")
      .set("Authorization", "2bd3857d-2f34-4f3d-b64e-16090c085711");

    expect(result.status).toBe(200);
    expect(result.body.data.email).toBe("ralhymni@gmail.com");
    expect(result.body.data.name).toBe("alhymnirussy");
  });

  it("should reject if token is invalid", async () => {
    const result = await supertest(web)
      .get("/api/customers/current")
      .set("Authorization", "salah");

    expect(result.status).toBe(401);
    expect(result.body.errors).toBeDefined();
  });
});

// testing to update customer data

// update location

describe("PATCH /api/customers/updateLocation", function () {
  it("should can update location", async () => {
    const result = await supertest(web)
      .patch("/api/customers/updateLocation")
      .set("Authorization", "87e3fab6-0c16-45c4-9039-bf078deef7bc")
      .send({
        latitude: -0.05502,
        longitude: 109.31273,
      });

    logger.info(result.body);
    expect(result.status).toBe(200);
  });
});

// update device token

describe("PATCH /api/customers/updateDeviceToken", function () {
  it("should can update location", async () => {
    const result = await supertest(web)
      .patch("/api/customers/updateDeviceToken")
      .set("Authorization", "8d3ea914-6fd4-4ce4-8b91-1610556af142")
      .send({
        deviceToken:
          "e7Tk2qWARPG-bW6nN36owM:APA91bHWDaYowTQ3CUbBxSjNKpqtsPLLOJrZHuVtYNFNxUzad2jG0c3nJW3w_vNqtAqqRuMHPmB4F7bLxZW6SeKmevxBn474C9SThN1-nu7AnZmp2A7w-3dg3X0lWLLDslGwsDALCgXS",
      });

    logger.info(result.body);
    expect(result.status).toBe(200);
  });
});

// testing logout

describe("DELETE /api/customers/logout", function () {
  it("should can logout", async () => {
    const result = await supertest(web)
      .delete("/api/customers/logout")
      .set("Authorization", "3fb6f1ca-4533-43bb-b78a-f95b4cc411d5");

    expect(result.status).toBe(200);
    expect(result.body.data).toBe("OK");
  });

  it("should reject logout if token is invalid", async () => {
    const result = await supertest(web)
      .delete("/api/customers/logout")
      .set("Authorization", "token-salah");

    expect(result.status).toBe(401);
  });
});
