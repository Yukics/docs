Échale un ojo a: https://archlinux.org/

# Aztualizar keyring y paquetería
```bash
# ejecuta antes timeshift
pacman -Sy archlinux-keyring && pacman -Su
```

# Elimina de la cache la paquetería antigua
```bash
# pacman-contrib
paccache -r
```

# Limpiar paquetes huerfanos
```bash
pacman -Rns $(pacman -Qtdq)
```

# Revisar servicios que fallan
```bash
systemctl --failed
```

# Seleccionar los repos mas rapidos
```bash
reflector --latest 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
```

# Borrar el lock de pacman (a veces pasa)
```bash
rm /var/lib/pacman/db.lck
```