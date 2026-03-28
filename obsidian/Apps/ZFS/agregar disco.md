```bash
ls /dev/disk/by-id | grep -i scsi | grep "part3"

zpool attach rpool 
```

```
scsi-35000c500722e6f9b-part3
scsi-35000c500722e807f-part3
scsi-35000c500722e85eb-part3
```