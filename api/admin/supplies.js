import { db } from 'hatchable';
export const access = 'admin';
export const methods = ['GET','POST','PUT','DELETE'];
export default async function(req,res){
  if(req.method==='GET'){const r=await db.query('SELECT * FROM supplies ORDER BY sort_order,id');return res.json({supplies:r.rows});}
  const b=req.body||{};
  if(req.method==='POST'){
    if(!b.sku||!b.description_en) return res.status(400).json({error:'SKU and English description are required.'});
    const r=await db.query('INSERT INTO supplies(sku,family,description_en,description_ar,status,active,sort_order) VALUES($1,$2,$3,$4,$5,$6,$7) RETURNING *',[b.sku,b.family||'',b.description_en,b.description_ar||'',b.status||'Current item',b.active!==false,Number(b.sort_order||0)]);return res.status(201).json(r.rows[0]);
  }
  if(!b.id) return res.status(400).json({error:'id required'});
  if(req.method==='DELETE'){await db.query('DELETE FROM supplies WHERE id=$1',[b.id]);return res.json({ok:true});}
  const r=await db.query('UPDATE supplies SET sku=$1,family=$2,description_en=$3,description_ar=$4,status=$5,active=$6,sort_order=$7,updated_at=NOW() WHERE id=$8 RETURNING *',[b.sku,b.family||'',b.description_en,b.description_ar||'',b.status||'Current item',b.active!==false,Number(b.sort_order||0),b.id]);res.json(r.rows[0]||{error:'Not found'});
}
