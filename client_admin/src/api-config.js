const baseUrl = (import.meta.env.VITE_API_BASE_URL || 'http://localhost:3001/api/').replace(
  /\/+$/,
  ''
);

export const apiEndpoint = (path) => `${baseUrl}/${path.replace(/^\/+/, '')}`;
