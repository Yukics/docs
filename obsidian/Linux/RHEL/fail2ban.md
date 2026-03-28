https://www.atlantic.net/vps-hosting/how-to-install-fail2ban-with-firewalld-on-oracle-linux-8/

## Step 1 – Create Atlantic.Net Cloud Server

First, log in to your [Atlantic.Net Cloud Server](https://cloud.atlantic.net/?page=userlogin). Create a new [server](https://www.atlantic.net/cloud-hosting/how-to-create-new-atlantic-net-cloud-server/), choosing Oracle Linux 8 as the operating system with at least 2GB RAM. Connect to your Cloud Server via SSH and log in using the credentials highlighted at the top of the page.

Once you are logged in to your server, run the following command to update your base system with the latest available packages.
```
dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
dnf update -y
```

## Step 2 – Configure Firewalld

By default, Firewalld comes pre-installed in the Oracle Linux 8. You can check whether it is installed or not using the following command:
```
dnf info firewalld
```
If the Firewalld is installed, you will get the following output:
```
Installed Packages
Name         : firewalld
Version      : 0.9.3
Release      : 7.0.2.el8
Architecture : noarch
Size         : 2.0 M
Source       : firewalld-0.9.3-7.0.2.el8.src.rpm
Repository   : @System
From repo    : anaconda
Summary      : A firewall daemon with D-Bus interface providing a dynamic firewall
URL          : http://www.firewalld.org
License      : GPLv2+
Description  : firewalld is a firewall service daemon that provides a dynamic customizable
             : firewall with a D-Bus interface.
```
Next, verify whether Firewalld is running or not.
```


systemctl status firewalld
```
You should see that the Firewalld service is masked:
```
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:firewalld(1)
```
You will need to unmask the Firewalld service. You can unmask it using the following command:
```
systemctl unmask firewalld
```
Next, start the Firewalld service and enable it to start at system reboot:
```
systemctl start firewalld
systemctl enable firewalld
```
## Step 3 – Install Fail2Ban

By default, the Fail2ban package is not included in the Oracle Linux 8 default repo, so you will need to install the EPEL repo to your system. Run the following command to install the EPEL repo:
```
dnf install epel-release -y
```
Next, run the following command to install the Fail2ban package on your server:
```
dnf install fail2ban fail2ban-firewalld -y
```
Once Fail2ban is installed, start and enable the Fail2ban service using the following command:
```
systemctl start fail2ban
systemctl enable fail2ban
```
You can also verify the Fail2ban version using the following command:
```
fail2ban-client --version
```
Sample output:
```
Fail2Ban v0.11.2
```
## Step 4 – Configure Fail2Ban

By default, Fail2ban is configured to use Iptables firewall, so you will need to configure Fail2ban to work with Firewalld.

First, rename the Firewalld configuration file for Fail2ban using the following command:
```
mv /etc/fail2ban/jail.d/00-firewalld.conf /etc/fail2ban/jail.d/00-firewalld.local
```
Next, copy the Fail2ban default configuration file:
```
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```
Next, edit the jail.local file:
```
nano /etc/fail2ban/jail.local
```
Find the following lines:
```
banaction = iptables-multiport
banaction_allports = iptables-allports
```
And replace them with the following lines:
```
banaction = firewallcmd-rich-rules[actiontype=]
banaction_allports = firewallcmd-rich-rules[actiontype=]
```
Save and close the file, then restart Fail2ban to apply the changes:
```
systemctl restart fail2ban
```
At this point, Fail2ban is configured to work with Firewalld.

## Step 5 – Secure SSH Service with Fail2Ban

By default, Fail2ban is not configured to block any IP addresses. You will need to enable the specific jail for each service you want to protect.

To protect the SSHD service, edit the jail.local file:
```
nano /etc/fail2ban/jail.local
```
Find the [sshd] section and enable it by adding the following lines:
```
[sshd]

enabled = true
port    = ssh
logpath = %(sshd_log)s
backend = %(sshd_backend)s
bantime = 10m
findtime = 10m
maxretry = 5
```
Save and close the file, then restart Fail2ban to apply the changes:
```
systemctl restart fail2ban
```
You can now verify the Fail2ban status using the following command:
```
systemctl status fail2ban
```
You will get the following output:
```
● fail2ban.service - Fail2Ban Service
   Loaded: loaded (/usr/lib/systemd/system/fail2ban.service; disabled; vendor preset: disabled)
   Active: active (running) since Tue 2022-06-28 07:32:46 EDT; 3s ago
     Docs: man:fail2ban(1)
  Process: 3887 ExecStop=/usr/bin/fail2ban-client stop (code=exited, status=0/SUCCESS)
  Process: 3924 ExecStartPre=/bin/mkdir -p /run/fail2ban (code=exited, status=0/SUCCESS)
 Main PID: 3925 (fail2ban-server)
    Tasks: 5 (limit: 11409)
   Memory: 17.1M
   CGroup: /system.slice/fail2ban.service
           └─3925 /usr/bin/python3.6 -s /usr/bin/fail2ban-server -xf start

Jun 28 07:32:46 oraclelinux8 systemd[1]: Starting Fail2Ban Service...
Jun 28 07:32:46 oraclelinux8 systemd[1]: Started Fail2Ban Service.
Jun 28 07:32:46 oraclelinux8 fail2ban-server[3925]: Server ready
```
## Step 6 – Verify Fail2ban Firewall

At this point, Fail2ban is configured to protect the SSH service. Now, it’s time to check whether Fail2ban works.

First, verify the jail configuration using the following command:
```
fail2ban-client status
```
You should see the following output:
```
Status
|- Number of jail:	1
`- Jail list:	sshd
```
Now, go to the remote machine and try to connect to the SSH server with an incorrect password. After reaching the maxretry “5” times, your IP address will be blocked by Fail2Ban.

Now, check the IP address blocked by Fail2ban using the following command:
```
fail2ban-client status sshd
```
You should get the following output:
```s for the jail: sshd
|- Filter
|  |- Currently failed:	1
|  |- Total failed:	6
|  `- Journal matches:	_SYSTEMD_UNIT=sshd.service + _COMM=sshd
`- Actions
   |- Currently banned:	1
   |- Total banned:	1
   `- Banned IP list:	10.61.187.115
```
You can check the rules added by Firewalld with the following command:
```
firewall-cmd --list-rich-rules
```
You will get the following output:
```
rule family="ipv4" source address="10.61.187.115" port port="ssh" protocol="tcp" reject type="icmp-port-unreachable"
```
You can also check the Fail2ban logs for more information:
```
tail -f /var/log/fail2ban.log
```
Sample output:
```
2022-06-27 10:37:21,837 fail2ban.filter         [21186]: INFO    [sshd] Found 10.61.187.115 - 2022-06-27 10:37:21
2022-06-27 10:37:21,859 fail2ban.actions        [21186]: NOTICE  [sshd] Ban 10.61.187.115
2022-06-27 10:37:27,220 fail2ban.filter         [21186]: INFO    [sshd] Found 10.61.187.115 - 2022-06-27 10:37:27
```