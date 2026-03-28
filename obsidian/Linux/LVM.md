https://www.alibabacloud.com/help/en/ecs/use-cases/use-lvm-to-create-a-logical-volume#9b94fed0092mo

To scan for new disks :
```shell
echo "- - -" | sudo tee /sys/class/scsi_host/host*/scan >/dev/null
```

To rescan existing disks :
```shell
echo 1 | sudo tee /sys/class/block/sd?/device/rescan >/dev/null
```
## PV
### Crear múltiple pv

```bash
lsblk | grep disk | grep -vE "(sda|sdb)" |awk '{print $1}' | xargs -I % pvcreate /dev/%
```

## VG
## LV
Reference https://web.mit.edu/rhel-doc/5/RHEL-5-manual/Cluster_Logical_Volume_Manager/LV_create.html

```shell
lvextend -L +20G /dev/VolGroup02/lv01
```