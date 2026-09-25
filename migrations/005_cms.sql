CREATE TABLE IF NOT EXISTS cms_pages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), slug text NOT NULL UNIQUE,
  title_en text NOT NULL DEFAULT '', title_ar text NOT NULL DEFAULT '',
  intro_en text NOT NULL DEFAULT '', intro_ar text NOT NULL DEFAULT '',
  hero_image text NOT NULL DEFAULT '', seo_title_en text NOT NULL DEFAULT '', seo_title_ar text NOT NULL DEFAULT '',
  seo_description_en text NOT NULL DEFAULT '', seo_description_ar text NOT NULL DEFAULT '',
  published boolean NOT NULL DEFAULT true, sort_order integer NOT NULL DEFAULT 0, updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS cms_services (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), title_en text NOT NULL DEFAULT '', title_ar text NOT NULL DEFAULT '',
  description_en text NOT NULL DEFAULT '', description_ar text NOT NULL DEFAULT '', image_url text NOT NULL DEFAULT '',
  link_url text NOT NULL DEFAULT '', active boolean NOT NULL DEFAULT true, sort_order integer NOT NULL DEFAULT 0, updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS cms_nav (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), label_en text NOT NULL DEFAULT '', label_ar text NOT NULL DEFAULT '',
  url text NOT NULL DEFAULT '#', active boolean NOT NULL DEFAULT true, sort_order integer NOT NULL DEFAULT 0, updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS cms_media (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), name text NOT NULL DEFAULT '', url text NOT NULL DEFAULT '',
  alt_en text NOT NULL DEFAULT '', alt_ar text NOT NULL DEFAULT '', type text NOT NULL DEFAULT 'image',
  sort_order integer NOT NULL DEFAULT 0, created_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS cms_seo (
  key text PRIMARY KEY, value_en text NOT NULL DEFAULT '', value_ar text NOT NULL DEFAULT '', updated_at timestamptz NOT NULL DEFAULT now()
);
INSERT INTO cms_pages(slug,title_en,title_ar,intro_en,intro_ar,sort_order) SELECT '/','Home','الرئيسية','IS Imaging Solutions — HP and digital printing technology solutions.','حلول IS Imaging Solutions لتقنيات HP والطباعة الرقمية.',0 WHERE NOT EXISTS (SELECT 1 FROM cms_pages WHERE slug='/');
INSERT INTO cms_pages(slug,title_en,title_ar,intro_en,intro_ar,sort_order) SELECT '/plotters/','HP DESIGNJET','طابعات HP DESIGNJET','Large format printers and plotters.','طابعات ومخططات الطباعة كبيرة الحجم.',10 WHERE NOT EXISTS (SELECT 1 FROM cms_pages WHERE slug='/plotters/');
INSERT INTO cms_pages(slug,title_en,title_ar,intro_en,intro_ar,sort_order) SELECT '/laptops/','HP Laptops','لابتوبات HP','HP laptop families and business computing solutions.','عائلات لابتوبات HP وحلول الحوسبة للأعمال.',20 WHERE NOT EXISTS (SELECT 1 FROM cms_pages WHERE slug='/laptops/');
INSERT INTO cms_pages(slug,title_en,title_ar,intro_en,intro_ar,sort_order) SELECT '/desktops/','HP Desktops','أجهزة HP المكتبية','Business desktops, workstations and professional PCs.','أجهزة الأعمال ومحطات العمل وأجهزة HP الاحترافية.',30 WHERE NOT EXISTS (SELECT 1 FROM cms_pages WHERE slug='/desktops/');
INSERT INTO cms_pages(slug,title_en,title_ar,intro_en,intro_ar,sort_order) SELECT '/printers/','HP Printers','طابعات HP','HP printing solutions for business and enterprise.','حلول طباعة HP للأعمال والمؤسسات.',40 WHERE NOT EXISTS (SELECT 1 FROM cms_pages WHERE slug='/printers/');
INSERT INTO cms_pages(slug,title_en,title_ar,intro_en,intro_ar,sort_order) SELECT '/solutions/','HP Solutions & Services','حلول وخدمات HP','Installation, maintenance, supplies and managed printing.','التركيب والصيانة والمستلزمات والطباعة المُدارة.',50 WHERE NOT EXISTS (SELECT 1 FROM cms_pages WHERE slug='/solutions/');
INSERT INTO cms_pages(slug,title_en,title_ar,intro_en,intro_ar,sort_order) SELECT '/service/','HP Maintenance','صيانة HP','Out-of-warranty HP device maintenance and support.','صيانة ودعم أجهزة HP خارج الضمان.',60 WHERE NOT EXISTS (SELECT 1 FROM cms_pages WHERE slug='/service/');
INSERT INTO cms_nav(label_en,label_ar,url,sort_order) SELECT 'Home','الرئيسية','/',0 WHERE NOT EXISTS (SELECT 1 FROM cms_nav WHERE url='/');
INSERT INTO cms_nav(label_en,label_ar,url,sort_order) SELECT 'HP DesignJet','HP DesignJet','/plotters/',10 WHERE NOT EXISTS (SELECT 1 FROM cms_nav WHERE url='/plotters/');
INSERT INTO cms_nav(label_en,label_ar,url,sort_order) SELECT 'HP Laptops','لابتوبات HP','/laptops/',20 WHERE NOT EXISTS (SELECT 1 FROM cms_nav WHERE url='/laptops/');
INSERT INTO cms_nav(label_en,label_ar,url,sort_order) SELECT 'HP Desktops','أجهزة HP المكتبية','/desktops/',30 WHERE NOT EXISTS (SELECT 1 FROM cms_nav WHERE url='/desktops/');
INSERT INTO cms_nav(label_en,label_ar,url,sort_order) SELECT 'HP Printers','طابعات HP','/printers/',40 WHERE NOT EXISTS (SELECT 1 FROM cms_nav WHERE url='/printers/');
INSERT INTO cms_nav(label_en,label_ar,url,sort_order) SELECT 'HP Solutions','حلول HP','/solutions/',50 WHERE NOT EXISTS (SELECT 1 FROM cms_nav WHERE url='/solutions/');
INSERT INTO cms_nav(label_en,label_ar,url,sort_order) SELECT 'About Us','من نحن','#about',60 WHERE NOT EXISTS (SELECT 1 FROM cms_nav WHERE url='#about');
INSERT INTO cms_nav(label_en,label_ar,url,sort_order) SELECT 'Services','خدماتنا','#services',70 WHERE NOT EXISTS (SELECT 1 FROM cms_nav WHERE url='#services');
INSERT INTO cms_nav(label_en,label_ar,url,sort_order) SELECT 'Solutions','حلولنا','#solutions',80 WHERE NOT EXISTS (SELECT 1 FROM cms_nav WHERE url='#solutions');
INSERT INTO cms_nav(label_en,label_ar,url,sort_order) SELECT 'Products','المنتجات','#products',90 WHERE NOT EXISTS (SELECT 1 FROM cms_nav WHERE url='#products');
INSERT INTO cms_nav(label_en,label_ar,url,sort_order) SELECT 'Contact','تواصل معنا','#contact',100 WHERE NOT EXISTS (SELECT 1 FROM cms_nav WHERE url='#contact');