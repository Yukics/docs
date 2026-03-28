
https://hub.docker.com/r/grafana/loki-docker-driver/tags

```bash
docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions
docker plugin enable loki
```

No tiene sentido hacer esto porque es un bucle infinito, pero funciona:
```json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "loki",
  "log-opts": {
        "max-size": "100m",
        "loki-url": "https://loki.confucio.yuki.es/loki/api/v1/push",
        "loki-batch-size": "400",
        "loki-tls-insecure-skip-verify": "true",
        "loki-tls-ca-file": "/root/certs/rootCA.crt",
        "loki-external-labels": "container_name={{.Name}}"
  },
  "default-address-pools": [{"base":"10.10.0.0/16","size":24}],
  "storage-driver": "overlay2"
}
```