CREATE TABLE IF NOT EXISTS cms_sections (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 section_key text NOT NULL UNIQUE,
 label_en text NOT NULL DEFAULT '',
 label_ar text NOT NULL DEFAULT '',
 visible boolean NOT NULL DEFAULT true,
 sort_order integer NOT NULL DEFAULT 0,
 updated_at timestamptz NOT NULL DEFAULT now()
)