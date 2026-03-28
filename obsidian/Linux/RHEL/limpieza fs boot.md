OpenProject: https://wiki/projects/documentacion-data-center/wiki/liberar-espacio-en-el-filesystem-slash-boot

1.  Hacer snapshot de la máquina: `bdpmicpdbiz02`
2.  Listar los archivos del punto de montaje /boot $ `ll -lah /boot`
3.  Listar todos los kernels instalados en el sistema: `$ rpm -qa | grep kernel`
```shell
[root@bdpmicpdbiz02 boot]# rpm -qa | grep kernel
kernel-devel-3.10.0-1160.71.1.el7.x86_64
abrt-addon-kerneloops-2.1.11-60.el7.x86_64
kernel-devel-3.10.0-693.21.1.el7.x86_64
kernel-3.10.0-693.11.6.el7.x86_64
kernel-tools-libs-3.10.0-1160.71.1.el7.x86_64
kernel-3.10.0-1160.71.1.el7.x86_64
kernel-3.10.0-957.10.1.el7.x86_64
kernel-headers-3.10.0-1160.71.1.el7.x86_64
kernel-tools-3.10.0-1160.71.1.el7.x86_64
kernel-devel-3.10.0-957.10.1.el7.x86_64
```
5.  Según la documentación oficial de Redhat: https://access.redhat.com/solutions/1227, ejecutar:
```
package-cleanup --oldkernels --count=N # RHEL 5,6,7
yum remove --oldinstallonly #RHEL 8,9
```
7.  Comprobar que el espacio está liberado con: `$ df -h | grep boot`