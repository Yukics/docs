Referencia: https://pve.proxmox.com/wiki/Cluster_Manager#_remove_a_cluster_node
```bash
pvecm expected 1
pvecm status
pvecm nodes
pvecm delnode platon
systemctl status corosync
systemctl restart corosync
```
