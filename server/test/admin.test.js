import supertest from 'supertest';
import { logger } from '../src/application/logging.js';
import { web } from '../src/application/web';

// testing to login

describe('POST /api/admin/login', () => {
  it('should can login', async () => {
    const result = await supertest(web).post('/api/admin/login').send({
      email: 'admin@gmail.com',
      password: 'admin123',
    });

    logger.info(result.body);

    expect(result.status).toBe(200);
    expect(result.body.data.token).toBeDefined();
    expect(result.body.data.token).not.toBe('test');
  });
});

// testing to get data admin

describe('GET /api/admin/getCurrent', () => {
  it('should can get data admin', async () => {
    const result = await supertest(web)
      .get('/api/admin/getCurrent')
      .set('Authorization', '2f844ad3-4356-4f62-a8a8-64e12fdd8ddc');

    logger.info(result.body);
    expect(result.status).toBe(200);
  });
});

// testing to get data driver

describe('GET /api/admin/getDriver', () => {
  it('should can get data driver', async () => {
    const result = await supertest(web)
      .get('/api/admin/getDriver')
      .set('Authorization', '6ede3e81-7b2e-4f70-a0e8-312071de3a41');

    logger.info(result.body);
    expect(result.status).toBe(200);
  });
});

// testing to get data customer

describe('GET /api/admin/getCustomer', () => {
  it('should can get data customer', async () => {
    const result = await supertest(web)
      .get('/api/admin/getCustomer')
      .set('Authorization', 'ba1ed3a7-84cb-4f48-ba22-1ca0ac7e9624');

    logger.info(result.body);
    expect(result.status).toBe(200);
  });
});

// testing to get data fare

describe('GET /api/admin/getFare', () => {
  it('should can get data fare', async () => {
    const result = await supertest(web)
      .get('/api/admin/getFare')
      .set('Authorization', 'deaa79c3-854e-4d90-a232-1a41cd2c4df8');

    logger.info(result.body);
    expect(result.status).toBe(200);
  });
});

// testing to update data fare

describe('PATCH /api/admin/updateFare', () => {
  it('should can get data fare', async () => {
    const result = await supertest(web)
      .patch('/api/admin/updateFare')
      .set('Authorization', 'deaa79c3-854e-4d90-a232-1a41cd2c4df8')
      .send({
        fareId: 1,
        farePerKm: 16000,
      });

    logger.info(result.body);
    expect(result.status).toBe(200);
  });
});

// testing to activate driver account

describe('PATCH /api/admin/activateDriverAccount', () => {
  it('should can activate driver account', async () => {
    const result = await supertest(web)
      .patch('/api/admin/activateDriverAccount')
      .set('Authorization', '5043b409-c168-482f-9fc2-18173a52a9d7')
      .send({
        driverId: 1,
      });

    logger.info(result.body);
    expect(result.status).toBe(200);
  });
});

// testing to deactivate driver account

describe('PATCH /api/admin/deactivateDriverAccount', () => {
  it('should can deactivate driver account', async () => {
    const result = await supertest(web)
      .patch('/api/admin/deactivateDriverAccount')
      .set('Authorization', 'ba1ed3a7-84cb-4f48-ba22-1ca0ac7e9624')
      .send({
        driverId: 1,
      });

    logger.info(result.body);
    expect(result.status).toBe(200);
  });
});

// testing to activate customer account

describe('PATCH /api/admin/activateCustomerAccount', () => {
  it('should can activate customer account', async () => {
    const result = await supertest(web)
      .patch('/api/admin/activateCustomerAccount')
      .set('Authorization', '6ede3e81-7b2e-4f70-a0e8-312071de3a41')
      .send({
        customerId: 1,
      });

    logger.info(result.body);
    expect(result.status).toBe(200);
  });
});

// testing to deactivate customer account

describe('PATCH /api/admin/deactivateCustomerAccount', () => {
  it('should can deactivate customer account', async () => {
    const result = await supertest(web)
      .patch('/api/admin/deactivateCustomerAccount')
      .set('Authorization', '6ede3e81-7b2e-4f70-a0e8-312071de3a41')
      .send({
        customerId: 1,
      });

    logger.info(result.body);
    expect(result.status).toBe(200);
  });
});

// testing to get data orderan

describe('GET /api/admin/getOrderan', () => {
  it('should can get data orderan', async () => {
    const result = await supertest(web)
      .get('/api/admin/getOrderan')
      .set('Authorization', 'deaa79c3-854e-4d90-a232-1a41cd2c4df8');

    logger.info(result.body);
    expect(result.status).toBe(200);
  });
});

// testing to get data ride

describe('GET /api/admin/getRide', () => {
  it('should can get data ride', async () => {
    const result = await supertest(web)
      .get('/api/admin/getRide')
      .set('Authorization', 'deaa79c3-854e-4d90-a232-1a41cd2c4df8');

    logger.info(result.body);
    expect(result.status).toBe(200);
  });
});

// testing logout

describe('DELETE /api/admin/logout', () => {
  it('should can logout', async () => {
    const result = await supertest(web)
      .delete('/api/admin/logout')
      .set('Authorization', '5043b409-c168-482f-9fc2-18173a52a9d7');

    expect(result.status).toBe(200);
    expect(result.body.data).toBe('OK');
  });
});
