# Error
One or more devices could not be used because the label is missing or invalid. Sufficient replicas exist for the pool to continue functioning in a degraded state.

# Solution
```bash
zpool status
  pool: rpool
 state: DEGRADED
status: One or more devices could not be used because the label is missing or
        invalid.  Sufficient replicas exist for the pool to continue
        functioning in a degraded state.
action: Replace the device using 'zpool replace'.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-4J
  scan: resilvered 10.3G in 00:11:58 with 0 errors on Thu Nov 28 21:54:23 2024
config:

        NAME                              STATE     READ WRITE CKSUM
        rpool                             DEGRADED     0     0     0
          raidz2-0                        DEGRADED     0     0     0
            scsi-35000c500722fdb7f-part3  ONLINE       0     0     0
            scsi-35000c500722fd397-part3  ONLINE       0     0     0
            scsi-35000c500722dc2b7-part3  ONLINE       0     0     0
            scsi-35000cca059c1291c-part3  ONLINE       0     0     0
            1538858077325439107           UNAVAIL      0     0     0  was /dev/disk/by-id/scsi-35000c500722e7a57-part3
            scsi-35000c500722f8e53-part3  ONLINE       0     0     0


ls /dev/disk/by-id | grep -i scsi | grep "part3"
scsi-35000c500722dc2a7-part3
scsi-35000c500722dc2b7-part3
scsi-35000c500722e6f9b-part3
scsi-35000c500722e807f-part3
scsi-35000c500722e85eb-part3
scsi-35000c500722f8e53-part3
scsi-35000c500722fd397-part3
scsi-35000c500722fdb7f-part3
scsi-35000cca059c1291c-part3

zpool replace rpool /dev/disk/by-id/scsi-35000c500722e7a57-part3 /dev/disk/by-id/scsi-35000c500722dc2a7-part3
```