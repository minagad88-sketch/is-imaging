import { db } from 'hatchable';
export const access = 'admin';
export const methods = ['GET','PUT','DELETE'];
export default async function(req,res){
  if(req.method==='GET'){const r=await db.query('SELECT * FROM quote_requests ORDER BY created_at DESC');return res.json({quotes:r.rows});}
  const b=req.body||{}; if(!b.id)return res.status(400).json({error:'id required'});
  if(req.method==='DELETE'){await db.query('DELETE FROM quote_requests WHERE id=$1',[b.id]);return res.json({ok:true});}
  const status=String(b.status||'new'); const r=await db.query('UPDATE quote_requests SET status=$1 WHERE id=$2 RETURNING *',[status,b.id]);res.json(r.rows[0]||{error:'Not found'});
}
