USE lab_db;

-- Create a user with native password authentication for phpMyAdmin
CREATE USER IF NOT EXISTS 'pma_user'@'%' IDENTIFIED WITH mysql_native_password BY 'pma_password';
GRANT ALL PRIVILEGES ON lab_db.* TO 'pma_user'@'%';
FLUSH PRIVILEGES; 