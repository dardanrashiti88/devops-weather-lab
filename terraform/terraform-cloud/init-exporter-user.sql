-- SQL initialization script
CREATE USER 'exporter'@'%' IDENTIFIED BY 'exporter_password';
GRANT SELECT, PROCESS, REPLICATION CLIENT ON *.* TO 'exporter'@'%';
FLUSH PRIVILEGES;