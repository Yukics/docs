## Task 1. Lab setup

First, set the Google Cloud region and zone.

1. Set the Google Cloud region.

gcloud config set compute/region "europe-west1"

Copied!

2. Set the Google Cloud zone.

gcloud config set compute/zone "europe-west1-b"

Copied!

This lab will use the following Google Cloud Service APIs, and have been enabled for you:

- `compute.googleapis.com`
- `container.googleapis.com`
- `cloudbuild.googleapis.com`

In addition, the Terraform configuration takes three parameters to determine where the Kubernetes Engine cluster should be created:

- `project ID`
- `region`
- `zone`

For simplicity, these parameters are specified in a file named `terraform.tfvars`, in the `terraform` directory.

3. To ensure the appropriate APIs are enabled and to generate the `terraform/terraform.tfvars` file based on your gcloud defaults, run:

make setup-project

Copied!

4. Type `y` when asked to confirm.

This will enable the necessary Service APIs, and it will also generate a `terraform/terraform.tfvars` file with the following keys.

5. Verify the values themselves will match the output of `gcloud config list` by running:

cat terraform/terraform.tfvars

Copied!

### Provisioning the Kubernetes Engine cluster

1. Next, apply the Terraform configuration within the project root:

make tf-apply

Copied!

2. When prompted, review the generated plan and enter `yes` to deploy the environment.

This will take several minutes to deploy.

## Task 2. Validation

Terraform outputs a message when the cluster's been successfully created.

...snip...
google_container_cluster.primary: Still creating... (3m0s elapsed)
google_container_cluster.primary: Still creating... (3m10s elapsed)
google_container_cluster.primary: Still creating... (3m20s elapsed)
google_container_cluster.primary: Still creating... (3m30s elapsed)
google_container_cluster.primary: Creation complete after 3m34s (ID: gke-demo-cluster)

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

**Test completed task**

Click **Check my progress** to verify your performed task. If you have successfully deployed necessary infrastructure with Terraform, you will see an assessment score.

Use Terraform to set up the necessary infrastructure (Lab setup)

1. Now ssh into the bastion for the remaining steps:

gcloud compute ssh gke-demo-bastion

Copied!

