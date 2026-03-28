Descargar paquetes
https://learn.microsoft.com/en-us/windows/wsl/install-manual#downloading-distributions

# Intalación FAST

1. Instalar 

# Mover instancia WSL
First, shutdown wsl and confirm the name.

```
wsl --shutdown
wsl --list --verbose

  NAME            STATE           VERSION
* Ubuntu-20.04    Stopped         2
```

Then you can export the tar file and import it to D drive:

```
mkdir d:\backuplinux
wsl --export Ubuntu-20.04 d:\backuplinux\ubuntu.tar
wsl --unregister Ubuntu-20.04
mkdir d:\wsl
wsl --import Ubuntu-20.04 d:\wsl\ d:\backuplinux\ubuntu.tar
ubuntu2004.exe config --default-user yourloginname
```

Check d:\wsl, the ext4 file is moved here. Also check the free space on yo

1. wsl --terminate distro_name
2. move the ext4.vhdx file to new_location
3. wsl --unregister distro_name
4. wsl --import-in-place distro_name ext4.vhdx_file_in_new_location

```
ubuntu config --default-user amorell
```

# Kali

[Kali Linux en Windows - WSL2 con GUI - Deep Hacking](https://deephacking.tech/kali-linux-en-windows-wsl-con-gui/)

# Configuración

`%userprofile%/.wslconfig`
 
```
[wsl2]
networkingMode=mirrored
```

# Shrink disk

Referencia: https://stephenreescarter.net/how-to-shrink-a-wsl2-virtual-disk/
## 1st Option
```powershell
optimize-vhd -Path .\ext4.vhdx -Mode full
```

## 2nd Option
Show all wsl instances
```powershell
wsl.exe --list --verbose
```

Stop al wsl instances
```powershell
wsl.exe --terminate <Name>
wsl.exe --shutdown
```

Then execute diskpart
```pwoershell
diskpart 
```

Select the virtual disk to compact
```diskpart
select vdisk file="C:\Users\yuki\AppData\Local\Docker\wsl\data\ext4.vhdx"
```

Compact the disk 
```diskpart
compact vdisk
```

