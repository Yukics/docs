## Task 1. Create a new instance

First, create a Compute Engine virtual machine instance that has only a boot disk.

**Note:** You can learn more by creating a virtual machine instance in a different lab, or refer to the [Compute Engine documentation](https://cloud.google.com/compute/docs/).

1. In Cloud Shell command line, use the `gcloud` command to create a new virtual machine instance named `gcelab`:

gcloud compute instances create gcelab --zone $ZONE --machine-type e2-standard-2

Copied!

**Example Output:**

Created [...].
NAME       ZONE           MACHINE_TYPE  PREEMPTIBLE INTERNAL_IP EXTERNAL_IP    STATUS
gcelab     europe-west1-b e2-standard-2             10.240.X.X  X.X.X.X        RUNNING

The newly created virtual machine instance will have a default 10 GB persistent disk as the boot disk.

Click **Check my progress** to verify the objective.

## Task 2. Create a new persistent disk

**Note:** Because you want to attach this disk to the virtual machine instance you created in the previous step, the zone must be the same.

1. Still in the Cloud Shell command line, use the following command to create a new disk named `mydisk`:

gcloud compute disks create mydisk --size=200GB \
--zone $ZONE

Copied!

**Output:**

NAME   ZONE          SIZE_GB TYPE        STATUS
mydisk europe-west1-b 200      pd-standard READY

Click **Check my progress** to verify the objective.

## Task 3. Attaching a disk

### Attaching the persistent disk

You can attach a disk to a running virtual machine. Attach the new disk (`mydisk`) to the virtual machine instance you just created (`gcelab`).

1. Use the following command to attach the disk:

gcloud compute instances attach-disk gcelab --disk mydisk --zone $ZONE

Copied!

**Output:**

Updated [https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-d12e3215bb368ac5/zones/europe-west1-b/instances/gcelab].

That's it!

### Finding the persistent disk in the virtual machine

The persistent disk is now available as a block device in the virtual machine instance. Let's take a look.

1. SSH into the virtual machine:

gcloud compute ssh gcelab --zone $ZONE

Copied!

**Output:**

WARNING: The public SSH key file for gcloud does not exist.
WARNING: The private SSH key file for gcloud does not exist.
WARNING: You do not have an SSH key for gcloud.
WARNING: SSH keygen will be executed to generate a key.
This tool needs to create the directory
[/home/gcpstaging8246_student/.ssh] before being able to generate SSH
keys.
Do you want to continue (Y/n)?  y

2. At the prompt, enter Y to continue.
3. When prompted for an RSA key pair passphrase, press ENTER for no passphrase, and then press ENTER again to confirm no passphrase.

**Output:**

Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/gcpstaging8246_student/.ssh/google_compute_en
gine.
Your public key has been saved in /home/gcpstaging8246_student/.ssh/google_compute_engine
.pub.
The key fingerprint is:
6c:04:bf:29:95:0d:93:bc:fe:00:2c:85:86:f8:7a:53 gcpstaging8246_student@cs-6000-devshell-v
m-dbb9559d-4412-4801-ad8c-bdaf885541a9
The key's randomart image is:
+---[RSA 2048]----+
| . . ...o.       |
|. . o .oo=       |
| . . o  =..      |
|  . E o+.o       |
| . . ..oS        |
|. o    oo        |
| . .     o       |
|          .      |
|                 |
+-----------------+
Updating project ssh metadata...\Updated [https://www.googleapis.com/compute/v1/projects/
qwiklabs-gcp-d12e3215bb368ac5].
Updating project ssh metadata...done.
Waiting for SSH key to propagate.
Warning: Permanently added 'compute.7714273689800906026' (ECDSA) to the list of known hosts.
Linux gcelab 4.9.0-4-amd64 #1 SMP Debian 4.9.51-1 (2017-09-28) x86_64
The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.
Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.

4. Now find the disk device by listing the disk devices in `/dev/disk/by-id/.`:

ls -l /dev/disk/by-id/

Copied!

**Output:**

lrwxrwxrwx 1 root root  9 Feb 27 02:24 google-persistent-disk-0 -> ../../sda
lrwxrwxrwx 1 root root 10 Feb 27 02:24 google-persistent-disk-0-part1 -> ../../sda1
lrwxrwxrwx 1 root root  9 Feb 27 02:25 google-persistent-disk-1 -> ../../sdb
lrwxrwxrwx 1 root root  9 Feb 27 02:24 scsi-0Google_PersistentDisk_persistent-disk-0 -> ../../sda
lrwxrwxrwx 1 root root 10 Feb 27 02:24 scsi-0Google_PersistentDisk_persistent-disk-0-part1 -> ../../sda1
lrwxrwxrwx 1 root root  9 Feb 27 02:25 scsi-0Google_PersistentDisk_persistent-disk-1 -> ../../sdb

You found the file, the default name is:

`scsi-0Google_PersistentDisk_persistent-disk-1.`

**Note:** If you want a different device name, when you attach the disk, you would specify the `device-name` parameter. For example, to specify a device name, when you attach the disk you would use the command:

`gcloud compute instances attach-disk gcelab --disk mydisk --device-name <YOUR_DEVICE_NAME> --zone $ZONE`

### Formatting and mounting the persistent disk

Once you find the block device, you can partition the disk, format it, and then mount it using the following Linux utilities:

- `mkfs:` creates a filesystem
- `mount`: attaches to a filesystem

1. Make a mount point:

sudo mkdir /mnt/mydisk

Copied!

2. Next, format the disk with a single `ext4` filesystem using the [mkfs](http://manpages.ubuntu.com/manpages/xenial/man8/mkfs.8.html) tool. This command deletes all data from the specified disk:

sudo mkfs.ext4 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/disk/by-id/scsi-0Google_PersistentDisk_persistent-disk-1

Copied!

**Last lines of the output:**

Allocating group tables: done
Writing inode tables: done
Creating journal (262144 blocks): done
Writing superblocks and filesystem accounting information: done

3. Now use the [mount](http://manpages.ubuntu.com/manpages/xenial/man8/mount.8.html) tool to mount the disk to the instance with the `discard` option enabled:

sudo mount -o discard,defaults /dev/disk/by-id/scsi-0Google_PersistentDisk_persistent-disk-1 /mnt/mydisk

Copied!

That's it!

### Automatically mount the disk on restart

By default the disk will not be remounted if your virtual machine restarts. To make sure the disk is remounted on restart, you need to add an entry into `/etc/fstab`.

1. Open `/etc/fstab` in nano to edit:

sudo nano /etc/fstab

Copied!

2. Add the following below the line that starts with "PARTUUID=...":

/dev/disk/by-id/scsi-0Google_PersistentDisk_persistent-disk-1 /mnt/mydisk ext4 defaults 1 1

Copied!

`/etc/fstab` content should look like this:

# /etc/fstab: static file system information
PARTUUID=12adc097-f36f-46f9-b377-b2a30cdf422f / ext4 rw,discard,errors=remount-ro,x-systemd.growfs 0 1
PARTUUID=3A31-89F9 /boot/efi vfat defaults 0 0
/dev/disk/by-id/scsi-0Google_PersistentDisk_persistent-disk-1 /mnt/mydisk ext4 defaults 1 1

3. Save and exit nano by pressing CTRL+O, ENTER, CTRL+X, in that order.

Click **Check my progress** to verify the objective.

Attaching and Mounting the persistent disk.