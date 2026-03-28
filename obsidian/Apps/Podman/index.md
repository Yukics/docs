 Windows location:
 & 'C:\Users\amorell\AppData\Local\Programs\podman-desktop\Podman Desktop.exe'

Exponer:
```shell
netsh interface portproxy add v4tov4 listenport=3000 listenaddress=0.0.0.0 connectport=3000 connectaddress=172.24.29.47
```

Crear machine exponible:

```shell
podman machine init --user-mode-networking
```

# kubectl y compose

agregar al path c:\Apps


```
curl.exe -LO https://dl.k8s.io/release/v1.33.0/bin/windows/amd64/kubectl.exe
PS C:\Apps> [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
PS C:\Apps>  Start-BitsTransfer -Source "https://github.com/docker/compose/releases/download/v2.37.3/docker-compose-windows-x86_64.exe" -Destination docker-compose.exe
```