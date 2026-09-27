// ---------------------------------------------------------------------------
// Generic Node/Express entry point for the "IS Imaging Solutions" project.
//
// On Hatchable, every file under api/ is automatically turned into a live
// route (api/site/content.js -> GET/POST /api/site/content) by Hatchable's
// own platform router — there is no server.js on Hatchable, because you
// don't need one there. Railway (and any other generic host) has no idea
// what an api/*.js file is, so this file recreates that same routing by
// hand, using plain Express. Every handler file underneath api/ runs
// completely unmodified.
// ---------------------------------------------------------------------------

import express from 'express';
import multer from 'multer';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const app = express();
const upload = multer({ storage: multer.memoryStorage(), limits: { fileSize: 10 * 1024 * 1024 } });

app.disable('x-powered-by');
app.use(express.json({ limit: '2mb' }));

// --- very small Basic-Auth gate for the admin API -------------------------
// Hatchable's `export const access = 'admin'` is normally enforced by
// Hatchable's own login system (a whole separate product). We don't have
// that here, so this is a minimal stand-in: set ADMIN_USER / ADMIN_PASS in
// Railway's environment variables. Anyone with those credentials can call
// /api/admin/*. This is enough to keep the admin API from being wide open,
// but if this site becomes business-critical, consider replacing it with a
// proper login (e.g. a signed cookie session) later.
function requireAdmin(req, res, next) {
  const user = process.env.ADMIN_USER;
  const pass = process.env.ADMIN_PASS;
  if (!user || !pass) {
    console.warn('[admin] ADMIN_USER / ADMIN_PASS are not set — admin API is BLOCKED until you set them.');
    return res.status(503).json({ error: 'Admin area is not configured yet. Set ADMIN_USER and ADMIN_PASS.' });
  }
  const header = req.headers.authorization || '';
  const [scheme, encoded] = header.split(' ');
  if (scheme === 'Basic' && encoded) {
    const [u, p] = Buffer.from(encoded, 'base64').toString('utf8').split(':');
    if (u === user && p === pass) return next();
  }
  res.set('WWW-Authenticate', 'Basic realm="Admin"');
  return res.status(401).json({ error: 'Authentication required' });
}

// --- helper that adapts a Hatchable handler file into an Express route ----
async function mount(routePath, filePath, { admin = false, upload: needsUpload = false } = {}) {
  const mod = await import(filePath);
  const handler = mod.default;
  const middlewares = [];
  if (admin) middlewares.push(requireAdmin);
  if (needsUpload) middlewares.push(upload.single('file'));
  app.all(routePath, ...middlewares, (req, res) => {
    // Hatchable exposes uploaded files as req.files (an array). Multer's
    // .single() puts one file on req.file — bridge the two shapes so the
    // original upload.js code works completely unchanged.
    if (req.file) {
      req.files = [{
        buffer: req.file.buffer,
        contentType: req.file.mimetype,
        filename: req.file.originalname,
      }];
    }
    Promise.resolve(handler(req, res)).catch((err) => {
      console.error(`[${routePath}]`, err);
      if (!res.headersSent) res.status(500).json({ error: 'Internal server error' });
    });
  });
}

async function start() {
  await mount('/api/logo-image', './api/logo-image.js');
  await mount('/api/quotes', './api/quotes.js');
  await mount('/api/site/content', './api/site/content.js');
  await mount('/api/admin/cms', './api/admin/cms.js', { admin: true });
  await mount('/api/admin/design', './api/admin/design.js', { admin: true });
  await mount('/api/admin/products', './api/admin/products.js', { admin: true });
  await mount('/api/admin/quotes', './api/admin/quotes.js', { admin: true });
  await mount('/api/admin/settings', './api/admin/settings.js', { admin: true });
  await mount('/api/admin/supplies', './api/admin/supplies.js', { admin: true });
  await mount('/api/admin/upload', './api/admin/upload.js', { admin: true, upload: true });

  // Static site (public/index.html, public/plotters/index.html, etc.)
  app.use(express.static(path.join(__dirname, 'public')));

  const port = process.env.PORT || 3000;
  app.listen(port, () => console.log(`Server running on port ${port}`));
}

start().catch((err) => {
  console.error('Failed to start server:', err);
  process.exit(1);
});
