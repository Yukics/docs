## Open port
1. Get a list of allowed ports in the current zone:
    `firewall-cmd --list-ports`
2. Add a port to the allowed ports to open it for incoming traffic:
    `sudo firewall-cmd --add-port=port-number/port-type`
3. Make the new settings persistent:
    `sudo firewall-cmd --runtime-to-permanent`

The port types are either tcp, udp, sctp, or dccp. 
``` bash
firewall-cmd --new-zone=nagios-access --permanent
firewall-cmd --reload
firewall-cmd --get-zones
firewall-cmd --zone=nagios-access --add-source=192.168.*.*/32 --permanent
firewall-cmd --zone=nagios-access --add-port=5666/tcp  --permanent
firewall-cmd --reload
firewall-cmd --zone=nagios-access --list-all
```

O en 1liner:
```bash
firewall-cmd --permanent –zone=mariadb-access --add-rich-rule='rule family="ipv4" source address="10.*.*.*/20" port protocol="tcp" port="5666" accept'
```

