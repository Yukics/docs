```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod +x get_helm.sh
./get_helm.sh
helm
helm repo add bitnami https://charts.bitnami.com/bitnami
helm search repo bitnami
```

# Si se queda colgado un delete

```bash
kubectl patch helmchart traefik -n kube-system --type merge -p '{"metadata":{"finalizers":null}}'
```