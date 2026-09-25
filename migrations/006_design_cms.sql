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
)