Existing versions of kubectl and custom Kubernetes clients contain provider-specific code to manage authentication between the client and Google Kubernetes Engine. Starting with v1.26, this code will no longer be included as part of the OSS kubectl. GKE users will need to download and use a separate authentication plugin to generate GKE-specific tokens. This new binary, `gke-gcloud-auth-plugin`, uses the [Kubernetes Client-go Credential Plugin](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#client-go-credential-plugins) mechanism to extend kubectl’s authentication to support GKE. For more information, you can check out the following [documentation](https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke).

To have kubectl use the new binary plugin for authentication instead of using the default provider-specific code, use the following steps.

2. Once connected, run the following command to install the `gke-gcloud-auth-plugin` on the VM.

sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin

Copied!

3. Set `export USE_GKE_GCLOUD_AUTH_PLUGIN=True` in `~/.bashrc`:

echo "export USE_GKE_GCLOUD_AUTH_PLUGIN=True" >> ~/.bashrc

Copied!

4. Run the following command:

source ~/.bashrc

Copied!

5. Run the following command to force the config for this cluster to be updated to the Client-go Credential Plugin configuration.

gcloud container clusters get-credentials gke-demo-cluster --zone europe-west1-b

Copied!

On success, you should see this message:

kubeconfig entry generated for gke-demo-cluster.

The newly-created cluster will now be available for the standard `kubectl` commands on the bastion.

## Task 3. Installing the hello server

The test application consists of one simple HTTP server, deployed as `hello-server`, and two clients, one of which will be labeled `app=hello` and the other `app=not-hello`.

All three services can be deployed by applying the hello-app manifests.

1. On the bastion, run:

kubectl apply -f ./manifests/hello-app/

Copied!

Output:

deployment.apps/hello-client-allowed created
deployment.apps/hello-client-blocked created
service/hello-server created
deployment.apps/hello-server created

2. Verify all three pods have been successfully deployed:

kubectl get pods

Copied!

You will see one running pod for each of _hello-client-allowed_, _hello-client-blocked_, and _hello-server_ deployments.

NAME                                      READY     STATUS    RESTARTS   AGE
hello-client-allowed-7d95fcd5d9-t8fsk   |  1/1      Running   0          14m
hello-client-blocked-6497db465d-ckbn8   |  1/1      Running   0          14m
hello-server-7df58f7fb5-nvcvd           |  1/1      Running   0          14m

**Test completed task**

Click **Check my progress** to verify your performed task. If you have successfully deployed a simple HTTP hello server, you will see an assessment score.

Installing the hello server

## Task 4. Confirming default access to the hello server

1. First, tail the "allowed" client:

kubectl logs --tail 10 -f $(kubectl get pods -oname -l app=hello)

Copied!

Press CTRL+C to exit.

2. Second, tail the logs of the "blocked" client:

kubectl logs --tail 10 -f $(kubectl get pods -oname -l app=not-hello)

Copied!

3. Press CTRL+C to exit.

You will notice that both pods are successfully able to connect to the `hello-server` service. This is because you have not yet defined a Network Policy to restrict access. In each of these windows you should see successful responses from the server.

Hostname: hello-server-7df58f7fb5-nvcvd
Hello, world!
Version: 1.0.0
Hostname: hello-server-7df58f7fb5-nvcvd
Hello, world!
Version: 1.0.0
Hostname: hello-server-7df58f7fb5-nvcvd
...

## Task 5. Restricting access with a Network Policy

Now you will block access to the `hello-server` pod from all pods that are not labeled with `app=hello`.

The policy definition you'll use is contained in `manifests/network-policy.yaml`

1. Apply the policy with the following command:

kubectl apply -f ./manifests/network-policy.yaml

Copied!

Output:

networkpolicy.networking.k8s.io/hello-server-allow-from-hello-client created

2. Tail the logs of the "blocked" client again:

kubectl logs --tail 10 -f $(kubectl get pods -oname -l app=not-hello)

Copied!

You'll now see that the output looks like this in the window tailing the "blocked" client:

wget: download timed out
wget: download timed out
wget: download timed out
wget: download timed out
wget: download timed out
wget: download timed out
wget: download timed out
wget: download timed out
wget: download timed out
...

The network policy has now prevented communication to the `hello-server` from the unlabeled pod.

3. Press CTRL+C to exit.

## Task 6. Restricting namespaces with Network Policies

In the previous example, you defined a network policy that restricts connections based on pod labels. It is often useful to instead label entire namespaces, particularly when teams or applications are granted their own namespaces.

You'll now modify the network policy to only allow traffic from a designated namespace, then you'll move the `hello-allowed` pod into that new namespace.

1. First, delete the existing network policy:

kubectl delete -f ./manifests/network-policy.yaml

Copied!

Output:

networkpolicy.networking.k8s.io "hello-server-allow-from-hello-client" deleted

2. Create the namespaced version:

kubectl create -f ./manifests/network-policy-namespaced.yaml

Copied!

Output:

networkpolicy.networking.k8s.io/hello-server-allow-from-hello-client created

3. Now observe the logs of the `hello-allowed-client` pod in the default namespace:

kubectl logs --tail 10 -f $(kubectl get pods -oname -l app=hello)

Copied!

You will notice it is no longer able to connect to the `hello-server`.

4. Press CTRL+C to exit.
    
5. Finally, deploy a second copy of the hello-clients app into the new namespace.
    

kubectl -n hello-apps apply -f ./manifests/hello-app/hello-client.yaml

Copied!

Output:

deployment.apps/hello-client-allowed created
deployment.apps/hello-client-blocked created

**Test completed task**

Click **Check my progress** to verify your performed task. If you have successfully deployed a second copy of the hello-clients app into the new namespace, you will see an assessment score.

Deploy a second copy of the hello-clients app into the new namespace

## Task 7. Validation

Next, check the logs for the two new `hello-app` clients.

1. View the logs for the "hello" labeled app in the app in the `hello-apps` namespace by running:

kubectl logs --tail 10 -f -n hello-apps $(kubectl get pods -oname -l app=hello -n hello-apps)

Copied!

Output:

Hostname: hello-server-6c6fd59cc9-7fvgp
Hello, world!
Version: 1.0.0
Hostname: hello-server-6c6fd59cc9-7fvgp
Hello, world!
Version: 1.0.0
Hostname: hello-server-6c6fd59cc9-7fvgp
Hello, world!
Version: 1.0.0
Hostname: hello-server-6c6fd59cc9-7fvgp
Hello, world!
Version: 1.0.0
Hostname: hello-server-6c6fd59cc9-7fvgp

Both clients are able to connect successfully because _as of Kubernetes 1.10.x NetworkPolicies do not support restricting access to pods within a given namespace_. You can allowlist by pod label, namespace label, or allowlist the union (i.e. OR) of both. But you cannot yet allowlist the intersection (i.e. AND) of pod labels and namespace labels.

2. Press CTRL+C to exit.

## Task 8. Teardown

Qwiklabs will take care of shutting down all the resources used for this lab, but here’s what you would need to do to clean up your own environment to save on cost and to be a good cloud citizen:

1. Log out of the bastion host:

exit

Copied!

2. Run the following to destroy the environment:

make teardown

Copied!

Output:

...snip...
google_compute_subnetwork.cluster-subnet: Still destroying... (ID: us-east1/kube-net-subnet, 20s elapsed)
google_compute_subnetwork.cluster-subnet: Destruction complete after 25s
google_compute_network.gke-network: Destroying... (ID: kube-net)
google_compute_network.gke-network: Still destroying... (ID: kube-net, 10s elapsed)
google_compute_network.gke-network: Still destroying... (ID: kube-net, 20s elapsed)
google_compute_network.gke-network: Destruction complete after 26s

Destroy complete! Resources: 5 destroyed.

## Task 9. Troubleshooting in your own environment

### The install script fails with a "permission denied" error when running Terraform

The credentials that Terraform is using do not provide the necessary permissions to create resources in the selected projects. Ensure that the account listed in `gcloud config list` has necessary permissions to create resources. If it does, regenerate the application default credentials using `gcloud auth application-default login`.

### Invalid fingerprint error during Terraform operations

Terraform occasionally complains about an invalid fingerprint, when updating certain resources.

If you see the error below, simply re-run the command. ![terraform fingerprint error](https://cdn.qwiklabs.com/MovqAAg0Chnh9QY%2BsrRn5WUzsqrVNSRw6sB2lF46U1w%3D)