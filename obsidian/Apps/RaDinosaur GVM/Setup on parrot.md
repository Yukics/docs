# Troubleshoot

Si `ldd /usr/sbin/openv | grep "not found"` muestra alguna librería no encontrada. Crear un enalce simbólico, Ej: 
```shell
ln -s /usr/lib64/libopenvas_nasl.so.21 /lib/x86_64-linux-gnu/
```

Debugear que sucede:
```shell
journalctl -xeu ospd-openvas.service
```