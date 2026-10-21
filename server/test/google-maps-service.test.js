import axios from 'axios';
import { getAddress, getDirections } from '../src/service/google-maps-service.js';

jest.mock('axios');

const originalKey = process.env.GOOGLE_MAPS_API_KEY;

beforeEach(() => {
  jest.resetAllMocks();
  process.env.GOOGLE_MAPS_API_KEY = 'test-key';
});

afterAll(() => {
  if (originalKey === undefined) delete process.env.GOOGLE_MAPS_API_KEY;
  else process.env.GOOGLE_MAPS_API_KEY = originalKey;
});

const directions = () => getDirections(-6.2, 106.8, -6.1, 106.6);

test('uses Routes API and preserves metres and seconds', async () => {
  axios.request.mockResolvedValue({ data: { routes: [{ distanceMeters: 12345, duration: '900.5s' }] } });
  await expect(directions()).resolves.toEqual({ distance: 12345, duration: 900.5 });
  expect(axios.request).toHaveBeenCalledWith({
    method: 'POST',
    url: 'https://routes.googleapis.com/directions/v2:computeRoutes',
    headers: {
      'X-Goog-Api-Key': 'test-key',
      'X-Goog-FieldMask': 'routes.distanceMeters,routes.duration',
    },
    timeout: 10000,
    data: {
      origin: { location: { latLng: { latitude: -6.2, longitude: 106.8 } } },
      destination: { location: { latLng: { latitude: -6.1, longitude: 106.6 } } },
      travelMode: 'DRIVE',
      routingPreference: 'TRAFFIC_UNAWARE',
      computeAlternativeRoutes: false,
    },
  });
});

test('requires configuration before making requests', async () => {
  delete process.env.GOOGLE_MAPS_API_KEY;
  await expect(directions()).rejects.toMatchObject({ status: 503 });
  expect(axios.request).not.toHaveBeenCalled();
});

test.each([{}, { routes: [] }])('reports no route for %j', async (data) => {
  axios.request.mockResolvedValue({ data });
  await expect(directions()).rejects.toMatchObject({ status: 404 });
});

test.each([
  null,
  { routes: null },
  { routes: [{}] },
  { routes: [{ distanceMeters: -1, duration: '1s' }] },
  { routes: [{ distanceMeters: '10', duration: '1s' }] },
  { routes: [{ distanceMeters: 10, duration: '-1s' }] },
  { routes: [{ distanceMeters: 10, duration: '1 minute' }] },
  { routes: [{ distanceMeters: 10, duration: 100 }] },
])('rejects invalid route response %j', async (data) => {
  axios.request.mockResolvedValue({ data });
  await expect(directions()).rejects.toMatchObject({ status: 502 });
});

test.each([[401, 502], [403, 502], [429, 503], [500, 502]])('sanitizes HTTP %i failures', async (status, expected) => {
  axios.request.mockRejectedValue({
    response: { status, data: { error: { message: 'secret-key and location' } } },
  });
  await expect(directions()).rejects.toMatchObject({ status: expected });
  await expect(directions()).rejects.not.toThrow('secret-key');
});

test.each(['ECONNABORTED', 'ETIMEDOUT'])('handles timeout %s', async (code) => {
  axios.request.mockRejectedValue({ code });
  await expect(directions()).rejects.toMatchObject({ status: 504 });
});

test('preserves reverse geocoding', async () => {
  axios.request.mockResolvedValue({ data: { status: 'OK', results: [{ formatted_address: 'Jakarta' }] } });
  await expect(getAddress(-6.2, 106.8)).resolves.toBe('Jakarta');
  expect(axios.request).toHaveBeenCalledWith({
    method: 'GET',
    url: 'https://maps.googleapis.com/maps/api/geocode/json',
    params: { latlng: '-6.2,106.8', key: 'test-key' },
    timeout: 10000,
  });
});

test('preserves geocoding provider errors', async () => {
  axios.request.mockResolvedValue({ data: { status: 'REQUEST_DENIED', error_message: 'secret-key' } });
  await expect(getAddress(-6.2, 106.8)).rejects.toMatchObject({ status: 502 });
  await expect(getAddress(-6.2, 106.8)).rejects.not.toThrow('secret-key');
});
