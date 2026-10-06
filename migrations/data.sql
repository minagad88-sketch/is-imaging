-- ===========================================================================
-- Real content, copied live from the working Hatchable database.
-- Run this AFTER schema.sql. Safe to re-run (WHERE NOT EXISTS / ON CONFLICT).
-- ===========================================================================

-- site_settings (hero text, contact info)
INSERT INTO site_settings(key,value_en,value_ar) VALUES
 ('contact_address','11 Sesostris St., El-Koroba, Heliopolis, Cairo, Egypt','11 شارع سيزوستريس، الكوربة، مصر الجديدة، القاهرة، مصر'),
 ('email','info@is-lfp.com','info@is-lfp.com'),
 ('hero_lead','Imaging Solution is a trusted technology partner delivering integrated digital infrastructure solutions across Egypt — from IT infrastructure and cybersecurity to networking, data center, smart building, power, digital printing and managed services.','تقدم Imaging Solution حلولاً متكاملة للبنية التحتية الرقمية في مصر — من البنية التحتية لتكنولوجيا المعلومات والأمن السيبراني إلى الشبكات ومراكز البيانات والمباني الذكية والطاقة والطباعة الرقمية والخدمات المدارة.'),
 ('hero_title','Integrating technology. Empowering business.','ندمج التكنولوجيا لتمكين الأعمال.'),
 ('phone_1','+20 2 22677524','+20 2 22677524'),
 ('phone_2','+20 2 2277523','+20 2 2277523')
ON CONFLICT (key) DO UPDATE SET value_en=EXCLUDED.value_en, value_ar=EXCLUDED.value_ar, updated_at=now();

-- homepage_products
INSERT INTO homepage_products(tag,name_en,name_ar,description_en,description_ar,image_url,link_url,featured,active,sort_order)
SELECT 'CAD','HP DesignJet T650','HP DesignJet T650','Compact wide-format plotting for architects, engineers and small studios.','طباعة كبيرة المقاس بشكل مدمج للمهندسين والمعماريين والاستوديوهات الصغيرة.','https://www.hp.com/content/dam/sites/worldwide/printers/large-format/designjet-technical-plotters/HP-DesignJet-T650-24-in-printer%402x.jpg','/plotters/',true,true,0
WHERE NOT EXISTS (SELECT 1 FROM homepage_products WHERE name_en='HP DesignJet T650');

INSERT INTO homepage_products(tag,name_en,name_ar,description_en,description_ar,image_url,link_url,featured,active,sort_order)
SELECT 'Graphics','HP DesignJet Z9+','HP DesignJet Z9+','Professional photo quality with high-definition color and finishing features.','جودة احترافية للصور مع ألوان عالية الدقة وإمكانيات تشطيب متقدمة.','https://www.hp.com/content/dam/sites/worldwide/printers/large-format/designjet-technical-plotters/HP_DesignJet_Technical_plotters-Products_T1700-44in.jpg','/plotters/',false,true,1
WHERE NOT EXISTS (SELECT 1 FROM homepage_products WHERE name_en='HP DesignJet Z9+');

INSERT INTO homepage_products(tag,name_en,name_ar,description_en,description_ar,image_url,link_url,featured,active,sort_order)
SELECT 'Signage','HP Latex 700 W','HP Latex 700 W','White-ink capability for high-value signage and versatile substrates.','إمكانية الطباعة بالحبر الأبيض لأعمال اللافتات والخامات المتنوعة.','/assets/hp-latex-700w.jpg','#contact',false,true,2
WHERE NOT EXISTS (SELECT 1 FROM homepage_products WHERE name_en='HP Latex 700 W');

INSERT INTO homepage_products(tag,name_en,name_ar,description_en,description_ar,image_url,link_url,featured,active,sort_order)
SELECT 'Production','HP PageWide XL 4200','HP PageWide XL 4200','High-speed monochrome and color production for technical documents and maps.','إنتاج سريع بالألوان والأسود والأبيض للمخططات والخرائط والمستندات الفنية.','https://www.hp.com/content/dam/sites/worldwide/printers/large-format/designjet-technical-plotters/HP-DesignJet-XL-3600dr-36-in-Multifunction-printer-with-Postscript_PDF%402x.jpg','#contact',false,true,3
WHERE NOT EXISTS (SELECT 1 FROM homepage_products WHERE name_en='HP PageWide XL 4200');

