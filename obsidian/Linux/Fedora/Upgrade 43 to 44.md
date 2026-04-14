Procedimiento express de actualización (uso EFI):

```bash
sudo dnf upgrade --refresh
sudo dnf system-upgrade download --releasever=44
sudo dnf5 offline reboot
# reiniciamos un par de veces
```

Dejar configuraciones como estaban de etc:

```bash
sudo dnf install rpmconf
sudo rpmconf -a
```

Borrar kernels antiguos:

```bash
#!/usr/bin/env bash

old_kernels=($(dnf repoquery --installonly --latest-limit=-2 -q))
if [ "${#old_kernels[@]}" -eq 0 ]; then
    echo "No old kernels found"
    exit 0
fi

if ! dnf remove "${old_kernels[@]}"; then
    echo "Failed to remove old kernels"
    exit 1
fi

echo "Removed old kernels"
exit 0
```

Borrar claves de firma obsoletas:

```bash
sudo dnf install clean-rpm-gpg-pubkey
sudo clean-rpm-gpg-pubkey
```