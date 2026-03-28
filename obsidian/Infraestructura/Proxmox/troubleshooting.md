### Modificar quorum necesario del cluster

```
pvecm expected <N>
```

### Cambiar nombre de nodo
Spoiler, se pierden las MV. Hay que hacer un backup de todo.
```
/etc/hosts
/etc/hostname
/etc/mailname
/etc/postfix/main.cf
rm -rf /etc/pve/nodes/old-node
```

### Revisar temas de iostat
```bash
zpool iostat rpool -yv 5

pool                              alloc   free   read  write   read  write
--------------------------------  -----  -----  -----  -----  -----  -----
rpool                              186G  21.6T      1  2.10K  16.8K  80.2M
  raidz3-0                         186G  21.6T      1  2.10K  16.8K  80.2M
    scsi-35000c5006245de83-part3      -      -      0    188  2.40K  6.78M
    scsi-35000cca06d8a9f7c-part3      -      -      0    187  2.40K  6.70M
    scsi-35000c5006245ed83-part3      -      -      0    177  1.60K  6.61M
    scsi-35000c5006245f557-part3      -      -      0    171  1.60K  6.58M
    scsi-35000c5006245ed93-part3      -      -      0    185  1.60K  6.82M
    scsi-35000c5006245d4eb-part3      -      -      0    180  1.60K  6.76M
    scsi-35000c500624196af-part3      -      -      0    171  1.60K  6.64M
    scsi-35000c5006241aa0f-part3      -      -      0    171  1.60K  6.64M
    scsi-35000c5006241aa17-part3      -      -      0    188      0  6.83M
    scsi-35000c50062465ddf-part3      -      -      0    181      0  6.69M
    scsi-35000c500624199e3-part3      -      -      0    174      0  6.60M
    scsi-35000c500624667af-part3      -      -      0    177  2.40K  6.56M
--------------------------------  -----  -----  -----  -----  -----  -----

```