import { db } from 'hatchable';
export const access='admin';
export default async function(req,res){
 const b=req.body||{};
 if(req.method==='GET'){
  const t=await db.query('SELECT * FROM cms_theme WHERE id=1');
  const s=await db.query('SELECT * FROM cms_sections ORDER BY sort_order,section_key');
  return res.json({theme:t.rows[0]||null,sections:s.rows});
 }
 if(req.method==='PUT'){
  if(b.kind==='theme'){
   const q=await db.query('UPDATE cms_theme SET primary_color=$1,secondary_color=$2,navy_color=$3,accent_color=$4,background_color=$5,surface_color=$6,text_color=$7,muted_color=$8,border_radius=$9,button_radius=$10,shadow_strength=$11,font_family=$12,heading_scale=$13,dark_mode=$14,updated_at=now() WHERE id=1 RETURNING *',
   [b.primary_color,b.secondary_color,b.navy_color,b.accent_color,b.background_color,b.surface_color,b.text_color,b.muted_color,Number(b.border_radius),Number(b.button_radius),Number(b.shadow_strength),b.font_family,Number(b.heading_scale),!!b.dark_mode]);
   return res.json(q.rows[0]);
  }
  if(b.kind==='section'){
   const q=await db.query('UPDATE cms_sections SET visible=$1,sort_order=$2,updated_at=now() WHERE id=$3 RETURNING *',[!!b.visible,Number(b.sort_order),b.id]);
   return res.json(q.rows[0]);
  }
 }
 if(req.method==='POST'&&b.kind==='section'){
  const q=await db.query('INSERT INTO cms_sections(section_key,label_en,label_ar,visible,sort_order) VALUES($1,$2,$3,$4,$5) ON CONFLICT(section_key) DO UPDATE SET label_en=EXCLUDED.label_en,label_ar=EXCLUDED.label_ar RETURNING *',[b.section_key,b.label_en||'',b.label_ar||'',b.visible!==false,Number(b.sort_order||0)]);
  return res.status(201).json(q.rows[0]);
 }
 return res.status(405).json({error:'Method not allowed'});
}
