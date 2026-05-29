---
source: https://www.courseintern.com/post/qwiklabs/challenge-labs/gsp342-ensure-access-identity-in-google-cloud/
---
# Create role
```bash
gcloud config set compute/zone us-east1-c
```

```yaml
title: "orca_storage_editor_228"
description: "Permissions"
stage: "ALPHA"
includedPermissions:
- storage.buckets.get
- storage.objects.get
- storage.objects.list
- storage.objects.update
- storage.objects.create
```

```bash
gcloud iam service-accounts create orca-private-cluster-870-sa --display-name "Orca Private Cluster Service Account"
gcloud iam roles create orca_storage_editor_228 --project $DEVSHELL_PROJECT_ID --file role-definition.yaml
```

# Create SA
```
gcloud iam service-accounts create orca-private-cluster-870-sa --display-name "Orca Private Cluster Service Account"
```

# Bind
```bash
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member serviceAccount:orca-private-cluster-870-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role roles/monitoring.viewer

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member serviceAccount:orca-private-cluster-870-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role roles/monitoring.metricWriter

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member serviceAccount:orca-private-cluster-870-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role roles/logging.logWriter

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member serviceAccount:orca-private-cluster-870-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role projects/$DEVSHELL_PROJECT_ID/roles/orca_storage_editor_228
```

# Create GKE private
```bash
gcloud container clusters create orca-cluster-592 \
	--num-nodes 1 \
	--master-ipv4-cidr=172.16.0.64/28 \
	--network orca-build-vpc \
	--subnetwork orca-build-subnet \
	--enable-master-authorized-networks  \
	--master-authorized-networks 192.168.10.2/32 \
	--enable-ip-alias \
	--enable-private-nodes \
	--enable-private-endpoint \
	--service-account orca-private-cluster-870-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
	--zone us-east1-c
```

# Deploy app
Ve a compute -> vm instances -> orca-jumphost -> ssh
```bash
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
echo "export USE_GKE_GCLOUD_AUTH_PLUGIN=True" >> ~/.bashrc
source ~/.bashrc
gcloud config set compute/zone us-east1-c
gcloud container clusters get-credentials orca-cluster-592 --internal-ip --project=<project id> --zone us-east1-c
kubectl create deployment hello-server --image=gcr.io/google-samples/hello-app:1.0
kubectl expose deployment hello-server --name orca-hello-service --type LoadBalancer --port 80 --target-port 8080
```
