export const access = "public";

export default async function (req, res) {
  const r = await fetch("https://is-imaging.hatchable.site/assets/is-logo-small.b64");
  if (!r.ok) return res.status(404).send("Image not found");
  const b64 = (await r.text()).trim();
  const buffer = Buffer.from(b64, "base64");
  res.setHeader("Content-Type", "image/webp");
  res.setHeader("Cache-Control", "public, max-age=31536000, immutable");
  res.send(buffer);
}
