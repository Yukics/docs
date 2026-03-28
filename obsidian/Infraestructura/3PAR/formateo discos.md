# Manual
![[Guía de instalación de HP 3PAR StoreServ 7000 y 7000c Storage-c03670522.pdf]]

## Configuración
## 70. Conexión a un procesador de servicios físico


# Reset
https://blog.napraw.to/post/reset-hp-3par-storeserv-to-factory-defaults
https://es.scribd.com/document/237120797/3par-deinstallation
Change root password: https://3parug.com/viewtopic.php?t=3936

https://3parug.org/viewtopic.php?t=1851
## CLI
https://support.hpe.com/hpesc/public/docDisplay?docId=sd00005325en_us&page=GUID-9A952ED2-C285-4336-8F3F-499B8F1E1676.html


## Wipe 
https://community.hpe.com/t5/hpe-3par-storeserv-storage/hpe-3par-7400-erase-wipe-disks/m-p/7079768#U7079768
```bash
shutdownsys halt

setsysmgr tocgen
shownode -d


admithw -checkonly # check disk compatibility
removevlun -f -pat *
removevv -f -pat *
showpd -c
removevlun
removeflashcache
compactcpg
showpd -c
```