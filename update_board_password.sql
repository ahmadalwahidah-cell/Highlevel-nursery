-- Update board admin password to 5050
UPDATE system_settings SET value = '5050' WHERE key = 'board_admin_password';
INSERT OR REPLACE INTO system_settings (key, value, updated_at) VALUES ('board_admin_password', '5050', CURRENT_TIMESTAMP);
