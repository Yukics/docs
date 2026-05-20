```
gcloud config set compute/region europe-west3
export REGION=europe-west3
export ZONE=europe-west3-c
```

## Task 1. Create a new instance from the Cloud console

In this section, you create new predefined machine types with Compute Engine from the Cloud console.

1. In the **Cloud console**, on the **Navigation menu** (☰), click **Compute Engine** > **VM Instances**.
    
    > This may take a minute to initialize for the first time.
    
2. To create a new instance, click **Create Instance**.
    
3. In the **Machine configuration**:
    
    Enter the values for the following fields:
    
    |Field|Value|Additional Information|
    |---|---|---|
    |**Name**|**gcelab**|Name for the VM instance|
    |**Region**|`europe-west3`|For more information about regions, see the Compute Engine guide, [Regions and Zones](https://cloud.google.com/compute/docs/zones).|
    |**Zone**|`europe-west3-c`|**Note:** Remember the zone that you selected to use later. For more information about zones, see the Compute Engine guide, [Regions and Zones](https://cloud.google.com/compute/docs/zones).|
    |**Series**|`E2`||
    |**Machine Type**|`e2-medium`|This is an e2-medium, 2-CPU, 4GB RAM instance. Several machine types are available, ranging from micro instance types to 32-core/208GB RAM instance types. For more information, see the Compute Engine guide, [About machine families](https://cloud.google.com/compute/docs/machine-types).|
    

**Note:** A new project has a default [resource quota](https://cloud.google.com/compute/docs/resource-quotas) , which may limit the number of CPU cores. You can request more when you work on projects outside this lab.

4. Click **OS and storage**.
    
    Click **Change** to begin configuring your boot disk and select the values for:
    
    - **Operating system**: Debian
    - **Version**: **Debian GNU/Linux 12 (bookworm)**
    - **Boot disk type**: Balanced persistent disk
    - **Size**: 10 GB
    
    Several images are available, including Debian, Ubuntu, CoreOS, and premium images such as Red Hat Enterprise Linux and Windows Server. For more information, see the [Operating System documentation](https://cloud.google.com/compute/docs/images).
    
5. Click **Networking**.
    
    - **Firewall**: Allow HTTP traffic
    
    Select this option in order to access a web server that you install later.
    
    **Note:** This automatically creates a firewall rule to allow HTTP traffic on port 80.
    
6. Once all sections are configured, scroll down and click **Create** to launch your new virtual machine instance.
    
    It should take about a minute for the VM, `gcelab`, to be created. After `gcelab` is created, the **VM Instances** page lists it in the VM instances list.
    
7. To use SSH to connect to the VM, click **SSH** to the right of the instance name, `gcelab`.
    
    This launches an SSH client directly from your browser.
    

**Note:** Learn more about how to use SSH to connect to an instance from the Compute Engine guide, [Connect to Linux VMs using Google tools](https://cloud.google.com/compute/docs/instances/connecting-to-instance) .

## Task 2. Install an NGINX web server

Now you install an NGINX web server, one of the most popular web servers in the world, to connect your VM to something.

1. Run the following command to update the OS:
    
    sudo apt-get update
    
    Copied!
    
    **Expected output:**
    
    Get:1 file:/etc/apt/mirrors/debian.list Mirrorlist [30 B]
    Get:5 file:/etc/apt/mirrors/debian-security.list Mirrorlist [39 B]
    Get:7 https://packages.cloud.google.com/apt google-compute-engine-bookworm-stable InRelease [1321 B]
    Get:2 https://deb.debian.org/debian bookworm InRelease [151 kB]                         
    Get:3 https://deb.debian.org/debian bookworm-updates InRelease [55.4 kB]
    Get:4 https://deb.debian.org/debian bookworm-backports InRelease [59.0 kB]
    Hit:8 https://packages.cloud.google.com/apt cloud-sdk-bookworm InRelease
    Hit:6 https://deb.debian.org/debian-security bookworm-security InRelease
    Fetched 267 kB in 1s (274 kB/s)
    Reading package lists... Done
    
2. Run the following command to install NGINX:
    
```
    sudo apt-get install -y nginx
```
    
    Copied!
    
    **Expected output:**
    
```
     Reading package lists... Done
     Building dependency tree
     Reading state information... Done
     The following NEW packages will be installed:
     ...
```
    
3. Run the following command to confirm that NGINX is running:
    
```
    ps auwx | grep nginx
```
    
    Copied!
    
    **Expected output:**
    
```
     root      2330  0.0  0.0 159532  1628 ?        Ss   14:06   0:00 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
     www-data  2331  0.0  0.0 159864  3204 ?        S    14:06   0:00 nginx: worker process
     www-data  2332  0.0  0.0 159864  3204 ?        S    14:06   0:00 nginx: worker process
     root      2342  0.0  0.0  12780   988 pts/0    S+   14:07   0:00 grep nginx
```
    
4. To see the web page, return to the Cloud console and click the **External IP** link in the row for your machine, or add the **External IP** value to `http://EXTERNAL_IP/` in a new browser window or tab.
    
    A default web page should open that says: **Welcome to nginx!**
    
    To check your progress in this lab, click **Check my progress** below. A checkmark means you're successful.
## Task 3. Create a new instance with gcloud

Instead of using the Cloud console to create a VM instance, use the command line tool `gcloud`, which is pre-installed in [Google Cloud Shell](https://cloud.google.com/developer-shell/#how_do_i_get_started). Cloud Shell is an interactive shell environment for Google Cloud loaded with all the development tools you need (`gcloud`, `git`, and others) and offers a persistent 5-GB home directory.

**Note:** If you want to try this on your own machine, read the [gcloud command line tool guide](https://cloud.google.com/sdk/gcloud/).

1. In Cloud Shell, run the following `gcloud` command to create a new VM instance from the command line:
    
    gcloud compute instances create gcelab2 --machine-type e2-medium --zone=$ZONE
    
    Copied!
    
    **Expected output:**
    
         Created [...gcelab2].
         NAME: gcelab2
         ZONE: europe-west3-c
         MACHINE_TYPE: e2-medium
         PREEMPTIBLE:
         INTERNAL_IP: 10.128.0.3
         EXTERNAL_IP: 34.136.51.150
         STATUS: RUNNING
    
    To check your progress in this lab, click **Check my progress** below. A checkmark means you're successful.
    
    Create a new instance with gcloud.
    
    The new instance has these default values:
    
    - The [Debian GNU/Linux 12 (bookworm)](https://cloud.google.com/compute/docs/images#debian) image.
    - The `e2-medium` [machine type](https://cloud.google.com/compute/docs/machine-types).
    - A root persistent disk with the same name as the instance; the disk is automatically attached to the instance.
    
    When working in your own project, you can specify a [custom machine type](https://cloud.google.com/compute/docs/instances/creating-instance-with-custom-machine-type).
    
2. To see all the defaults, run the following command:
    
    gcloud compute instances create --help
    
    Copied!
    
    **Note:** You can set the default region and zones that `gcloud` uses if you are always working within one region/zone and you don't want to append the `--zone` flag every time.
    
    To do this, run these commands:
    
    `gcloud config set compute/zone ...`
    
    `gcloud config set compute/region ...`
    
3. To exit `help`, press **CTRL+C**.
    
4. In the Cloud console, on the **Navigation menu** (![Navigation menu icon](https://cdn.qwiklabs.com/tkgw1TDgj4Q%2BYKQUW4jUFd0O5OEKlUMBRYbhlCrF0WY%3D)), click **Compute Engine > VM instances**. Or if you still had the VM instances page open, just click **Refresh**. Your two new instances should be listed.
    
5. You can also use SSH to connect to your instance via `gcloud`. Make sure to add your zone, or omit the `--zone` flag if you've set the option globally:
    
    gcloud compute ssh gcelab2 --zone=europe-west3-c
    
    Copied!
    
6. Enter **Y** to continue.
    
       Do you want to continue? (Y/n)
    
7. Press **Enter** through the passphrase section to leave the passphrase empty.
    
       Generating public/private rsa key pair.
       Enter passphrase (empty for no passphrase)
    
8. After connecting, disconnect from SSH by exiting from the remote shell with the command that follows:
    
    exit
    
    Copied!