-- Development only. This runs once, when the MySQL volume is created.
CREATE DATABASE IF NOT EXISTS ventas_db;
CREATE DATABASE IF NOT EXISTS despachos_db;

GRANT ALL PRIVILEGES ON ventas_db.* TO 'despacho_user'@'%';
GRANT ALL PRIVILEGES ON despachos_db.* TO 'despacho_user'@'%';
FLUSH PRIVILEGES;
