```
[root@confucio watch]# apt install timeshift
[root@confucio watch]# cat /etc/timeshift/timeshift.json
{
  "backup_device_uuid" : "957f4bc5-5335-4a02-9f34-ea5533ede05a",
  "parent_device_uuid" : "",
  "do_first_run" : "false",
  "btrfs_mode" : "false",
  "include_btrfs_home_for_backup" : "false",
  "include_btrfs_home_for_restore" : "false",
  "stop_cron_emails" : "true",
  "schedule_monthly" : "false",
  "schedule_weekly" : "false",
  "schedule_daily" : "false",
  "schedule_hourly" : "false",
  "schedule_boot" : "false",
  "count_monthly" : "2",
  "count_weekly" : "3",
  "count_daily" : "5",
  "count_hourly" : "6",
  "count_boot" : "5",
  "date_format" : "%Y-%m-%d %H:%M:%S",
  "exclude" : [
    "/home/yuki/**",
    "/root/**"
  ],
  "exclude-apps" : []
}
[root@confucio watch]# lsblkid
bash: lsblkid: instrucción no encontrada...
^C
[root@confucio watch]# ^C
[root@confucio watch]# blkid
/dev/sda2: UUID="957f4bc5-5335-4a02-9f34-ea5533ede05a" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="c8882131-2ee6-4ad1-8234-59d017f8b94f"
/dev/sda3: LABEL="fedora" UUID="81a16278-10b0-4c4f-bada-d2e6cbfeeb24" UUID_SUB="8c28068f-ede6-478d-9696-54580df74e00" BLOCK_SIZE="4096" TYPE="btrfs" PARTUUID="8219b267-c608-4e4f-811d-89c130a391c9"
/dev/sda1: UUID="533C-3721" BLOCK_SIZE="512" TYPE="vfat" PARTLABEL="EFI System Partition" PARTUUID="a7b91fe6-196f-4a5e-8977-6cb5917bbe06"
/dev/zram0: LABEL="zram0" UUID="c3ba2292-911f-4899-967b-c6ce75767f20" TYPE="swap"

[root@confucio watch]# timeshift --list-devices
Mounted '/dev/sda3' at '/run/timeshift/883896/backup'

Devices with Linux file systems:

Num     Device         Size   Type  Label
------------------------------------------------------------------------------
0    >  /dev/sda2    1.1 GB   ext4
1    >  /dev/sda3  498.4 GB  btrfs  fedora

[root@confucio watch]# timeshift --create --comments "20250222" --tags "D"
Mounted '/dev/sda3' at '/run/timeshift/883992/backup'
------------------------------------------------------------------------------
Estimating system size...
Creating new snapshot...(RSYNC)
Saving to device: /dev/sda3, mounted at path: /run/timeshift/883992/backup
Syncing files with rsync...
  0.00% complete (??? remaining)
```