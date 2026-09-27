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
