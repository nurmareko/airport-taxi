import supertest from "supertest";
import { logger } from "../src/application/logging.js";
import { web } from "../src/application/web.js";

// orderan by driver

describe("GET /api/drivers/orders/getCurrentOrderan", function () {
  it("should can reject orderan by driver", async () => {
    const result = await supertest(web)
      .get("/api/drivers/orders/getCurrentOrderan")
      .set("Authorization", "20a816bf-57bb-4f12-a7c4-eb3c449ab6d5");

    console.log(result.error);
    expect(result.status).toBe(200);
    console.dir(result.body);
    logger.info(result.body);
  });
});

// reject orderan
describe("PATCH /api/drivers/orders/rejectOrderan", function () {
  it("should can reject orderan by driver", async () => {
    const result = await supertest(web)
      .patch("/api/drivers/orders/rejectOrderan")
      .set("Authorization", "f469bab8-01f7-4f65-907b-1ab79ea15b08")
      .send({
        orderId: 6,
      });

    console.log(result.error);
    expect(result.status).toBe(200);
    console.dir(result.body);
    logger.info(result.body);
  });
});

// accept orderan

describe("PATCH /api/drivers/orders/acceptOrderan", function () {
  it("should can accept orderan by driver", async () => {
    const result = await supertest(web)
      .patch("/api/drivers/orders/acceptOrderan")
      .set("Authorization", "327b068b-1f18-4072-bf8d-5cf7791be286")
      .send({
        orderId: "ORD-000002",
      });

    console.log(result.error);
    expect(result.status).toBe(200);
    console.dir(result.body);
    logger.info(result.body);
  });
});

// cancel orderan

describe("PATCH /api/drivers/orders/cancelOrderan", function () {
  it("should can cancel orderan by driver", async () => {
    const result = await supertest(web)
      .patch("/api/drivers/orders/cancelOrderan")
      .set("Authorization", "f469bab8-01f7-4f65-907b-1ab79ea15b08")
      .send({
        orderId: 3,
      });

    console.log(result.error);
    expect(result.status).toBe(200);
    console.dir(result.body);
    logger.info(result.body);
  });
});

// get history orderan

describe("GET /api/drivers/orders/getHistoryOrderan", function () {
  it("should can reject orderan by driver", async () => {
    const result = await supertest(web)
      .get("/api/drivers/orders/getHistoryOrderan")
      .set("Authorization", "05c709a8-4ef1-4835-aaef-cf82ae1aea9e");

    console.log(result.error);
    expect(result.status).toBe(200);
    console.dir(result.body);
    logger.info(result.body);
  });
});

// update status orderan

describe("PATCH /api/drivers/orders/updateStatusOrderan", function () {
  it("should can update status orderan by driver", async () => {
    const result = await supertest(web)
      .patch("/api/drivers/orders/updateStatusOrderan")
      .set("Authorization", "327b068b-1f18-4072-bf8d-5cf7791be286")
      .send({
        orderId: "ORD-000002",
        status: 2,
      });

    console.log(result.error);
    expect(result.status).toBe(200);
    console.dir(result.body);
    logger.info(result.body);
  });
});

// update location orderan

describe("PATCH /api/drivers/orders/updateLocationOrderan", function () {
  it("should can update location orderan by driver", async () => {
    const result = await supertest(web)
      .patch("/api/drivers/orders/updateLocationOrderan")
      .set("Authorization", "0453cd5e-1186-443b-83d9-fc6fdd420c62")
      .send({
        latitude: -0.050177,
        longitude: 109.337025,
      });

    console.log(result.error);
    expect(result.status).toBe(200);
    console.dir(result.body);
    logger.info(result.body);
  });
});

// send message

describe("POST /api/drivers/orders/sendMessage", function () {
  it("should can send message by driver", async () => {
    const result = await supertest(web)
      .post("/api/drivers/orders/sendMessage")
      .set("Authorization", "d29bd4ec-d0aa-4022-9111-6801a4256409")
      .send({
        orderId: 1,
        message:
          "halo kak russy, saya batalkan ya soalnya ban saya bocor, bisa di coba untuk cari taksi yang lain ya kak, mohon maaf.",
      });

    console.log(result.error);
    expect(result.status).toBe(200);
    console.dir(result.body);
    logger.info(result.body);
  });
});

// send report
describe("POST /api/drivers/orders/sendReport", function () {
  it("should allow a driver to send report", async () => {
    const result = await supertest(web)
      .post("/api/drivers/orders/sendReport")
      .set("Authorization", "05c709a8-4ef1-4835-aaef-cf82ae1aea9e")
      .send({
        orderId: 2,
        message:
          "halo kak, maaf saya batalkan soalnya nenek dari tetangganya sepupu dari anak tetanggga saya lahiran kak, maaf.",
      });

    console.log(result.error);
    expect(result.status).toBe(200);
    console.dir(result.body);
    logger.info(result.body);
  });
});

// send review

describe("PATCH /api/drivers/orders/sendReview", function () {
  it("should can send review by driver", async () => {
    const result = await supertest(web)
      .patch("/api/drivers/orders/sendReview")
      .set("Authorization", "05c709a8-4ef1-4835-aaef-cf82ae1aea9e")
      .send({
        orderId: 2,
        rating: 5,
        review: "Ramah, tamah, dan suka berbagi, i love u ",
      });

    console.log(result.error);
    expect(result.status).toBe(200);
    console.dir(result.body);
    logger.info(result.body);
  });
});
