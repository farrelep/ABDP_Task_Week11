-- Opsional: hanya jika user webappskuliah belum punya privilege ke DB webappskuliah.
-- Biasanya tidak perlu karena DB webappskuliah sudah ada & user-nya sudah match.

GRANT ALL PRIVILEGES ON webappskuliah.* TO 'webappskuliah'@'%';
FLUSH PRIVILEGES;
