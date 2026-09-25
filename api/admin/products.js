import { db } from 'hatchable';
export const access = 'admin';
export const methods = ['GET','POST','PUT','DELETE'];
export default async function(req,res){
  if(req.method==='GET'){
    const r=await db.query('SELECT * FROM homepage_products ORDER BY sort_order,id'); return res.json({products:r.rows});
  }
  const b=req.body||{};
  if(req.method==='POST'){
    if(!b.name_en||!b.name_ar) return res.status(400).json({error:'English and Arabic names are required.'});
    const r=await db.query('INSERT INTO homepage_products(tag,name_en,name_ar,description_en,description_ar,image_url,link_url,featured,active,sort_order) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10) RETURNING *',[b.tag||'HP',b.name_en,b.name_ar,b.description_en||'',b.description_ar||'',b.image_url||'',b.link_url||'#contact',!!b.featured,b.active!==false,Number(b.sort_order||0)]); return res.status(201).json(r.rows[0]);
  }
  if(!b.id) return res.status(400).json({error:'id required'});
  if(req.method==='DELETE'){await db.query('DELETE FROM homepage_products WHERE id=$1',[b.id]);return res.json({ok:true});}
  const r=await db.query('UPDATE homepage_products SET tag=$1,name_en=$2,name_ar=$3,description_en=$4,description_ar=$5,image_url=$6,link_url=$7,featured=$8,active=$9,sort_order=$10,updated_at=NOW() WHERE id=$11 RETURNING *',[b.tag||'HP',b.name_en,b.name_ar,b.description_en||'',b.description_ar||'',b.image_url||'',b.link_url||'#contact',!!b.featured,b.active!==false,Number(b.sort_order||0),b.id]); res.json(r.rows[0]||{error:'Not found'});
}