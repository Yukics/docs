## Configuración del Postgres
```bash
# Hacemos que postgres escuche en todas las IPv4
sudo sed -i "s/^#listen_addresses = 'localhost'/listen_addresses = '0.0.0.0'/" \
	/var/lib/pgsql/15/data/postgresql.conf

# Permitimos conexiones a todas las BD
echo "host all all 0.0.0.0/0 md5" |  \
	sudo tee -a /var/lib/pgsql/15/data/pg_hba.conf  

# Restart PostgreSQL service  
sudo systemctl restart postgresql-15
```
## Creamos un usuario con contraseña
```bash
sudo -u postgres psql -c "CREATE USER k3s WITH PASSWORD '08d18h30d138fr';"  
sudo -u postgres psql -c "ALTER USER k3s WITH PASSWORD 'eWDbbRQ6J3vw';"
```

## Agregar usuario al role de superusuario
```bash
sudo -u postgres psql -c "ALTER USER k3s WITH SUPERUSER;"
```

## Creamos una BD con un propietario
```bash
sudo -u postgres psql -c "CREATE DATABASE kubernetes OWNER k3s;"  
```

## Matar todas las sesiones de una BD
```sql
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'k3s' -- ← change this to your DB
  AND pid <> pg_backend_pid();
```