import supertest from 'supertest';
import { logger } from '../src/application/logging.js';
import { web } from '../src/application/web.js';

// get current ride

describe('GET /api/drivers/rides/getCurrentRide', () => {
  it('should can get current ride', async () => {
    const result = await supertest(web)
      .get('/api/drivers/rides/getCurrentRide')
      .set('Authorization', 'bc89dc7d-ad02-43b6-9289-38d53e625a6b');

    expect(result.status).toBe(200);
    console.dir(result.body);
    logger.info(result.body);
  });
});

// add new ride
describe('POST /api/drivers/rides/addRide', () => {
  it('should can add new ride', async () => {
    const result = await supertest(web)
      .post('/api/drivers/rides/addRide')
      .set('Authorization', '399b695a-7cae-11ef-8484-c770dcfd5ee1')
      .send({
        lat: -0.038002,
        long: 109.310296,
        pickupRadius: 3000,
      });

    expect(result.status).toBe(200);
    console.dir(result.body);
    logger.info(result.body);
  });
});

// cancel ride

describe('PATCH /api/drivers/rides/cancelRide', () => {
  it('should can cancel ride', async () => {
    const result = await supertest(web)
      .patch('/api/drivers/rides/cancelRide')
      .set('Authorization', '0453cd5e-1186-443b-83d9-fc6fdd420c62')
      .send({
        rideId: 'RID-000003',
      });

    expect(result.status).toBe(200);
    console.dir(result.body);
    logger.info(result.body);
  });
});

// complete ride

describe('PATCH /api/drivers/rides/completeRide', () => {
  it('should can complete ride', async () => {
    const result = await supertest(web)
      .patch('/api/drivers/rides/completeRide')
      .set('Authorization', '0453cd5e-1186-443b-83d9-fc6fdd420c62')
      .send({
        rideId: 'RID-000003',
      });

    expect(result.status).toBe(200);
    console.dir(result.body);
    logger.info(result.body);
  });
});

// complete and close ride

describe('PATCH /api/drivers/rides/completeAndCloseRide', () => {
  it('should can complete ride', async () => {
    const result = await supertest(web)
      .patch('/api/drivers/rides/completeAndCloseRide')
      .set('Authorization', '0453cd5e-1186-443b-83d9-fc6fdd420c62')
      .send({
        rideId: 'RID-000001',
      });

    expect(result.status).toBe(200);
    console.dir(result.body);
    logger.info(result.body);
  });
});

// get history ride

describe('GET /api/drivers/rides/getHistoryRide', () => {
  it('should can get history ride', async () => {
    const result = await supertest(web)
      .get('/api/drivers/rides/getHistoryRide')
      .set('Authorization', '22bdf4e1-6359-480b-b748-6256c5af4a80');

    expect(result.status).toBe(200);
    console.dir(result.body);
    logger.info(result.body);
  });
});
