import axios from 'axios';
import { ResponseError } from '../error/response-error.js';

const providerErrors = {
  REQUEST_DENIED: [502, 'Google Maps REQUEST_DENIED: check GOOGLE_MAPS_API_KEY validity, enabled API, billing, and server IP restrictions.'],
  OVER_QUERY_LIMIT: [503, 'Google Maps OVER_QUERY_LIMIT: check project quota and billing before retrying.'],
  OVER_DAILY_LIMIT: [503, 'Google Maps OVER_DAILY_LIMIT: check API key validity, billing, and daily quota.'],
  ZERO_RESULTS: [404, 'Google Maps ZERO_RESULTS: no route or address found for these locations.'],
  NOT_FOUND: [404, 'Google Maps NOT_FOUND: an origin or destination could not be resolved.'],
  INVALID_REQUEST: [502, 'Google Maps INVALID_REQUEST: check the coordinates and required request parameters.'],
  MAX_WAYPOINTS_EXCEEDED: [502, 'Google Maps MAX_WAYPOINTS_EXCEEDED: reduce the number of waypoints.'],
  MAX_ROUTE_LENGTH_EXCEEDED: [502, 'Google Maps MAX_ROUTE_LENGTH_EXCEEDED: use a shorter route.'],
  UNKNOWN_ERROR: [503, 'Google Maps UNKNOWN_ERROR: provider temporarily unavailable; retry later.'],
};

async function requestMaps(api, params) {
  const key = process.env.GOOGLE_MAPS_API_KEY?.trim();
  if (!key) {
    throw new ResponseError(503, 'Google Maps is not configured: set GOOGLE_MAPS_API_KEY in the server environment and restart the server.');
  }

  let response;
  try {
    response = await axios.get(`https://maps.googleapis.com/maps/api/${api}/json`, {
      params: { ...params, key },
      timeout: 10000,
    });
  } catch (error) {
    // Axios errors contain the key and locations in their request config. Never expose them.
    if (error.code === 'ECONNABORTED' || error.code === 'ETIMEDOUT') {
      throw new ResponseError(504, 'Google Maps request timed out; retry later.');
    }
    const status = error.response?.status;
    if (status === 401 || status === 403) {
      throw new ResponseError(502, 'Google Maps HTTP authorization failure: check GOOGLE_MAPS_API_KEY, enabled API, billing, and server IP restrictions.');
    }
    if (status === 429) {
      throw new ResponseError(503, 'Google Maps HTTP rate limit: check project quota before retrying.');
    }
    throw new ResponseError(502, 'Google Maps request failed: check server connectivity and provider availability.');
  }

  const { data } = response;
  if (data?.status !== 'OK') {
    const failure = Object.hasOwn(providerErrors, data?.status)
      ? providerErrors[data.status]
      : [502, 'Google Maps returned an unexpected response; check provider availability and API configuration.'];
    // Only allowlisted messages are safe to return, not provider error_message or request URLs.
    throw new ResponseError(...failure);
  }
  return data;
}

export async function getDirections(originLat, originLong, destinationLat, destinationLong) {
  const data = await requestMaps('directions', {
    origin: `${originLat},${originLong}`,
    destination: `${destinationLat},${destinationLong}`,
    mode: 'driving',
  });
  const leg = data.routes?.[0]?.legs?.[0];
  const distance = leg?.distance?.value;
  const duration = leg?.duration?.value;
  if (!Number.isFinite(distance) || distance < 0 || !Number.isFinite(duration) || duration < 0) {
    throw new ResponseError(502, 'Google Maps returned invalid route distance or duration; no estimate is available.');
  }
  return { distance, duration };
}

export async function getAddress(lat, long) {
  const data = await requestMaps('geocode', { latlng: `${lat},${long}` });
  const address = data.results?.[0]?.formatted_address;
  if (typeof address !== 'string' || !address.trim()) {
    throw new ResponseError(502, 'Google Maps returned an invalid address response.');
  }
  return address;
}
