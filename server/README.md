# Server Google Maps setup

The server entrypoint loads `server/.env` using `dotenv/config` when started from
`server`. Set this variable in that file, or inject it through the deployment
secret/environment configuration:

```dotenv
GOOGLE_MAPS_API_KEY=your-server-google-maps-api-key
```

Restart the server after changing configuration. There is no hardcoded fallback.
Use a valid server-side Google Cloud key with billing enabled and access to the
**Routes API** and **Geocoding API**. Route calculations use
`POST https://routes.googleapis.com/directions/v2:computeRoutes` with driving,
traffic-unaware routing and a field mask limited to distance and duration.
Distances remain in metres and durations in seconds, so fare calculations and
client response formats are unchanged. Directions API (Legacy) is no longer
required by the server. Geocoding still uses the Geocoding API.
Enable Routes API and update the key's API restrictions before restarting.
Google Maps usage may incur charges; configure quotas and billing alerts.
Restrict the key to the required APIs and the server's outbound public IP(s),
not Android/iOS application IDs or browser HTTP referrers. Keep the key out of
client applications and version control; `server/.env` is ignored by Git.
Rotate/revoke the previously committed key in its owning Google Cloud project.

Routes API failures stop the operation; no estimated distances or fares are
fabricated. Missing configuration returns 503 with setup instructions. Provider
denial returns 502 with key/API/billing/restriction checks; quota errors return
503, timeouts 504, and no route/location results 404. Invalid provider responses
return 502. Errors intentionally omit raw provider messages and Axios request
objects because they may contain credentials or location data.


Do not use the full `npm test` suite against a database you want to preserve;
existing integration suites may modify its data.

# Local database setup

Set `DATABASE_URL` in `server/.env` to your local MySQL database, then run from
`server`:

```sh
npx prisma migrate deploy
npx prisma generate
npm run seed
```

The seed creates these development accounts:

| Role | Email | Password |
| --- | --- | --- |
| Customer | customer@example.com | password123 |
| Driver | driver@example.com | password123 |
| Admin | admin@example.com | admin123 |

Customer and driver accounts are active and email verified, with bcrypt password
hashes. The admin password is stored as plaintext to match the existing admin
login implementation. These are development credentials only; the seed refuses
to run with `NODE_ENV=production`.

The seed also creates a default fare of 5,000 per kilometre and a sample
Soekarno-Hatta airport if no fare or airport exists. Sample account coordinates
are in Jakarta. It does not create rides or orders; create those through the apps.

Run the seed again safely: existing accounts are matched by email and left
unchanged, including their passwords and status. Existing airport and fare
settings are preserved. All seed writes run in one transaction; failures roll
back the changes. Run one seed process at a time.
