# Instalación
# Monitorización

Instalación `mc`
```bash
curl https://dl.min.io/client/mc/release/linux-amd64/mc \
  --create-dirs \
  -o $HOME/minio-binaries/mc

chmod +x $HOME/minio-binaries/mc
export PATH=$PATH:$HOME/minio-binaries/

mc --help
```

Definición del alias:
```bash
mc alias set yuki http://192.168.69.202:9000 admin <password>
```

Exposición del endpoint de métricas:
```bash
mc admin prometheus generate yuki
```

![[Pasted image 20250126180444.png]]


