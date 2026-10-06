import { db } from 'hatchable';
export const access = 'admin';
export default async function(req,res){
  const method=req.method, b=req.body||{}, r=b.resource;
  if(method==='GET'){
    const [pages,services,nav,media,seoRows]=await Promise.all([
      db.query('SELECT * FROM cms_pages ORDER BY sort_order,slug'), db.query('SELECT * FROM cms_services ORDER BY sort_order,id'),
      db.query('SELECT * FROM cms_nav ORDER BY sort_order,id'), db.query('SELECT * FROM cms_media ORDER BY sort_order,created_at DESC'),
      db.query('SELECT * FROM cms_seo ORDER BY key')
    ]);
    return res.json({pages:pages.rows,services:services.rows,nav:nav.rows,media:media.rows,seo:seoRows.rows});
  }
  if(!['pages','services','nav','media','seo'].includes(r)) return res.status(400).json({error:'Invalid resource'});
  if(method==='POST'){
    if(r==='pages'){const q=await db.query('INSERT INTO cms_pages(slug,title_en,title_ar,intro_en,intro_ar,hero_image,seo_title_en,seo_title_ar,seo_description_en,seo_description_ar,published,sort_order) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12) RETURNING *',[b.slug,b.title_en||'',b.title_ar||'',b.intro_en||'',b.intro_ar||'',b.hero_image||'',b.seo_title_en||'',b.seo_title_ar||'',b.seo_description_en||'',b.seo_description_ar||'',b.published!==false,Number(b.sort_order||0)]);return res.status(201).json(q.rows[0]);}
    if(r==='services'){const q=await db.query('INSERT INTO cms_services(title_en,title_ar,description_en,description_ar,image_url,link_url,active,sort_order) VALUES($1,$2,$3,$4,$5,$6,$7,$8) RETURNING *',[b.title_en||'',b.title_ar||'',b.description_en||'',b.description_ar||'',b.image_url||'',b.link_url||'',b.active!==false,Number(b.sort_order||0)]);return res.status(201).json(q.rows[0]);}
    if(r==='nav'){const q=await db.query('INSERT INTO cms_nav(label_en,label_ar,url,active,sort_order) VALUES($1,$2,$3,$4,$5) RETURNING *',[b.label_en||'',b.label_ar||'',b.url||'#',b.active!==false,Number(b.sort_order||0)]);return res.status(201).json(q.rows[0]);}
    if(r==='media'){const q=await db.query('INSERT INTO cms_media(name,url,alt_en,alt_ar,type,sort_order) VALUES($1,$2,$3,$4,$5,$6) RETURNING *',[b.name||'',b.url||'',b.alt_en||'',b.alt_ar||'',b.type||'image',Number(b.sort_order||0)]);return res.status(201).json(q.rows[0]);}
    if(r==='seo'){const q=await db.query('INSERT INTO cms_seo(key,value_en,value_ar) VALUES($1,$2,$3) ON CONFLICT(key) DO UPDATE SET value_en=EXCLUDED.value_en,value_ar=EXCLUDED.value_ar,updated_at=now() RETURNING *',[b.key,b.value_en||'',b.value_ar||'']);return res.status(201).json(q.rows[0]);}
  }
  if(method==='PUT'){
    if(!b.id && r!=='seo') return res.status(400).json({error:'Missing id'});
    if(r==='pages'){const q=await db.query('UPDATE cms_pages SET slug=$1,title_en=$2,title_ar=$3,intro_en=$4,intro_ar=$5,hero_image=$6,seo_title_en=$7,seo_title_ar=$8,seo_description_en=$9,seo_description_ar=$10,published=$11,sort_order=$12,updated_at=now() WHERE id=$13 RETURNING *',[b.slug,b.title_en||'',b.title_ar||'',b.intro_en||'',b.intro_ar||'',b.hero_image||'',b.seo_title_en||'',b.seo_title_ar||'',b.seo_description_en||'',b.seo_description_ar||'',b.published!==false,Number(b.sort_order||0),b.id]);return res.json(q.rows[0]);}
    if(r==='services'){const q=await db.query('UPDATE cms_services SET title_en=$1,title_ar=$2,description_en=$3,description_ar=$4,image_url=$5,link_url=$6,active=$7,sort_order=$8,updated_at=now() WHERE id=$9 RETURNING *',[b.title_en||'',b.title_ar||'',b.description_en||'',b.description_ar||'',b.image_url||'',b.link_url||'',b.active!==false,Number(b.sort_order||0),b.id]);return res.json(q.rows[0]);}
    if(r==='nav'){const q=await db.query('UPDATE cms_nav SET label_en=$1,label_ar=$2,url=$3,active=$4,sort_order=$5,updated_at=now() WHERE id=$6 RETURNING *',[b.label_en||'',b.label_ar||'',b.url||'#',b.active!==false,Number(b.sort_order||0),b.id]);return res.json(q.rows[0]);}
    if(r==='media'){const q=await db.query('UPDATE cms_media SET name=$1,url=$2,alt_en=$3,alt_ar=$4,type=$5,sort_order=$6 WHERE id=$7 RETURNING *',[b.name||'',b.url||'',b.alt_en||'',b.alt_ar||'',b.type||'image',Number(b.sort_order||0),b.id]);return res.json(q.rows[0]);}
    if(r==='seo'){const q=await db.query('UPDATE cms_seo SET value_en=$1,value_ar=$2,updated_at=now() WHERE key=$3 RETURNING *',[b.value_en||'',b.value_ar||'',b.key]);return res.json(q.rows[0]);}
  }
  if(method==='DELETE'){
    if(!b.id)return res.status(400).json({error:'Missing id'});
    const table={pages:'cms_pages',services:'cms_services',nav:'cms_nav',media:'cms_media'}[r];
    if(!table)return res.status(400).json({error:'Cannot delete this resource'});
    await db.query('DELETE FROM '+table+' WHERE id=$1',[b.id]);return res.json({ok:true});
  }
  return res.status(405).json({error:'Method not allowed'});
}
