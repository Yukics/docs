## IPTABLES

### Agregar acceso despues de n linea
```bash
iptables -I INPUT -s hostname -j ACCEPT

iptables -L INPUT -n --line-numbers

iptables -D INPUT <N>
```

### Persistir acceso
```bash
nano /etc/sysconfig/iptables
-A INPUT -p tcp -m tcp --dport nPort -j ACCEPT
iptables-restore < /etc/sysconfig/iptables
```
