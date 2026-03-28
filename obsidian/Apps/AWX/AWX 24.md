# Preparación SO
## Paquetería

Nos suscribimos a Satellite y ejecutamos: 

```bash
dnf install git
```
## Configuración de discos

Ejecutamos:
```bash
pvcreate /dev/sdc /dev/sdd
vgcreate backup /dev/sdd
vgcreate postgres /dev/sdc
lvcreate -l +100%FREE -n data postgres
lvcreate -l +100%FREE -n data backup
mkfs.xfs /dev/postgres/data
mkfs.xfs /dev/backup/data
mkdir /postgres
mkdir /backup_postgres
nano /etc/fstab
```

Agregamos:
```bash
/dev/postgres/data      /postgres               xfs     defaults        0 0
/dev/backup/data        /backup_postgres        xfs     defaults        0 0
```

Montamos discos:
```bash
systemctl daemon-reload
mount -a
```

# Instalación BD

Nos suscribimos a Red Hat Satellite con el procedimiento de Yuki

Ejecutamos:
```bash
dnf module install postgresql:15/server # instalamos postgres 15 (version soportada por awx 24)
id postgres # Comprobamos si existe el usuario
chown -R postgres:postgres /postgres # le damos propiedad a su carpeta de base de datos
chown -R postgres:postgres /backup_postgres
chmod 740 /postgres # le damos permisos a su carpeta de base de datos
chmod 740 /backup_postgres # le damos permisos a su carpeta de base de datos
```

Debido a la recomendación que vemos en el `postgres.service` usaremos overrides para no modificar el `.service` original:
![[Pasted image 20250207104012.png]]

Documentación relacionada:
https://www.postgresql.org/message-id/20180723174049.c6zs3kg5cra52npt%40vault.lan

Modificamos el path de postgres con un override:
```bash
systemctl edit postgresql
```

![[Pasted image 20250207105917.png]]

Si ejecutamos el siguiente comando podremos ver si funciona o no:
```bash
systemctl daemon-reload
systemd-delta --type=extended
```

Inicializamos la BD y la arrancamos:
```bash
/usr/bin/postgresql-setup --initdb
systemctl start postgresql.service
systemctl enable postgresql.service
```

Revisamos que todo arranque como debe:
```bash
[root@samaecpdans01 postgres]# su - postgres
[postgres@samaecpdans01 ~]$ psql
psql (15.8)
Type "help" for help.

postgres=# show config_file;
        config_file
---------------------------
 /postgres/postgresql.conf
(1 row)

postgres=# \d
Did not find any relations.
postgres=# \du
                                   List of roles
 Role name |                         Attributes                         | Member of
-----------+------------------------------------------------------------+-----------
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}

postgres=# show data_directory;
 data_directory
----------------
 /postgres
(1 row)

postgres=#

```

Modificamos la configuración de postgres para permitir conexiones:
```bash
nano /postgres/postgresql.conf
```

Modificamos el `listen_addresses`:
```
#------------------------------------------------------------------------------
# CONNECTIONS AND AUTHENTICATION
#------------------------------------------------------------------------------

# - Connection Settings -

listen_addresses = '0.0.0.0'          # what IP address(es) to listen on;
                                        # comma-separated list of addresses;
                                        # defaults to 'localhost'; use '*' for all
```

> [!info] Si ponemos `*` intentará escuchar en IPv6

Podemos modificar el pg_hba.conf para permitir conexiones externas:
```bash
nano /postgres/pg_hba.conf
```

Como queda el fichero:
```
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
#host    all             all             127.0.0.1/32            ident
host    all             all             127.0.0.1/32            md5
host    awx             awx             192.168.223.223/32      md5
# IPv6 local connections:
#host    all             all             ::1/128                 ident
# Allow replication connections from localhost, by a user with the
# replication privilege.
#local   replication     all                                     peer
#host    replication     all             127.0.0.1/32            ident
#host    replication     all             ::1/128                 ident
```

Creamos la BD y el usuario:
```bash
sudo -u postgres psql
```

```sql
DROP DATABASE IF EXISTS "awx24";
CREATE DATABASE "awx24";  

\c awx;

REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM awx;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM awx;
REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public FROM awx;
DROP USER IF EXISTS awx;
CREATE USER awx WITH PASSWORD '**************'; 
ALTER USER awx WITH SUPERUSER;
GRANT ALL PRIVILEGES ON DATABASE awx24 TO awx;
ALTER DATABASE awx24 OWNER TO awx;

--para salir
\q 
```

