---
reference: https://raw.githubusercontent.com/Itsabhishek7py/GoogleCloudSkillsboost/refs/heads/main/Implement%20DevOps%20Workflows%20in%20Google%20Cloud%3A%20Challenge%20Lab/abhishek.sh
---
## Task 1. Create the lab resources

In this section, you initialize your Google Cloud project for the demo environment. You enable the required APIs, configure Git in Cloud Shell, create an Artifact Registry Docker repository, and create a GKE cluster to run your production and development applications on.

1. Run the following command to enable the APIs for GKE, Cloud Build, and GitHub Repositories:

gcloud services enable container.googleapis.com \
    cloudbuild.googleapis.com 

Copied!

2. Add the Kubernetes Developer role for the Cloud Build service account:

export PROJECT_ID=$(gcloud config get-value project)
gcloud projects add-iam-policy-binding $PROJECT_ID \
--member=serviceAccount:$(gcloud projects describe $PROJECT_ID \
--format="value(projectNumber)")@cloudbuild.gserviceaccount.com --role="roles/container.developer"

Copied!

3. In Cloud Shell, run the following commands to configure Git and GitHub:
    
    curl -sS https://webi.sh/gh | sh
    gh auth login
    gh api user -q ".login"
    GITHUB_USERNAME=$(gh api user -q ".login")
    git config --global user.name "${GITHUB_USERNAME}"
    git config --global user.email "${USER_EMAIL}"
    echo ${GITHUB_USERNAME}
    echo ${USER_EMAIL}
    
    Copied!
    
    - Press ENTER to accept the default options.
    - Read the instructions in the command output to log in to GitHub with a web browser.
    
    When you have successfully logged in, your GitHub username appears in the output in Cloud Shell.
    
4. Create an Artifact Registry Docker repository named **my-repository** in the `us-east1` region to store your container images.
    
5. Create a GKE Standard cluster named `hello-cluster` with the following configuration:
    

|Setting|Value|
|---|---|
|**Zone**|`us-east1-c`|
|**Release channel**|**Regular**|
|**Cluster version**|`1.29` _or newer_|
|**Cluster autoscaler**|**Enabled**|
|**Number of nodes**|**3**|
|**Minimum nodes**|**2**|
|**Maximum nodes**|**6**|

6. Create the **`prod`** and **`dev`** namespaces on your cluster.

Click _Check my progress_ to verify the objective.

Create the lab resources

## Task 2. Create a repository in GitHub Repositories

In this task, you create a repository **sample-app** in GitHub Repositories and initialize it with some sample code. This repository holds your Go application code, and be the primary source for triggering builds.

1. Create an empty repository named **sample-app** in GitHub Repositories.
    
2. Clone the **sample-app** GitHub Repository in Cloud Shell.
    
3. Use the following command to copy the sample code into your `sample-app` directory:
    

cd ~
gsutil cp -r gs://spls/gsp330/sample-app/* sample-app

Copied!

4. Run the following command, which will automatically replace the `<your-region>` and `<your-zone>` placeholders in the `cloudbuild-dev.yaml` and `cloudbuild.yaml` files with the assigned region and zone of your project:

export REGION="us-east1"
export ZONE="us-east1-c"
for file in sample-app/cloudbuild-dev.yaml sample-app/cloudbuild.yaml; do
    sed -i "s/<your-region>/${REGION}/g" "$file"
    sed -i "s/<your-zone>/${ZONE}/g" "$file"
done

Copied!

5. Create a GitHub repository with name `sample-app`
    
6. After creating repository make your first commit with the sample code added to your `sample-app` directory, and push the changes to the **master** branch.
    
7. Create a branch named **dev**. Make a commit with the sample code added to your `sample-app` directory and push the changes to the **dev** branch.
    
8. Verify you have the sample code and branches stored in the GitHub Repository.
    

