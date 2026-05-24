## Task 1. Set the region and zone

1. Set the project region for this lab:

```
gcloud config set compute/zone us-east4-c
```

2. Create a variable for region:

```
export REGION=us-east4
```

3. Create a variable for zone:

```
export ZONE=us-east4-c
```

Learn more from the [Regions & Zones documentation](https://cloud.google.com/compute/docs/regions-zones/regions-zones).

**Note:** When you run `gcloud` on your own machine, the config settings are persisted across sessions. But in Cloud Shell, you need to set this for every new session or reconnection.

## Task 2. Creating a private cluster

1. When you create a private cluster, you must specify a `/28` CIDR range for the VMs that run the Kubernetes master components and you need to enable IP aliases.

Next you'll create a cluster named `private-cluster`, and specify a CIDR range of `172.16.0.16/28` for the masters. When you enable IP aliases, you let Kubernetes Engine automatically create a subnetwork for you.

You'll create the private cluster by using the `--private-cluster`, `--master-ipv4-cidr`, and `--enable-ip-alias` flags.

2. Run the following to create the cluster:

```
gcloud beta container clusters create private-cluster \
    --enable-private-nodes \
    --master-ipv4-cidr 172.16.0.16/28 \
    --enable-ip-alias \
    --create-subnetwork "" \
    --machine-type e2-medium
```

## Task 3. View your subnet and secondary address ranges

1. List the subnets in the default network:

```
gcloud compute networks subnets list --network default
```

2. In the output, find the name of the subnetwork that was automatically created for your cluster. For example, `gke-private-cluster-subnet-xxxxxxxx`. Save the name of the cluster, you'll use it in the next step.
    
3. Now get information about the automatically created subnet, replacing `[SUBNET_NAME]` with your subnet by running:
    

```
gcloud compute networks subnets describe [SUBNET_NAME] --region=$REGION
```

The output shows you the primary address range with the name of your GKE private cluster and the secondary ranges:

```yaml
...
ipCidrRange: 10.0.0.0/22
kind: compute#subnetwork
name: gke-private-cluster-subnet-163e3c97
...
privateIpGoogleAccess: true
...
secondaryIpRanges:
- ipCidrRange: 10.40.0.0/14
  rangeName: gke-private-cluster-pods-163e3c97
- ipCidrRange: 10.0.16.0/20
  rangeName: gke-private-cluster-services-163e3c97
...
```

In the output you can see that one secondary range is for **pods** and the other secondary range is for **services**.

Notice that `privateIPGoogleAccess` is set to `true`. This enables your cluster hosts, which have only private IP addresses, to communicate with Google APIs and services.

## Task 4. Enable master authorized networks

At this point, the only IP addresses that have access to the master are the addresses in these ranges:

- The primary range of your subnetwork. This is the range used for nodes.
- The secondary range of your subnetwork that is used for pods.

To provide additional access to the master, you must authorize selected address ranges.

### Create a VM instance

1. Create a source instance which you'll use to check the connectivity to Kubernetes clusters:

```
gcloud compute instances create source-instance --zone=$ZONE --machine-type=e2-medium --scopes 'https://www.googleapis.com/auth/cloud-platform'
```

2. Get the `<External_IP>` of the `source-instance` with:

```
gcloud compute instances describe source-instance --zone=$ZONE | grep natIP
```

**Example Output:**

natIP: 35.192.107.237

3. Copy the `<nat_IP>` address and save it to use in later steps.
    
4. Run the following to Authorize your external address range, replacing `[MY_EXTERNAL_RANGE]` with the CIDR range of the external addresses from the previous output (your CIDR range is `natIP/32`). With CIDR range as `natIP/32`, we are allowlisting one specific IP address:
    
```
gcloud container clusters update private-cluster \
    --enable-master-authorized-networks \
    --master-authorized-networks [MY_EXTERNAL_RANGE]
```

**Note:** In a production environment replace `[MY_EXTERNAL_RANGE]` with your network external address CIDR range.

**Test completed task**

Click **Check my progress** to verify your performed task. If you have successfully authorized external address range, you will see an assessment score.

Authorize your external address range

Now that you have access to the master from a range of external addresses, you'll install `kubectl` so you can use it to get information about your cluster. For example, you can use `kubectl` to verify that your nodes do not have external IP addresses.

1. SSH into `source-instance` with:

```
gcloud compute ssh source-instance --zone=$ZONE
```

2. Press `Y` to continue. **Enter** through the passphrase questions.
    
3. In SSH shell install `kubectl` component of Cloud-SDK:
    

```
sudo apt-get install kubectl
```

4. Configure access to the Kubernetes cluster from SSH shell with:

```
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
gcloud container clusters get-credentials private-cluster --zone=$ZONE
```

**Note:** Please make sure that the assigned zone has been exported in the `ZONE` variable. If not, run the following command: `` export ZONE=`us-east4-c` ``

5. Verify that your cluster nodes do not have external IP addresses:

```
kubectl get nodes --output yaml | grep -A4 addresses
```

The output shows that the nodes have internal IP addresses but do not have external addresses:

```yaml
...
addresses:
- address: 10.0.0.4
  type: InternalIP
- address: ""
  type: ExternalIP
...
```

6. Here is another command you can use to verify that your nodes do not have external IP addresses:

```
kubectl get nodes --output wide
```

The output shows an empty column for `EXTERNAL-IP`:

```
STATUS ... VERSION        EXTERNAL-IP   OS-IMAGE ...
Ready      v1.8.7-gke.1                 Container-Optimized OS from Google
Ready      v1.8.7-gke.1                 Container-Optimized OS from Google
Ready      v1.8.7-gke.1                 Container-Optimized OS from Google
```

7. Close the SSH shell by typing:

exit

## Task 5. Clean Up

1. Delete the Kubernetes cluster:

```
gcloud container clusters delete private-cluster --zone=$ZONE
```

2. Press `Y` to continue.

**Test completed task**

Click **Check my progress** to verify your performed task. If you have successfully deleted the Kubernetes cluster, you will see an assessment score.

Delete the Kubernetes cluster

## Task 6. Create a private cluster that uses a custom subnetwork

In the previous section Kubernetes Engine automatically created a subnetwork for you. In this section, you'll create your own custom subnetwork, and then create a private cluster. Your subnetwork has a primary address range and two secondary address ranges.

1. Create a subnetwork and secondary ranges:

```
gcloud compute networks subnets create my-subnet \
    --network default \
    --range 10.0.4.0/22 \
    --enable-private-ip-google-access \
    --region=$REGION \
    --secondary-range my-svc-range=10.0.32.0/20,my-pod-range=10.4.0.0/14
```

**Test completed task**

Click **Check my progress** to verify your performed task. If you have successfully created a subnetwork and secondary ranges in `us-east4` region, you will see an assessment score.

Create a subnetwork and secondary ranges in `us-east4` region

2. Create a private cluster that uses your subnetwork:

```
gcloud beta container clusters create private-cluster2 \
    --enable-private-nodes \
    --enable-ip-alias \
    --master-ipv4-cidr 172.16.0.32/28 \
    --subnetwork my-subnet \
    --services-secondary-range-name my-svc-range \
    --cluster-secondary-range-name my-pod-range \
    --zone=$ZONE \
    --machine-type e2-medium
```

**Test completed task**

Click **Check my progress** to verify your performed task. If you have successfully created a private cluster that uses your subnetwork, you will see an assessment score.

Create a private cluster that uses your subnetwork

3. Retrieve the external address range of the source instance:

```
gcloud compute instances describe source-instance --zone=$ZONE | grep natIP
```

**Example Output:**

```
natIP: 35.222.210.67
```

4. Copy the `<nat_IP>` address and save it to use in later steps.
    
5. Run the following to Authorize your external address range, replacing `[MY_EXTERNAL_RANGE]` with the CIDR range of the external addresses from the previous output (your CIDR range is `natIP/32`). With CIDR range as `natIP/32`, we are allowlisting one specific IP address:

```
gcloud container clusters update private-cluster2 \
    --enable-master-authorized-networks \
    --zone=$ZONE \
    --master-authorized-networks [MY_EXTERNAL_RANGE]
```

**Test completed task**

Click **Check my progress** to verify your performed task. If you have successfully authorized your external address range for a private cluster in a custom subnetwork, you will see an assessment score.

Authorize your external address range for private cluster in custom subnetwork

6. SSH into `source-instance` with:

```
gcloud compute ssh source-instance --zone=$ZONE
```

7. Configure access to the Kubernetes cluster from SSH shell with:

```
gcloud container clusters get-credentials private-cluster2 --zone=$ZONE
```

**Note:** Please make sure that the assigned zone has been exported in the `ZONE` variable. If not, run the following command: `` export ZONE=`us-east4-c` ``

8. Verify that your cluster nodes do not have external IP addresses:

```
kubectl get nodes --output yaml | grep -A4 addresses
```

The output shows that the nodes have internal IP addresses but do not have external addresses:

```
...
addresses:
- address: 10.0.4.3
  type: InternalIP
...
```

At this point, the only IP addresses that have access to the master are the addresses in these ranges:

- The primary range of your subnetwork. This is the range used for nodes. In this example, the range for nodes is `10.0.4.0/22`.
- The secondary range of your subnetwork that is used for pods. In this example, the range for pods is `10.4.0.0/14`.