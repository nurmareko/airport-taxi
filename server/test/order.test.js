import supertest from "supertest";
import { logger } from "../src/application/logging.js";
import { web } from "../src/application/web.js";

// customer

// getting taxis within radius
describe("GET /api/customers/orders/getTaxisWithinRadius", function () {
  it("should can get taxis within radius", async () => {
    const result = await supertest(web)
      .get("/api/customers/orders/getTaxisWithinRadius")
      .set("Authorization", "c013e2ac-e05b-4d2f-9504-7d0813eacb55");

    console.log(result.error);
    expect(result.status).toBe(200);
    console.dir(result.body);
    logger.info(result.body);
  });
});

// get current order
describe("GET /api/customers/orders/getCurrentOrder", function () {
  it("should can get current taxi", async () => {
    const result = await supertest(web)
      .get("/api/customers/orders/getCurrentOrder")
      .set("Authorization", "cd99cf58-9a85-406d-8cb5-03a57018da0f");

    expect(result.status).toBe(200);
    console.dir(result.body);
    logger.info(result.body);
  });
});

// oder taxi
describe("POST /api/customers/orders/addOrder", function () {
  it("customer should can make order", async () => {
    const result = await supertest(web)
      .post("/api/customers/orders/addOrder")
      .set("Authorization", "563d8e5f-1550-46cb-97f8-09c82ca27ad8")
      .send({
        rideId: "RID-000019",
        latitude: -0.05482,
        longitude: 109.31304,
      });

    expect(result.status).toBe(200);
    console.dir(result.body.error);
    console.dir(result.body);
    logger.info(result.body);
  });
});

// cancel order

describe("PATCH /api/customers/orders/cancelOrder", function () {
  it("customer should can cancel order", async () => {
    const result = await supertest(web)
      .patch("/api/customers/orders/cancelOrder")
      .set("Authorization", "71f6e70c-6ceb-4918-9cb6-06db4165b309")
      .send({
        orderId: 1,
      });

    expect(result.status).toBe(200);
    // console.dir(result.body.error);
    console.dir(result.body);
    logger.info(result.body);
  });
});

// get history order
describe("GET /api/customers/orders/getHistoryOrder", function () {
  it("should can get history order taxi", async () => {
    const result = await supertest(web)
      .get("/api/customers/orders/getHistoryOrder")
      .set("Authorization", "9239ce94-fe21-41d3-bd63-c0fd63ac0176");

    expect(result.status).toBe(200);
    console.dir(result.body);
    logger.info(result.body);
  });
});

// send message

describe("POST /api/customers/orders/sendMessage", function () {
  it("should can send message by customer", async () => {
    const result = await supertest(web)
      .post("/api/customers/orders/sendMessage")
      .set("Authorization", "0295430c-023f-43fb-8a09-06172299b1b9")
      .send({
        orderId: 1,
        message:
          "halo kak, maaf saya batalkan soalnya nenek dari tetangganya sepupu dari anak tetanggga saya lahiran kak, maaf.",
      });

    console.log(result.error);
    expect(result.status).toBe(200);
    console.dir(result.body);
    logger.info(result.body);
  });
});

// send report

describe("POST /api/customers/orders/sendReport", function () {
  it("should can send message by customer", async () => {
    const result = await supertest(web)
      .post("/api/customers/orders/sendReport")
      .set("Authorization", "71f6e70c-6ceb-4918-9cb6-06db4165b309")
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

describe("PATCH /api/customers/orders/sendReview", function () {
  it("should can send message by customer", async () => {
    const result = await supertest(web)
      .patch("/api/customers/orders/sendReview")
      .set("Authorization", "1add99e5-35c1-4502-a968-25292a46029a")
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
