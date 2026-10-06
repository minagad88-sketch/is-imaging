// ---------------------------------------------------------------------------
// Local replacement for the `hatchable` platform SDK.
//
// The original project (built on hatchable.com) imports `db` and `storage`
// from a built-in module called 'hatchable'. That module only exists inside
// Hatchable's own hosting — it does not exist on Railway, or on any other
// generic Node host. This file provides a drop-in replacement so the
// downloaded api/*.js files can run completely unmodified.
//
// - db.query(sql, params)  -> talks to a real Postgres database via `pg`,
//   using the DATABASE_URL environment variable that Railway's Postgres
//   plugin provides automatically.
// - storage.put(key, buffer, contentType) -> saves the file to local disk
//   under /public/uploads and returns a URL path to it.
//   NOTE: Railway's filesystem is EPHEMERAL — anything written to disk is
//   wiped on every redeploy/restart. This is fine to get the site working,
//   but for a permanent admin media library you should eventually swap this
//   for a real object storage service (e.g. Cloudinary, AWS S3, Backblaze).
// ---------------------------------------------------------------------------

import pg from 'pg';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

if (!process.env.DATABASE_URL) {
  console.error(
    '[hatchable-shim] DATABASE_URL is not set. Add a PostgreSQL database on ' +
    'Railway and Railway will inject DATABASE_URL automatically.'
  );
}

const useSSL = process.env.PGSSL === 'true'
  ? { rejectUnauthorized: false }
  : (process.env.PGSSL === 'false' ? false : undefined);

const pool = new pg.Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: useSSL,
});

export const db = {
  query: (text, params) => pool.query(text, params),
  pool,
};

// Files are saved under <repo>/public/uploads/<key>, which is also served
// statically by server.js, so the returned URL works immediately.
const uploadsRoot = path.resolve(__dirname, '..', '..', 'public', 'uploads');

export const storage = {
  async put(key, buffer, contentType) {
    const safeKey = String(key).replace(/\.\./g, '');
    const destPath = path.join(uploadsRoot, safeKey);
    fs.mkdirSync(path.dirname(destPath), { recursive: true });
    fs.writeFileSync(destPath, buffer);
    return '/uploads/' + safeKey.split(path.sep).join('/');
  },
};

// Stubs for other Hatchable SDK members, in case any file references them.
// None of the current api/*.js files use these, but they're here so an
// import doesn't crash if you add more Hatchable-generated files later.
export const auth = {};
export const admin = {};
export const email = { send: async () => { throw new Error('email is not configured outside Hatchable'); } };
export const scheduler = {};
export const ai = {};
export const knowledge = {};
export const browser = {};
export const config = {};
export const env = process.env;
export const api = {};
export const webhooks = {};
