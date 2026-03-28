Échale un ojo a: https://archlinux.org/

```bash
#ejecuta timeshift
pacman -Sy archlinux-keyring && pacman -Su

# elimina de la cache la paquetería antigua (pacman-contrib)
paccache -r

# limpiar paquetes huerfanos
pacman -Rns $(pacman -Qtdq)

# revisar servicios que han reventado
systemctl --failed

# seleccionar los repos mas rapidos
reflector --latest 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# borrar el lock de pacman (a veces pasa)
rm /var/lib/pacman/db.lck
```