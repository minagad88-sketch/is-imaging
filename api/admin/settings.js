import { db } from 'hatchable';
export const access = 'admin';
export const methods = ['GET','PUT'];
export default async function(req,res){
  if(req.method==='GET'){
    const r=await db.query('SELECT key,value_en,value_ar,updated_at FROM site_settings ORDER BY key');
    return res.json({settings:r.rows});
  }
  const b=req.body||{}; if(!b.key) return res.status(400).json({error:'key required'});
  await db.query('INSERT INTO site_settings(key,value_en,value_ar,updated_at) VALUES($1,$2,$3,NOW()) ON CONFLICT(key) DO UPDATE SET value_en=EXCLUDED.value_en,value_ar=EXCLUDED.value_ar,updated_at=NOW()',[String(b.key),String(b.value_en||''),String(b.value_ar||'')]);
  res.json({ok:true});
}