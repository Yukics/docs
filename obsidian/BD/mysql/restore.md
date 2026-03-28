## Hacemos el backup

```bash
 mysqldump --user=db_user --password=************ --host=127.0.0.1 --port=3306 db_name > file.sql
```

## Creamos la BD y los usuarios necesarios
```
CREATE DATABASE db_name;
SHOW DATABASES;

-- Creamos los usuarios con contraseña y acceso específico
CREATE USER 'db_user'@'<IP>' IDENTIFIED BY '************';
CREATE USER 'db_user'@'localhost' IDENTIFIED BY '************';
SELECT User FROM mysql.user;

-- Asignamos privilegios
GRANT ALL PRIVILEGES ON db_name.* TO 'db_user'@'<IP>';
GRANT ALL PRIVILEGES ON db_name.* TO 'db_user'@'localhost';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'db_user'@'<IP>';
```

## Importamos el backup la BDD
```bash
mysql -u db_user -p db_name < file.sql
```