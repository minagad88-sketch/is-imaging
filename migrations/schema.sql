-- ===========================================================================
-- Combined schema for IS Imaging Solutions Website
-- This merges the original 25 migration files (001_admin.sql .. 025_seed_site_media.sql)
-- from the Hatchable project into one file, in the same order, so it can be
-- run once against a fresh PostgreSQL database (e.g. Railway's Postgres addon).
-- Safe to re-run: every statement is idempotent (IF NOT EXISTS / WHERE NOT EXISTS).
-- ===========================================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto; -- needed for gen_random_uuid()

-- 001_admin.sql
CREATE TABLE IF NOT EXISTS site_settings (
  key TEXT PRIMARY KEY,
  value_en TEXT NOT NULL DEFAULT '',
  value_ar TEXT NOT NULL DEFAULT '',
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 002_content.sql
CREATE TABLE IF NOT EXISTS homepage_products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tag TEXT NOT NULL DEFAULT 'HP',
  name_en TEXT NOT NULL,
  name_ar TEXT NOT NULL,
  description_en TEXT NOT NULL DEFAULT '',
  description_ar TEXT NOT NULL DEFAULT '',
  image_url TEXT NOT NULL DEFAULT '',
  link_url TEXT NOT NULL DEFAULT '#contact',
  featured BOOLEAN NOT NULL DEFAULT FALSE,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  sort_order INTEGER NOT NULL DEFAULT 0,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 003_supplies.sql
CREATE TABLE IF NOT EXISTS supplies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sku TEXT NOT NULL,
  family TEXT NOT NULL DEFAULT '',
  description_en TEXT NOT NULL DEFAULT '',
  description_ar TEXT NOT NULL DEFAULT '',
  status TEXT NOT NULL DEFAULT 'Current item',
  active BOOLEAN NOT NULL DEFAULT TRUE,
  sort_order INTEGER NOT NULL DEFAULT 0,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 004_quotes.sql
CREATE TABLE IF NOT EXISTS quote_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  company TEXT NOT NULL DEFAULT '',
  email TEXT NOT NULL,
  phone TEXT NOT NULL DEFAULT '',
  interest TEXT NOT NULL DEFAULT 'General Inquiry',
  message TEXT NOT NULL DEFAULT '',
  status TEXT NOT NULL DEFAULT 'new',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 005_cms.sql
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

-- 006_design_cms.sql
CREATE TABLE IF NOT EXISTS cms_theme (
 id integer PRIMARY KEY DEFAULT 1,
 primary_color text NOT NULL DEFAULT '#0879c9',
 secondary_color text NOT NULL DEFAULT '#22c7e8',
 navy_color text NOT NULL DEFAULT '#061a31',
 accent_color text NOT NULL DEFAULT '#22c7e8',
 background_color text NOT NULL DEFAULT '#ffffff',
 surface_color text NOT NULL DEFAULT '#f4f8fb',
 text_color text NOT NULL DEFAULT '#10243d',
 muted_color text NOT NULL DEFAULT '#6c7d90',
 border_radius integer NOT NULL DEFAULT 16,
 button_radius integer NOT NULL DEFAULT 10,
 shadow_strength numeric NOT NULL DEFAULT 0.12,
 font_family text NOT NULL DEFAULT 'Cairo, Inter, sans-serif',
 heading_scale numeric NOT NULL DEFAULT 1,
 dark_mode boolean NOT NULL DEFAULT false,
 updated_at timestamptz NOT NULL DEFAULT now()
);

-- 007_sections.sql
CREATE TABLE IF NOT EXISTS cms_sections (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 section_key text NOT NULL UNIQUE,
 label_en text NOT NULL DEFAULT '',
 label_ar text NOT NULL DEFAULT '',
 visible boolean NOT NULL DEFAULT true,
 sort_order integer NOT NULL DEFAULT 0,
 updated_at timestamptz NOT NULL DEFAULT now()
);

-- 008_sections_seed.sql .. 024_section_cta.sql
INSERT INTO cms_sections(section_key,label_en,label_ar,visible,sort_order) SELECT 'home','Home / Hero','الرئيسية / الهيرو',true,0 WHERE NOT EXISTS (SELECT 1 FROM cms_sections WHERE section_key='home');
INSERT INTO cms_sections(section_key,label_en,label_ar,visible,sort_order) SELECT 'stats','Stats','الإحصائيات',true,10 WHERE NOT EXISTS (SELECT 1 FROM cms_sections WHERE section_key='stats');
INSERT INTO cms_sections(section_key,label_en,label_ar,visible,sort_order) SELECT 'about','About','من نحن',true,20 WHERE NOT EXISTS (SELECT 1 FROM cms_sections WHERE section_key='about');
INSERT INTO cms_sections(section_key,label_en,label_ar,visible,sort_order) SELECT 'approach','Strategic Approach','النهج الاستراتيجي',true,30 WHERE NOT EXISTS (SELECT 1 FROM cms_sections WHERE section_key='approach');
INSERT INTO cms_sections(section_key,label_en,label_ar,visible,sort_order) SELECT 'solutions','Technology Portfolio','محفظة الحلول',true,40 WHERE NOT EXISTS (SELECT 1 FROM cms_sections WHERE section_key='solutions');
INSERT INTO cms_sections(section_key,label_en,label_ar,visible,sort_order) SELECT 'why','Why Choose Us','لماذا نحن',true,50 WHERE NOT EXISTS (SELECT 1 FROM cms_sections WHERE section_key='why');
INSERT INTO cms_sections(section_key,label_en,label_ar,visible,sort_order) SELECT 'milestones','Strategic Milestones','المحطات الاستراتيجية',true,60 WHERE NOT EXISTS (SELECT 1 FROM cms_sections WHERE section_key='milestones');
INSERT INTO cms_sections(section_key,label_en,label_ar,visible,sort_order) SELECT 'industries','Client Sectors','قطاعات العملاء',true,70 WHERE NOT EXISTS (SELECT 1 FROM cms_sections WHERE section_key='industries');
INSERT INTO cms_sections(section_key,label_en,label_ar,visible,sort_order) SELECT 'firewall','Firewall & Cybersecurity','جدران الحماية والأمن السيبراني',true,80 WHERE NOT EXISTS (SELECT 1 FROM cms_sections WHERE section_key='firewall');
INSERT INTO cms_sections(section_key,label_en,label_ar,visible,sort_order) SELECT 'services','Services','الخدمات',true,90 WHERE NOT EXISTS (SELECT 1 FROM cms_sections WHERE section_key='services');
INSERT INTO cms_sections(section_key,label_en,label_ar,visible,sort_order) SELECT 'products','Products','المنتجات',true,100 WHERE NOT EXISTS (SELECT 1 FROM cms_sections WHERE section_key='products');
INSERT INTO cms_sections(section_key,label_en,label_ar,visible,sort_order) SELECT 'supplies','HP Supplies','مستلزمات HP',true,110 WHERE NOT EXISTS (SELECT 1 FROM cms_sections WHERE section_key='supplies');
INSERT INTO cms_sections(section_key,label_en,label_ar,visible,sort_order) SELECT 'contact','Contact','تواصل معنا',true,120 WHERE NOT EXISTS (SELECT 1 FROM cms_sections WHERE section_key='contact');
INSERT INTO cms_sections(section_key,label_en,label_ar,visible,sort_order) SELECT 'plotters','HP DesignJet','HP DesignJet',true,95 WHERE NOT EXISTS (SELECT 1 FROM cms_sections WHERE section_key='plotters');
INSERT INTO cms_sections(section_key,label_en,label_ar,visible,sort_order) SELECT 'oow','HP Out-of-Warranty Service','صيانة HP خارج الضمان',true,115 WHERE NOT EXISTS (SELECT 1 FROM cms_sections WHERE section_key='oow');
INSERT INTO cms_sections(section_key,label_en,label_ar,visible,sort_order) SELECT 'cta','Call to Action','دعوة لاتخاذ إجراء',true,125 WHERE NOT EXISTS (SELECT 1 FROM cms_sections WHERE section_key='cta');

-- 009_theme_seed.sql
INSERT INTO cms_theme(id) SELECT 1 WHERE NOT EXISTS (SELECT 1 FROM cms_theme WHERE id=1);

-- 025_seed_site_media.sql (gallery/media-library images used by the admin panel)
INSERT INTO cms_media(name,url,alt_en,alt_ar,type,sort_order) SELECT 'Business objectives','https://images.unsplash.com/photo-1556761175-b413da4baf72?auto=format&fit=crop&w=900&q=80','Business objectives','Business objectives','site-image',0 WHERE NOT EXISTS (SELECT 1 FROM cms_media WHERE name='Business objectives' AND type='site-image');
INSERT INTO cms_media(name,url,alt_en,alt_ar,type,sort_order) SELECT 'Operational requirements','https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?auto=format&fit=crop&w=900&q=80','Operational requirements','Operational requirements','site-image',1 WHERE NOT EXISTS (SELECT 1 FROM cms_media WHERE name='Operational requirements' AND type='site-image');
INSERT INTO cms_media(name,url,alt_en,alt_ar,type,sort_order) SELECT 'Secure architecture','https://images.unsplash.com/photo-1558494949-ef010cbdcc31?auto=format&fit=crop&w=900&q=80','Secure architecture','Secure architecture','site-image',2 WHERE NOT EXISTS (SELECT 1 FROM cms_media WHERE name='Secure architecture' AND type='site-image');
INSERT INTO cms_media(name,url,alt_en,alt_ar,type,sort_order) SELECT 'Technology integration','https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=900&q=80','Technology integration','Technology integration','site-image',3 WHERE NOT EXISTS (SELECT 1 FROM cms_media WHERE name='Technology integration' AND type='site-image');
INSERT INTO cms_media(name,url,alt_en,alt_ar,type,sort_order) SELECT 'Proven methodologies','https://images.unsplash.com/photo-1552664730-d307ca884978?auto=format&fit=crop&w=900&q=80','Proven methodologies','Proven methodologies','site-image',4 WHERE NOT EXISTS (SELECT 1 FROM cms_media WHERE name='Proven methodologies' AND type='site-image');
INSERT INTO cms_media(name,url,alt_en,alt_ar,type,sort_order) SELECT 'Lifecycle support','https://images.unsplash.com/photo-1553877522-43269d4ea984?auto=format&fit=crop&w=900&q=80','Lifecycle support','Lifecycle support','site-image',5 WHERE NOT EXISTS (SELECT 1 FROM cms_media WHERE name='Lifecycle support' AND type='site-image');
INSERT INTO cms_media(name,url,alt_en,alt_ar,type,sort_order) SELECT 'Sophos logo','https://commons.wikimedia.org/wiki/Special:FilePath/Sophos_logo.png','Sophos logo','Sophos logo','site-image',23 WHERE NOT EXISTS (SELECT 1 FROM cms_media WHERE name='Sophos logo' AND type='site-image');
INSERT INTO cms_media(name,url,alt_en,alt_ar,type,sort_order) SELECT 'pfSense logo','https://commons.wikimedia.org/wiki/Special:FilePath/PfSense_logo.png','pfSense logo','pfSense logo','site-image',24 WHERE NOT EXISTS (SELECT 1 FROM cms_media WHERE name='pfSense logo' AND type='site-image');
