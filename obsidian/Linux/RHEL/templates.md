
cambiar el teclado
```bash
localectl list-keymaps
localectl status
localectl set-keymap us
```

cambiar el idioma por defecto
```
localectl list-locales
localectl set-locale LANG=en_US
```

modificar fuente:
```
cat /etc/vconsole.conf
FONT="<fuente_x>"
```

agregar mensaje antes del login ssh:
```
/etc/issue
```

desactivar creación de claves rsa y ecdsa para que por defecto use ed25519
```
systemctl mask sshd-keygen@rsa.service
systemctl mask sshd-keygen@ecdsa.service
```

excluir conexiones que no sean ed25519:
```
# HostKey /etc/ssh/ssh_host_rsa_key
# HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
```

desactivar x11 forwarding:
```
X11Forwarding no
```

permitir acceso desde X IP y el usuario tiene que estar en X grupo:
```
AllowUsers *@192.168.1.* *@10.0.0.* !*@192.168.1.2
AllowGroups example-group
```

modificacion de políticas cripto:
```
update-crypto-policies --set FUTURE
```