
```bash
pacman -S ly
for i in $(seq 1 6); do systemctl disable getty@tty$1; done
for i in $(seq 1 6); do systemctl enable ly@tty$1; done
reboot
```