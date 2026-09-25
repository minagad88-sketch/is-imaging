import { db } from 'hatchable';
export const access='public';
export const methods=['GET'];
export default async function(req,res){
 const [settings,products,supplies,pages,services,nav,seoRows,media,theme,sections]=await Promise.all([
  db.query('SELECT key,value_en,value_ar FROM site_settings ORDER BY key'),
  db.query('SELECT id,tag,name_en,name_ar,description_en,description_ar,image_url,link_url,featured,active,sort_order FROM homepage_products WHERE active = TRUE ORDER BY sort_order,id'),
  db.query('SELECT id,sku,family,description_en,description_ar,status,active,sort_order FROM supplies WHERE active = TRUE ORDER BY sort_order,id'),
  db.query('SELECT id,slug,title_en,title_ar,intro_en,intro_ar,hero_image,seo_title_en,seo_title_ar,seo_description_en,seo_description_ar,published,sort_order FROM cms_pages WHERE published = TRUE ORDER BY sort_order,slug'),
  db.query('SELECT id,title_en,title_ar,description_en,description_ar,image_url,link_url,active,sort_order FROM cms_services WHERE active = TRUE ORDER BY sort_order,id'),
  db.query('SELECT id,label_en,label_ar,url,active,sort_order FROM cms_nav WHERE active = TRUE ORDER BY sort_order,id'),
  db.query('SELECT key,value_en,value_ar FROM cms_seo ORDER BY key'),
  db.query('SELECT id,name,url,alt_en,alt_ar,type,sort_order FROM cms_media ORDER BY sort_order,created_at DESC'),
  db.query('SELECT * FROM cms_theme WHERE id=1'),
  db.query('SELECT section_key,label_en,label_ar,visible,sort_order FROM cms_sections ORDER BY sort_order,section_key')
 ]);
 const s={};for(const row of settings.rows)s[row.key]={en:row.value_en,ar:row.value_ar};
 const seo={};for(const row of seoRows.rows)seo[row.key]={en:row.value_en,ar:row.value_ar};
 res.json({settings:s,products:products.rows,supplies:supplies.rows,pages:pages.rows,services:services.rows,nav:nav.rows,seo,media:media.rows,theme:theme.rows[0]||null,sections:sections.rows});
}