INSERT INTO homepage_products(tag,name_en,name_ar,description_en,description_ar,image_url,link_url,featured,active,sort_order)
SELECT 'SUPPLIES','Original HP Inks & Printheads','أحبار ورؤوس طباعة HP الأصلية','A wider supplies range including cartridges, printheads and maintenance cartridges.','مجموعة مستلزمات تشمل خراطيش الحبر ورؤوس الطباعة وخراطيش الصيانة.','/assets/hp-738-ink.svg','#hp-supplies',false,true,4
WHERE NOT EXISTS (SELECT 1 FROM homepage_products WHERE name_en='Original HP Inks & Printheads');

INSERT INTO homepage_products(tag,name_en,name_ar,description_en,description_ar,image_url,link_url,featured,active,sort_order)
SELECT 'MEDIA','Paper & Media Rolls','رولات الورق وخامات الطباعة','Bond, coated, photo, matte and canvas media for large-format workflows.','خامات Bond وCoated وPhoto وMatte وCanvas لدورات عمل الطباعة كبيرة المقاس.','/assets/hp-media-roll.svg','#contact',false,true,5
WHERE NOT EXISTS (SELECT 1 FROM homepage_products WHERE name_en='Paper & Media Rolls');

-- supplies (HP ink/printhead catalogue) — no unique constraint on sku in the
-- original schema, so each row is guarded with WHERE NOT EXISTS instead of
-- ON CONFLICT (which needs a unique/exclusion constraint to target).
INSERT INTO supplies(sku,family,description_en,description_ar,status,active,sort_order) SELECT '498N4A','HP 738','130-ml Black DesignJet Ink Cartridge','خرطوشة حبر HP 738 أسود 130 مل','N',true,0 WHERE NOT EXISTS (SELECT 1 FROM supplies WHERE sku='498N4A');
INSERT INTO supplies(sku,family,description_en,description_ar,status,active,sort_order) SELECT '498N5A','HP 738','130-ml Cyan DesignJet Ink Cartridge','خرطوشة حبر HP 738 سماوي 130 مل','N',true,1 WHERE NOT EXISTS (SELECT 1 FROM supplies WHERE sku='498N5A');
INSERT INTO supplies(sku,family,description_en,description_ar,status,active,sort_order) SELECT '498N6A','HP 738','130-ml Magenta DesignJet Ink Cartridge','خرطوشة حبر HP 738 أرجواني 130 مل','N',true,2 WHERE NOT EXISTS (SELECT 1 FROM supplies WHERE sku='498N6A');
INSERT INTO supplies(sku,family,description_en,description_ar,status,active,sort_order) SELECT '498N7A','HP 738','130-ml Yellow DesignJet Ink Cartridge','خرطوشة حبر HP 738 أصفر 130 مل','N',true,3 WHERE NOT EXISTS (SELECT 1 FROM supplies WHERE sku='498N7A');
INSERT INTO supplies(sku,family,description_en,description_ar,status,active,sort_order) SELECT '498N8A','HP 738','300-ml Black DesignJet Ink Cartridge','خرطوشة حبر HP 738 أسود 300 مل','N',true,4 WHERE NOT EXISTS (SELECT 1 FROM supplies WHERE sku='498N8A');
INSERT INTO supplies(sku,family,description_en,description_ar,status,active,sort_order) SELECT '676M6A','HP 738','300-ml Cyan DesignJet Ink Cartridge','خرطوشة حبر HP 738 سماوي 300 مل','N',true,5 WHERE NOT EXISTS (SELECT 1 FROM supplies WHERE sku='676M6A');
INSERT INTO supplies(sku,family,description_en,description_ar,status,active,sort_order) SELECT '4S5B5A','HP 768','500-ml Cyan DesignJet Ink Cartridge','خرطوشة حبر HP 768 سماوي 500 مل','N',true,6 WHERE NOT EXISTS (SELECT 1 FROM supplies WHERE sku='4S5B5A');
INSERT INTO supplies(sku,family,description_en,description_ar,status,active,sort_order) SELECT '4S5B6A','HP 768','500-ml Black DesignJet Ink Cartridge','خرطوشة حبر HP 768 أسود 500 مل','N',true,7 WHERE NOT EXISTS (SELECT 1 FROM supplies WHERE sku='4S5B6A');
INSERT INTO supplies(sku,family,description_en,description_ar,status,active,sort_order) SELECT '7K5U5A','HP 769','Black Magenta 1-2 DesignJet Printhead','رأس طباعة HP 769 الأسود والأرجواني 1-2','N',true,8 WHERE NOT EXISTS (SELECT 1 FROM supplies WHERE sku='7K5U5A');
INSERT INTO supplies(sku,family,description_en,description_ar,status,active,sort_order) SELECT 'B3P19A','HP 727','130-ml Cyan DesignJet Ink Cartridge','خرطوشة حبر HP 727 سماوي 130 مل','Current item',true,9 WHERE NOT EXISTS (SELECT 1 FROM supplies WHERE sku='B3P19A');
INSERT INTO supplies(sku,family,description_en,description_ar,status,active,sort_order) SELECT 'B6Y07A','HP 771C','775-ml Matte Black DesignJet Ink Cartridge','خرطوشة حبر HP 771C أسود مطفي 775 مل','Current item',true,10 WHERE NOT EXISTS (SELECT 1 FROM supplies WHERE sku='B6Y07A');
INSERT INTO supplies(sku,family,description_en,description_ar,status,active,sort_order) SELECT 'C1Q13A','HP 764','300-ml Cyan DesignJet Ink Cartridge','خرطوشة حبر HP 764 سماوي 300 مل','Current item',true,11 WHERE NOT EXISTS (SELECT 1 FROM supplies WHERE sku='C1Q13A');
INSERT INTO supplies(sku,family,description_en,description_ar,status,active,sort_order) SELECT 'C1Q37A','HP 773C','775-ml Matte Black DesignJet Ink Cartridge','خرطوشة حبر HP 773C أسود مطفي 775 مل','Current item',true,12 WHERE NOT EXISTS (SELECT 1 FROM supplies WHERE sku='C1Q37A');
INSERT INTO supplies(sku,family,description_en,description_ar,status,active,sort_order) SELECT 'C9370A','HP 72','130-ml Photo Black DesignJet Ink Cartridge','خرطوشة حبر HP 72 أسود صور 130 مل','Current item',true,13 WHERE NOT EXISTS (SELECT 1 FROM supplies WHERE sku='C9370A');
INSERT INTO supplies(sku,family,description_en,description_ar,status,active,sort_order) SELECT 'C9404A','HP 70','Matte Black and Cyan DesignJet Printhead','رأس طباعة HP 70 أسود مطفي وسماوي','Current item',true,14 WHERE NOT EXISTS (SELECT 1 FROM supplies WHERE sku='C9404A');
INSERT INTO supplies(sku,family,description_en,description_ar,status,active,sort_order) SELECT '3ED67A','HP 712','29-ml Cyan DesignJet Ink Cartridge','خرطوشة حبر HP 712 سماوي 29 مل','Current item',true,15 WHERE NOT EXISTS (SELECT 1 FROM supplies WHERE sku='3ED67A');
INSERT INTO supplies(sku,family,description_en,description_ar,status,active,sort_order) SELECT '3ED58A','HP 713','DesignJet Printhead Replacement Kit','طقم استبدال رأس طباعة HP 713 DesignJet','Current item',true,16 WHERE NOT EXISTS (SELECT 1 FROM supplies WHERE sku='3ED58A');
INSERT INTO supplies(sku,family,description_en,description_ar,status,active,sort_order) SELECT '3EE09A','HP 777','DesignJet Printhead','رأس طباعة HP 777 DesignJet','Current item',true,17 WHERE NOT EXISTS (SELECT 1 FROM supplies WHERE sku='3EE09A');
INSERT INTO supplies(sku,family,description_en,description_ar,status,active,sort_order) SELECT '3ED19A','HP 777','DesignJet Maintenance Cartridge','خرطوشة صيانة HP 777 DesignJet','Current item',true,18 WHERE NOT EXISTS (SELECT 1 FROM supplies WHERE sku='3ED19A');