![source repository with branches](https://cdn.qwiklabs.com/rFywEBqZFJ5ggP1IzhEjxGYLT876NRjJ8z9XDdSCIv0%3D)

The code you just cloned contains a simple Go application that has two entry points: Red and Blue. Each displays a simple colored square on the web page depending on the entry point you go to.

## Task 3. Create the Cloud Build Triggers

In this section, you create two Cloud Build Triggers.

- The first trigger listens for changes on the **`master`** branch and builds a **Docker image** of your application, pushes it to Google Artifact Registry, and deploys the latest version of the image to the **prod** namespace in your GKE cluster.
    
- The second trigger listens for changes on the **`dev`** branch and build a Docker image of your application and push it to Google Artifact Registry, and deploy the latest version of the image to the **dev** namespace in your GKE cluster.
    

1. Create a Cloud Build Trigger named **sample-app-prod-deploy** that with the following configurations:
    
    - Event: **Push to a branch**
    - Source:
        - Connect to a new repository and select the source code management provider: `GitHub (Cloud Build GitHub App)`
        - Choose the GitHub repository: `sample-app`
    - Branch: `^master$`
    - Cloud Build Configuration File: `cloudbuild.yaml`
2. Create a Cloud Build Trigger named **sample-app-dev-deploy** that with the following configurations:
    
    - Event: **Push to a branch**
    - Source, Choose the GitHub repository : `sample-app`
    - Branch: `^dev$`
    - Cloud Build Configuration File: `cloudbuild-dev.yaml`

After setting up the triggers, any changes to the branches trigger the corresponding Cloud Build pipeline, which builds and deploy the application as specified in the `cloudbuild.yaml` files.

Click _Check my progress_ to verify the objective.

Create the Cloud Build Triggers

## Task 4. Deploy the first versions of the application

In this section, you build the first version of the production application and the development application.

### Build the first development deployment

1. In Cloud Shell, inspect the `cloudbuild-dev.yaml` file located in the **sample-app** directory to see the steps in the build process. In `cloudbuild-dev.yaml` file, replace the `<version>` on lines 9 and 13 with `v1.0`.
    
2. Navigate to the `dev/deployment.yaml` file and Update the `<todo>` on line 17 with the correct container image name. Also, replace the **`PROJECT_ID`** variable with actual project ID in the container image name.
    

**Note:** Make sure you have same container image name in **dev/deployment.yaml** and **cloudbuild-dev.yaml** file.

3. Make a commit with your changes on the **`dev`** branch and push changes to trigger the **sample-app-dev-deploy** build job.
    
4. Verify your build executed successfully in **Cloud build History** page, and verify the **development-deployment** application was deployed onto the **`dev`** namespace of the cluster.
    
5. [Expose](https://cloud.google.com/kubernetes-engine/docs/how-to/exposing-apps#using_kubectl_expose_to_create_a_service) the **development-deployment** deployment to a **LoadBalancer** service named `dev-deployment-service` on port 8080, and set the target port of the container to the one specified in the Dockerfile.
    
6. Navigate to the Load Balancer IP of the service and add the `/blue` entry point at the end of the URL to verify the application is up and running. It should resemble something like the following: `http://34.135.97.199:8080/blue`.
    

### Build the first production deployment

1. Switch to the **`master`** branch. Inspect the `cloudbuild.yaml` file located in the **sample-app** directory to see the steps in the build process. In `cloudbuild.yaml` file, replace the `<version>` on lines **11** and **16** with `v1.0`.
    
2. Navigate to the `prod/deployment.yaml` file and update the `<todo>` on line 17 with the correct container image name. Also, replace the **`PROJECT_ID`** variable with actual project ID in the container image name.
    

**Note:** Make sure you have same container image name in **prod/deployment.yaml** and **cloudbuild.yaml** file.

3. Make a commit with your changes on the **`master`** branch and push changes to trigger the **sample-app-prod-deploy** build job.
    
4. Verify your build executed successfully in **Cloud build History** page, and verify the **production-deployment** application was deployed onto the **`prod`** namespace of the cluster.
    
5. [Expose](https://cloud.google.com/kubernetes-engine/docs/how-to/exposing-apps#using_kubectl_expose_to_create_a_service) the **production-deployment** deployment on the **`prod`** namespace to a **LoadBalancer** service named `prod-deployment-service` on port 8080, and set the target port of the container to the one specified in the Dockerfile.
    
6. Navigate to the Load Balancer IP of the service and add the `/blue` entry point at the end of the URL to verify the application is up and running. It should resemble something like the following: `http://34.135.245.19:8080/blue`.
    

Click _Check my progress_ to verify the objective.

Deploy the first versions of the application

## Task 5. Deploy the second versions of the application

In this section, you build the second version of the production application and the development application.

### Build the second development deployment

1. Switch back to the **`dev`** branch.

**Note:** Before proceeding, make sure you are on **dev** branch to create deployment for **dev** environment.

2. In the `main.go` file, update the `main()` function to the following:

func main() {
	http.HandleFunc("/blue", blueHandler)
	http.HandleFunc("/red", redHandler)
	http.ListenAndServe(":8080", nil)
}

Copied!

3. Add the following function inside of the `main.go` file:

func redHandler(w http.ResponseWriter, r *http.Request) {
	img := image.NewRGBA(image.Rect(0, 0, 100, 100))
	draw.Draw(img, img.Bounds(), &image.Uniform{color.RGBA{255, 0, 0, 255}}, image.ZP, draw.Src)
	w.Header().Set("Content-Type", "image/png")
	png.Encode(w, img)
}

Copied!

4. Inspect the `cloudbuild-dev.yaml` file to see the steps in the build process. Update the version of the Docker image to `v2.0`.
    
5. Navigate to the `dev/deployment.yaml` file and update the container image name to the new version (`v2.0`).
    
6. Make a commit with your changes on the **`dev`** branch and push changes to trigger the **sample-app-dev-deploy** build job.
    
7. Verify your build executed successfully in **Cloud build History** page, and verify the **development-deployment** application was deployed onto the `dev` namespace of the cluster and is using the `v2.0` image.
    
8. Navigate to the Load Balancer IP of the service and add the `/red` entry point at the end of the URL to verify the application is up and running. It should resemble something like the following: `http://34.135.97.199:8080/red`.
    

**Note:** it may take a couple of minutes for the updates to propagate to your load balancer.

### Build the second production deployment

1. Switch to the **`master`** branch.

**Note:** Before proceeding, make sure you are on **master** branch to create deployment for **master** environment.

2. In the `main.go` file, update the `main()` function to the following:

func main() {
	http.HandleFunc("/blue", blueHandler)
	http.HandleFunc("/red", redHandler)
	http.ListenAndServe(":8080", nil)
}

Copied!

3. Add the following function inside of the `main.go` file:

func redHandler(w http.ResponseWriter, r *http.Request) {
	img := image.NewRGBA(image.Rect(0, 0, 100, 100))
	draw.Draw(img, img.Bounds(), &image.Uniform{color.RGBA{255, 0, 0, 255}}, image.ZP, draw.Src)
	w.Header().Set("Content-Type", "image/png")
	png.Encode(w, img)
}

Copied!

4. Inspect the `cloudbuild.yaml` file to see the steps in the build process. Update the version of the Docker image to `v2.0`.
    
5. Navigate to the `prod/deployment.yaml` file and update the container image name to the new version (`v2.0`).
    
6. Make a commit with your changes on the `master` branch and push changes to trigger the **sample-app-prod-deploy** build job.
    
7. Verify your build executed successfully in **Cloud build History** page, and verify the **production-deployment** application was deployed onto the **`prod`** namespace of the cluster and is using the `v2.0` image.
    
8. Navigate to the Load Balancer IP of the service and add the `/red` entry point at the end of the URL to verify the application is up and running. It should resemble something like the following: `http://34.135.245.19:8080/red`.
    

**Note:** it may take a couple of minutes for the updates to propagate to your load balancer.

Great! You have successfully created fully functioning production and development CI/CD pipelines.

Click _Check my progress_ to verify the objective.

Deploy the second versions of the application

## Task 6. Roll back the production deployment

In this section, you roll back the production deployment to a previous version.

1. Roll back the **production-deployment** to use the `v1.0` version of the application.

**Hint:** Using Cloud build history, you can easily rollback/rebuild the deployments with the previous versions.

2. Navigate to the Load Balancer IP of the service and add the `/red` entry point at the end of the URL of the production deployment and response on the page should be **`404`**.