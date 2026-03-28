You can buy drives that came from EMC storage arrays such as the VNX off eBay for dirt cheap these days.
You can find Seagate and Hitachi/HGST variants such as the HGST 2TB 7.2K SAS Server Hard Drive HUS723020ALS640 0B26315 3.5″ that run at 6GB/s for about $25 shipped. You can also find enterprise SSDs and drives from other manufacturers that have a non-standard format applied as well. Note that these are typically true SAS drives and the connector is different from your average computer’s SATA interfaces. That being said, these are enterprise grade drives which means that they will typically last much longer than consumer grade drives.

There’s one little problem… EMC formats these drives with a Block size of 520, which is incompatible with most systems. Fortunately, you can do a Hard Drive Block Size Conversion.

The easiest way to fix these is in a server running Ubuntu with a SAS HBA that can pass the hard drive straight through.

First, install a couple tools:

```bash
su -
apt install curl
curl -O http://sg.danny.cz/sg/p/libsgutils2-2_1.44-0.1_amd64.deb
curl -O http://sg.danny.cz/sg/p/sg3-utils_1.44-0.1_amd64.deb
dpkg -i libsgutils2-2_1.44-0.1_amd64.deb
dpkg -i sg3-utils_1.44-0.1_amd64.deb
```

This will install sg3_utils – otherwise known as The Linux SCSI Generic (sg) Driver. You can read more and find other versions here.

Once installed, the next three commands will help you find and fix the block size.
List SCSI disks in Ubuntu. You will need the /dev/sgX location of the drive in the next step when you go to check the block size then format it.
```bash
sg_scan -i
```

Get the current block size of a hard drive or SSD in Ubuntu!
```bash
sg_readcap /dev/sg2
```

Format the drive to the correct block size / block length:
```bash
sg_format --format --size=512 /dev/sg2
```

Once it’s finished, verify the block size:
```bash
sg_readcap /dev/sg2
```

^^ This is all that has to be done. You can now shut down, move the drive to another system and it should work fine. With a properly configured system, you can do this hot while it is running as well, but do this at your own risk.

Additional info:
Get a hard drive or SSD’s serial number:
```bash
udevadm info --query=all --name=/dev/sda | grep SERIAL
```

Note that ID_SCSI_SERIAL will typically be the SN printed on the drive and the two other ID_SERIAL outputs should match the WWN of the drive.

Other partially useful commands:
```bash
sg_get_config /dev/sg2
sg_inq /dev/sg2
sg_inq -e /dev/sg2
sg_vpd /dev/sg2
sg_vpd --page=bdc /dev/sg2
sg_get_lba_status /dev/sg2
```

Another tool I like to install:
```bash
apt install lsscsi
```

This will quickly list the attached drives (and SAS expanders)
```bash
lsscsi -l
```

If you’d like to see some output, this is what it will look like:
```bash
sg_scan -i
/dev/sg0: scsi0 channel=0 id=0 lun=0 [em]
    TEAC      DVD-ROM DV-28SW   R.2B [rmb=1 cmdq=0 pqual=0 pdev=0x5]
/dev/sg1: scsi2 channel=0 id=0 lun=0
    SEAGATE   ST2000NMCLAR2000  PS10 [rmb=0 cmdq=1 pqual=0 pdev=0x0]
/dev/sg2: scsi2 channel=0 id=1 lun=0
    HP        HP SAS EXP Card   2.10 [rmb=0 cmdq=1 pqual=0 pdev=0xd]
/dev/sg3: scsi3 channel=0 id=0 lun=0 [em]
    Kingston  DataTraveler G3   PMAP [rmb=1 cmdq=0 pqual=0 pdev=0x0]
/dev/sg4: scsi2 channel=0 id=2 lun=0
    SEAGATE   ST2000NMCLAR2000  PS11 [rmb=0 cmdq=1 pqual=0 pdev=0x0]
/dev/sg5: scsi2 channel=0 id=3 lun=0
    HITACHI   HUS72302CLAR2000  C310 [rmb=0 cmdq=1 pqual=0 pdev=0x0]
```

```bash
sg_readcap /dev/sg4
Read Capacity results:
   Last LBA=3846921025 (0xe54b5b41), Number of logical blocks=3846921026
   Logical block length=520 bytes
Hence:
   Device size: 2000398933520 bytes, 1907729.1 MiB, 2000.40 GB, 2.00 TB
```

```bash
sg_format --format --size=512 /dev/sg4
    SEAGATE   ST2000NMCLAR2000  PS11   peripheral_type: disk [0x0]
      Unit serial number: Z1P66SZ4    000094078FVK
      LU name: 5000c50057583883
Mode Sense (block descriptor) data, prior to changes:
  Number of blocks=3846921026 [0xe54b5b42]
  Block size=520 [0x208]

A FORMAT UNIT will commence in 15 seconds
    ALL data on /dev/sg4 will be DESTROYED
        Press control-C to abort
...
Format unit has started
Format in progress, 0.21% done
...
Format in progress, 98.99% done
FORMAT UNIT Complete
```