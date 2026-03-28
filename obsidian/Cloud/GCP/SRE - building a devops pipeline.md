Generar y pushear desde un Dockerfile
```
gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/devops-image:v0.1 .
```

# Apps

Create app
```
gcloud app create --region=us-central
```

Deploy app 
```
gcloud app deploy --version=one --quiet
```

Compute region
```
gcloud config set compute/region us-central1
```

## Buckets
Crear bucket
```
gsutil mb gs://<YOUR-BUCKET-NAME>
```

Copy to bucket
```
gsutil cp ada.jpg gs://YOUR-BUCKET-NAME
```

Copy form bucket
```
gsutil cp -r gs://YOUR-BUCKET-NAME/ada.jpg .
```

Copy to a folder
```
gsutil cp gs://YOUR-BUCKET-NAME/ada.jpg gs://YOUR-BUCKET-NAME/image-folder/
```

List bucket
```
gsutil ls gs://YOUR-BUCKET-NAME
```

List details
```
gsutil ls -l gs://YOUR-BUCKET-NAME/ada.jpg
```

Change permissions
```
gsutil acl ch -u AllUsers:R gs://YOUR-BUCKET-NAME/ada.jpg
```

Remove permissions
```
gsutil acl ch -d AllUsers gs://YOUR-BUCKET-NAME/ada.jpg
```

Delete object
```
gsutil rm gs://YOUR-BUCKET-NAME/ada.jpg
```

## Repos

Create
```
gcloud source repos create REPO_DEMO
```

Clone
```
gcloud source repos clone REPO_DEMO
```

Create registry
```
gcloud artifacts repositories create my-repository --repository-format=docker --location us-central1
```

Push image
```
gcloud builds submit --tag="us-central1-a-docker.pkg.dev/${PROJECT_ID}/my-repository/hello-cloudbuild:${COMMIT_ID}"
```

# Services

Enable
```
gcloud services enable container.googleapis.com \
    cloudbuild.googleapis.com \
    sourcerepo.googleapis.com
```

# Kubernetes

Create
```
gcloud container clusters create hello-cluster --zone=us-central1-a --release-channel=regular --cluster-version="1.26.5-gke.1400" --enable-autoscaling --num-nodes=3 --min-nodes=2 --max-nodes=6
```

Namespaces
```
kubectl create namespace prod
kubectl create namespace dev
```