import { db } from 'hatchable';
export const access = 'public';
export const methods = ['POST'];
export default async function(req,res){
  const b=req.body||{};
  const name=String(b.name||'').trim(), email=String(b.email||'').trim();
  if(!name || !email || !String(b.message||'').trim()) return res.status(400).json({error:'Name, email and message are required.'});
  const company=String(b.company||'').trim(), phone=String(b.phone||'').trim(), interest=String(b.interest||'General Inquiry').trim(), message=String(b.message||'').trim();
  const r=await db.query('INSERT INTO quote_requests (name,company,email,phone,interest,message) VALUES ($1,$2,$3,$4,$5,$6) RETURNING id,created_at',[name,company,email,phone,interest,message]);
  res.status(201).json({ok:true,request:r.rows[0]});
}
