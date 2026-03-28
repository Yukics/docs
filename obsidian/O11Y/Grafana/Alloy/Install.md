# k8s
```
helm repo add grafana https://grafana.github.io/helm-chartshelm repo update
kubectl create namespace alloy
helm install --namespace alloy alloy grafana/alloy
kubectl get pods -n alloy

wget https://raw.githubusercontent.com/grafana/alloy/main/operations/helm/charts/alloy/values.yaml
nano values
helm upgrade --namespace alloy alloy grafana/alloy -f values.yaml
```
# rhel

Copiar y pegar responder que si a todo
```bash
wget -q -O gpg.key https://rpm.grafana.com/gpg.key

sudo rpm --import gpg.key

echo -e '[grafana]\nname=grafana\nbaseurl=https://rpm.grafana.com\nrepo_gpgcheck=1\nenabled=1\ngpgcheck=1\ngpgkey=https://rpm.grafana.com/gpg.key\nsslverify=1\nsslcacert=/etc/pki/tls/certs/ca-bundle.crt' | sudo tee /etc/yum.repos.d/grafana.repo

yum update

dnf install alloy
```