Restore del backup antiguo recogido desde la versión anterior de AWX:
```shell
su - postgres
psql
CREATE DATABASE awx16;  
ALTER DATABASE awx16 OWNER TO awx;
\q

pg_restore -d awx16 -Fc -v 25.07.15_awx_db.dump
pg_restore -d awx24 -Fc -v 25.07.15_awx_db.dump # el operador migrará esta BD más tarde
```

Configuramos el backup:
```bash
mkdir -p /admin/cron
touch /admin/cron/backup_diario.sh
chown postgres: /admin/cron/backup_diario.sh
chmod 500 /admin/cron/backup_diario.sh
nano /admin/cron/backup_diario.sh
```

Pegamos:
```bash
#!/bin/bash

FECHA=`date +%Y-%m-%d`
FECHA_NAME=`date +%Y-%m-%d-%H`
SALIDA=/backup_postgres/dump_log_$FECHA.log
CHECK4NAGIOS=/backup_postgres/confirmacion.txt

rm -f `find /backup_postgres/dump_log_* -mtime +7`
rm -f `find /backup_postgres/*.sql.gz -mtime +7`

###################
# DUMP POSTRGESQL #
###################

echo "******* INICIO DUMP `date` ********" > $SALIDA

echo "******* DUMP LOGICO POSTRGESQL -> ********" >> $SALIDA
pg_dumpall > /backup_postgres/backup_dump_root_awx_$FECHA_NAME.sql 2>/backup_postgres/database.err


VALOR1=$?
echo "******* TAR.GZ DEL DUMP -> ********" >> $SALIDA
cd /backup_postgres/
gzip backup_dump_root_awx_$FECHA_NAME.sql
VALOR2=$?
chmod 440 backup_dump_root_awx_$FECHA_NAME.sql.gz

if [ ! -f $CHECK4NAGIOS ]; then
echo "$FECHA" | tee -a $CHECK4NAGIOS
fi

if [ $VALOR1 == 0 ]; then
        if [ $VALOR2 == 0 ]; then
                echo -e "$FECHA \n0" > $CHECK4NAGIOS
                echo "Backup realizado correctamente el dia $FECHA" | tee -a $SALIDA
                exit 0
        else
                echo -e "$FECHA \n1" > $CHECK4NAGIOS
                echo "!!! ERROR EN LA COMPRESION DEL POSTRGESQL" | tee -a $SALIDA
                exit $VALOR2
        fi
else
        echo -e "$(head -n 1 $CHECK4NAGIOS) \n2" > $CHECK4NAGIOS
        echo "!!! ERROR EN EL DUMP DE POSTRGESQL, Revisar problema en fichero /backup_postgres/database.err" | tee -a  $SALIDA
        exit $VALOR1
fi

exit $VALOR
```

Probamos que el envío de correos funciona:
```bash
echo "test" | mailx amorell@yuki.es
```

Una vez recibido, configuramos el crontab:
```bash
crontab -e
```

Pegamos:
```
00 6 * * * su - postgres -c "/admin/cron/backup_diario.sh" | mailx -r samaecpdans01@yuki.es -s "Backup Diario de AWX MAE PRO" alertas.sistemas@yuki.es
```

# Certificados Yuki

Posteriormente los utilizaremos para el HTTPS del servicio Web:
```bash
cd /root/k3s/certs

./certs.sh

[INFO] You are creating a new cert for "ES" !
Define ou (Google Devs, Google IT) to be set up: Datacenter
Define altnames (dev.google.com,it.google.com) to be set up: awx.yuki.es
Define IP altnames (192.168.1.1,192.168.1.2) to be set up:
Certificate request self-signature ok
subject=C = ES, ST = Palma, L = Yuki, O = Lab, OU = Yuki, CN = awx.yuki.es
[INFO] PKCS#12 password is needed.Enter Export Password:
Verifying - Enter Export Password:
Generating DH parameters, 2048 bit long safe prime

........................................................................................
<contraido>
++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++**
awx.yuki.es.crt: OK
[INFO] New cert & key created for "awx.yuki.es" !

ll /root/k3s/certs/awx.yuki.es/ # Comprobar que se han creado correctamente
```

# Instalación AWX
## Instalación k3s

*k3s* es el reemplazo a *docker* en la anterior instalación de AWX, debido a como ha evolucionado la aplicación, ya no se nos permite seguir teniéndola fuera de kubernetes

Nos aseguramos que el firewall esté apagado:
```bash
systemctl disable firewalld --now
```

Creamos un script con las 2 configuraciones que nos interesan:
```bash
mkdir -p /root/k3s
touch /root/k3s/install.sh
chmod 700 /root/k3s/install.sh
nano /root/k3s/install.sh
```

Pegamos:
```bash
#!/bin/bash

curl -sfL https://get.k3s.io | \
K3S_TOKEN="268a983d7bc998a6bf3c********" \ # puede ser cualquier cosa
sh -s -
```

Al ejecutarlo esta es la salida, en ella vemos como agrega un repositorio extra e instala desde la paquetería de ese repositorio el binario:
```bash
[root@samaecpdans01 k3s]# ./install.sh
[INFO]  Finding release for channel stable
[INFO]  Using v1.31.5+k3s1 as release
[INFO]  Downloading hash https://github.com/k3s-io/k3s/releases/download/v1.31.5+k3s1/sha256sum-amd64.txt
[INFO]  Downloading binary https://github.com/k3s-io/k3s/releases/download/v1.31.5+k3s1/k3s
[INFO]  Verifying binary download
[INFO]  Installing k3s to /usr/local/bin/k3s
[INFO]  Finding available k3s-selinux versions
Updating Subscription Management repositories.
Rancher K3s Common (stable)                                                     3.6 kB/s | 1.5 kB     00:00
Red Hat Enterprise Linux 9 for x86_64 - BaseOS (RPMs)                            15 kB/s | 4.1 kB     00:00
datadog                                                                          11 kB/s | 2.9 kB     00:00
Mongo_RHEL9                                                                     4.9 kB/s | 1.3 kB     00:00
Red Hat Enterprise Linux 9 for x86_64 - Supplementary (RPMs)                     71 kB/s | 3.7 kB     00:00
Red Hat Enterprise Linux 9 for x86_64 - AppStream (RPMs)                         17 kB/s | 4.5 kB     00:00
Nagios Official Repository RHEL 9                                               5.7 kB/s | 1.5 kB     00:00
Dependencies resolved.
================================================================================================================
 Package                 Architecture       Version                 Repository                             Size
================================================================================================================
Installing:
 k3s-selinux             noarch             1.6-1.el9               rancher-k3s-common-stable              22 k

Transaction Summary
================================================================================================================
Install  1 Package

Total download size: 22 k
Installed size: 96 k
Downloading Packages:
k3s-selinux-1.6-1.el9.noarch.rpm                                                 39 kB/s |  22 kB     00:00
----------------------------------------------------------------------------------------------------------------
Total                                                                            39 kB/s |  22 kB     00:00
Rancher K3s Common (stable)                                                      10 kB/s | 2.4 kB     00:00
Importing GPG key 0xE257814A:
 Userid     : "Rancher (CI) <ci@rancher.com>"
 Fingerprint: C8CF F216 4551 26E9 B9C9 18BE 925E A29A E257 814A
 From       : https://rpm.rancher.io/public.key
Key imported successfully
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                        1/1
  Running scriptlet: k3s-selinux-1.6-1.el9.noarch                                                           1/1
  Installing       : k3s-selinux-1.6-1.el9.noarch                                                           1/1
  Running scriptlet: k3s-selinux-1.6-1.el9.noarch                                                           1/1
  Verifying        : k3s-selinux-1.6-1.el9.noarch                                                           1/1
Installed products updated.

Installed:
  k3s-selinux-1.6-1.el9.noarch

Complete!
[INFO]  Creating /usr/local/bin/kubectl symlink to k3s
[INFO]  Creating /usr/local/bin/crictl symlink to k3s
[INFO]  Creating /usr/local/bin/ctr symlink to k3s
[INFO]  Creating killall script /usr/local/bin/k3s-killall.sh
[INFO]  Creating uninstall script /usr/local/bin/k3s-uninstall.sh
[INFO]  env: Creating environment file /etc/systemd/system/k3s.service.env
[INFO]  systemd: Creating service file /etc/systemd/system/k3s.service
[INFO]  systemd: Enabling k3s unit
Created symlink /etc/systemd/system/multi-user.target.wants/k3s.service → /etc/systemd/system/k3s.service.
[INFO]  systemd: Starting k3s

```

Ruta de repositorio de k3s: `/etc/yum.repos.d/rancher-k3s-common.repo` 

Contenido del fichero de configuración del respositorio:
```bash
name=Rancher K3s Common (stable)
baseurl=https://rpm.rancher.io/k3s/stable/common/centos/9/noarch
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://rpm.rancher.io/public.key
```

Definiremos un alias para `kubectl`, con tal de mejorar nuestra experiencia a lo largo de la instalación y posterior administración:
```bash
echo 'alias k="/usr/local/bin/kubectl"' >> /etc/bashrc
ln -s /usr/local/bin/kubectl /usr/bin/kubectl
reset
```

Si el `reset` no funciona, salir y volvernos a meter en la sesión

Validamos la instalación con un:
```bash
[root@samaecpdans01]# k get pods -A
NAMESPACE     NAME                                      READY   STATUS      RESTARTS   AGE
kube-system   coredns-ccb96694c-8bfgc                   1/1     Running     0          50s
kube-system   helm-install-traefik-7gd28                0/1     Completed   1          50s
kube-system   helm-install-traefik-crd-dnqdg            0/1     Completed   0          50s
kube-system   local-path-provisioner-5cf85fd84d-7cntp   1/1     Running     0          50s
kube-system   metrics-server-5985cbc9d7-8zr8c           1/1     Running     0          50s
kube-system   svclb-traefik-a0dfa63a-j8pqr              2/2     Running     0          41s
kube-system   traefik-5d45fc8cc9-4wzv2                  1/1     Running     0          41s

```

Al instalarse se generan unos certificados CA que en principio deberían durar 10 años. En caso de que caduquen se debería ejecutar: [`k3s certificate rotate-ca`](https://docs.k3s.io/cli/certificate#certificate-authority-ca-certificates)
### Configuración CoreDNS

El fichero de configuración está localizado en: `/var/lib/rancher/k3s/server/manifests/coredns.yaml`. Este fichero no debe ser modificado puesto que se sobrescribirá solo. Sin embargo, vemos como este fichero tiene preparadas las directivas import:

![[Pasted image 20250207122805.png]]

Por ello crearemos un recurso específico para que CoreDNS solicite el dominio yuki.es a nuestros DNS.

```bash
mkdir -p /root/k3s/manifests
nano coredns-custom.yaml
```

Pegamos:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns-custom
  namespace: kube-system
data:
  yuki.es.server: |
    yuki.es:53 {
        errors
        cache 30
        forward . 192.168.223.1        
        forward . 192.168.253.61
        forward . 192.168.253.62
    }
```

Aplicamos la configuración:
```bash
k apply -f coredns-custom.yaml
```

Reiniciamos el pod de coredns:
```bash
k delete pod $(k get pods -n kube-system | grep coredns | awk '{print $1}') -n kube-system
```

Revisamos los logs:
```
k logs $(k get pods -n kube-system | grep coredns | awk '{print $1}') -n kube-system
```
![[Pasted image 20250207122915.png]]

Podemos probarlo ejecutando un ping desde el contenedor de traefik, por ejemplo:
```bash
k exec -n kube-system -it $(k get pod -n kube-system | egrep "^traefik" | awk '{print $1}') -- ping -c 1 awx.yuki.es
```

![[Pasted image 20250207123303.png]]
### Configuración Traefik

Creamos un fichero: `/var/lib/rancher/k3s/server/manifests/traefik-config.yaml` con el contenido:

```yaml
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: traefik
  namespace: kube-system
spec:
  valuesContent: |-
    dashboard:
      enabled: true # activamos el dashboard
    globalArguments:
      - --entrypoints.web.http.redirections.entrypoint.permanent=true
      - --entrypoints.web.http.redirections.entryPoint.to=:443
# POSIBLE AYUDA FUTURA SI HAY QUE EXPONER OTRO TIPO DE SERVICIOS POR TCP O UDP
#      - --entryPoints.postgresql.address=:5432/tcp
#    entrypoints:
#      postgres:
#        address: ":5432/tcp"
#    ports:
#      postgres:
#        expose: true
#        exposedPort: 5432
#        port: 5432
#        protocol: TCP
# CONFIGURACION DE EJEMPLO DE K3S
#    image:
#      repository: docker.io/library/traefik
#      tag: 3.3.5
#    ports:
#      web:
#        forwardedHeaders:
#          trustedIPs:
#            - 10.0.0.0/8
#
```

Creamos un fichero con la configuración del middleware que obligara a usar siempre https `/root/k3s/manifests/traefik/traefik-middleware-http-to-https.yaml`:

```
apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: http-to-https
  namespace: kube-system
spec:
  redirectScheme:
    scheme: https
    permanent: true
```

Lo aplicamos:

```bash
k apply -f /root/k3s/manifests/traefik/traefik-middleware-http-to-https.yaml
```

Crearemos un fichero con la configuración TLS `/root/k3s/manifests/traefik/traefik-dashboard-tls.yaml`:

```yaml
apiVersion: v1
data:
  tls.crt: <...>
  tls.key: <...>
kind: Secret
metadata:
  creationTimestamp: null
  name: traefik-tls-secret
  namespace: kube-system
type: kubernetes.io/tls
```

Para generar el contenido:

```shell
cat <fichero> | base64 -w 0
```

Lo aplicamos:

```bash
k apply -f /root/k3s/manifests/traefik/traefik-dashboard-tls.yaml
```

Creamos un fichero con la configuración de entrada al dashboard `/root/k3s/manifests/traefik/traefik-dashboard-ingress.yaml`

```yaml
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: traefik-ingressroute-dashboard
  namespace: kube-system
spec:
  entryPoints:
    - web
    - websecure
  tls:
    secretName: traefik-tls-secret
  routes:
  - kind: Rule
    match: Host(`traefik.awx.yuki.es`)
    middlewares:
    - name: http-to-https
      namespace: kube-system
    services:
    - kind: TraefikService
      name: api@internal
      passHostHeader: true
      strategy: RoundRobin
      sticky:
        cookie:
          httpOnly: true
          name: cookie
          secure: true
          sameSite: none
```

Lo aplicamos:

```bash
k apply -f /root/k3s/manifests/traefik/traefik-dashboard-ingress.yaml
```

Se podrá acceder al dashboard de Traefik a través de: https://traefik.awx.yuki.es/dashboard/#/. Es útil para saber que le pasa a la aplicación.
### Configuración almacenamiento

k3s automáticamente configura un StorageClass que guarda los pvc en: `/var/lib/rancher/k3s/storage`

### Configuración de la red interna

+ [Basic Network Options | K3s](https://docs.k3s.io/networking/basic-network-options#dual-stack-ipv4--ipv6-networking)
## Instalación operador

Documentación de referencia: 
+ https://ansible.readthedocs.io/projects/awx-operator/en/latest/
+ https://ansible.readthedocs.io/projects/awx-operator/en/latest/installation/basic-install.html

```bash
cd /root/k3s/manifests
git clone https://github.com/ansible/awx-operator.git
cd awx-operator
git tag
git checkout tags/2.19.1
make deploy
kubectl get pods -n awx # comprobamos que exista el operador
kubectl config set-context --current --namespace=awx # definimos el nuevo ns como lugar de trabajo
```

## Instalación instancia de AWX
### Preparación de las imágenes

Crearemos 3 repositorios de acceso público:
1. [apps/awx](https://registry-pmi.yuki.es/repository/apps/awx)
2. [apps/awx-ee](https://registry-pmi.yuki.es/repository/apps/awx-ee)
3. [apps/redis](https://registry-pmi.yuki.es/repository/apps/redis)

Lo único que contienen de la organización las imágenes, es la CA, por lo que no es realmente muy importante. Los `Dockerfile` para generar las nuevas imágenes de próximos ciclos de actualización se encuentran en `/root/k3s`:
+ `Dockerfile.awx`
+ `Dockerfile.awx-ee`
+ `Dockerfile.redis`

Para generar las imágenes y subirlas al registry, simplemente ejecutar:

```shell
/root/k3s/build_images.sh
```
### Instalación

```
kubectl config set-context --current --namespace=awx
```

Todos los recursos necesarios para el despliegue de la nueva instancia están ubicados en `/root/k3s/manifests/awx` por lo que hay un script para aplicarlos todos de golpe llamado, `awx_pro.sh` en `/root/k3s`

```shell
#!/bin/bash

cd manifests/awx
ls | xargs -I % kubectl apply -f %
```

Estructura de ficheros:

```shell
certs/ # script para generación de certificados
manifests/
	awx/
		awx-pro-admin-password.yaml # contrseña del admin
		awx-pro-custom-certificates.yaml # ejemplo configuración confianza certificados, no se usa
		awx-pro-db-connection.yaml # cadena de conexión a la BDD
		awx-pro-instance.yaml # definición de la instancia de AWX
		awx-pro-proxy.yaml # acceso al AWX a través de Traefik (como quien dice el Router de Openshift)
		awx-pro-pull-secret.yaml # credenciales para descargar imagenes de nuestro registry
		awx-pro-secret-key.yaml # secret key heredado de la anterior instancia
		awx-pro-storage.yaml # definición del almacenamiento de los proyectos en la MV
		awx-pro-tls.yaml # definición de los certificates que usará Traefik
	awx-operator/ # contiene la instalación del operador
	coredns/ 
		coredns-custom.yaml # los DNS que usará k3s
	traefik/
		traefik-dashboard-ingress.yaml # acceso al Dashboard de Traefik
		traefik-dashboard-tls.yaml # definición de los certificates que usará Traefik en el Dashboard
		traefik-middleware-http-to-https.yaml # para obligar a siempre ir por https
```

Modificamos al gusto `awx-pro-instance.yaml` y una vez lo apliquemos se conectará a la BDD con la versión antigua y aplicará todas las migraciones.
Al acabar de aplicar las migraciones podremos acceder a la nueva instancia de AWX a través del `awx.yuki.es` o si queremos bypassear el Traefik, mediante la IP y el puerto expuesto en el servicio (`kubectl get svc -A`).
## Configuración instancia de AWX

### Configurar https

Generar un par de certificados, en `/root/k3s/certs` he dejado un script llamado `certs.sh`, lo ejecutamos y seguimos el prompt:

```shell
[INFO] You are creating a new cert for "ES" !
Define ou (Google Devs, Google IT) to be set up: Yuki
Define altnames (dev.google.com,it.google.com) to be set up: *.awx.yuki.es,ansible.yuki.es,samaecpdans01.yuki.es
Define IP altnames (192.168.1.1,192.168.1.2) to be set up:
Certificate request self-signature ok
subject=C = ES, ST = Palma, L = Yuki, O = Lab, OU = Yuki, CN = *.awx.yuki.es
[INFO] PKCS#12 password is needed.Enter Export Password:
Verifying - Enter Export Password:
Generating DH parameters, 2048 bit long safe prime
...........................................................................................................................................................................................................+.................................+.................................................................+.........................++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*
*.awx.yuki.es.crt: OK
[INFO] New cert & key created for "*.awx.yuki.es" !
```

Una vez tengamos los certificados podemos pasarlos a secret/tls de Kubernetes. ej:

```yaml
type: kubernetes.io/tls
kind: Secret
metadata:
  name: awx-tls-secret-pro
  namespace: awx
apiVersion: v1
data:
  tls.crt: <...>
  tls.key: <...>
```

Mediante el comando:

```shell
cat fichero | base64 -w 0
```

Una vez hecho esto crearemos un recurso de tipo ingressroute para permitir el acceso desde un hostname a un servicio específico:

```
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: awx-ingressroute-pro
  namespace: awx
spec:
  entryPoints:
    - web
    - websecure
  tls:
    secretName: awx-tls-secret-pro
  routes:
  - kind: Rule
    match: Host(`awx.yuki.es`) || Host(`ansible.yuki.es`)
    services:
    - kind: Service
      name: awx-instance-pro-service
      namespace: awx
      passHostHeader: true
      port: 80
```

En esta instalación estas configuraciones se encuentran en: `/root/k3s/manifests/awx/awx-pro-proxy.yaml`
Es posible que llegado el momento haya que renovarlo por 2035. Simplemente 
### Agregar repositorio a Proyectos

En el repositorio de Gitlab, ir a Settings -> Deploy keys -> Privately accessible deploy keys -> Habilitar "ansible" (sha256 ofzESxdf9FSGeaAvh4PDlzIOZ45rE+5kMJh5joOO5rY)

Una vez realizado este paso previo, la instancia de AWX será capaz de sincronizar contenido de los repos en la carpeta: `/var/lib/rancher/k3s/storage/awx-projects`
### Agregar colecciones de Galaxy

Existe una carpeta `./collections` en la que habita un `requirements.yaml` con las dependencias necesarias de roles y colecciones.

# Siguientes pasos AWX

## Cambio de paradigma

+ Debido a la forma en la que funciona ahora AWX el Proyecto "Local" se deberá mover a "Datacenter".
+ Ahora ya no se ejecuta el "Playbook" en el contenedor de tareas. Cada "Playbook" tiene su entorno aislado de ejecución, por lo que los comandos que sean necesarios, deben instalarse en la imagen `awx-ee`.