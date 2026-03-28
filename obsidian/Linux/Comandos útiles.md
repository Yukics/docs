#info
### Exportar lista de permisos a fichero:

```bash
find <directorio> -exec stat --format='%n %A %U %G' {} \; | sort > <fcihero_salida>
```

### Comparar directorios
```bash
diff -qr dir1 dir2
```

### Debuggear errores de red
```bash
ethtool -S ens192 | grep error
```

### Sacar metricas de red del último min

```bash
nstat -d 5 -t 60
```

### Info tomcat  ps
```bash
ps aux | grep java | grep tomcat
```

### Listar todos los servicios
```bash
service --status-all
```

## Listar inodos por FS
```bash
df -ih
```

## Conocer inodo de un fichero
```bash
stat /ruta/fichero
```

## EZ stress test
```bash
while true; do
        for ((i=0; i <=1000000; i++)); do
                result=$(($i * $i * $i * $i))
        done
done
```

Tree
```bash
find . | sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/|-\1/" 
```

## Tar

### Crear
```bash
tar -czvf file.tar.gz directory
```

### Extraer
```bash
tar -xzv -f file.tar.gz -C directory
```