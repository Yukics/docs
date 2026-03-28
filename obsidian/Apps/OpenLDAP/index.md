#init #tech 

## Referencias
https://ubuntu.com/server/docs/service-ldap-backup-restore

## Comando útiles

**Exportar conf**
```
slapcat -b cn=config > config.ldif
```

**Importar conf** 
```
# Cualquier ldif
slapadd -b cn=config -l config.ldif -q

# Una nueva base de datos
mkdir /data/location
slapadd -l backup.ldif -F /data/location -c -v -d 1 # verbose output
```

## Config
/etc/openldap/slapd.conf
```
include /backups/openldap.pro/schema/corba.schema
include /backups/openldap.pro/schema/core.schema
include /backups/openldap.pro/schema/cosine.schema
include /backups/openldap.pro/schema/duaconf.schema
include /backups/openldap.pro/schema/dyngroup.schema
include /backups/openldap.pro/schema/inetorgperson.schema
include /backups/openldap.pro/schema/java.schema
include /backups/openldap.pro/schema/misc.schema
include /backups/openldap.pro/schema/nis.schema
include /backups/openldap.pro/schema/openldap.schema
include /backups/openldap.pro/schema/pmi.schema
include /backups/openldap.pro/schema/ppolicy.schema
include /backups/openldap.pro/schema/collective.schema


database config
rootdn "cn=config"
rootPw secret

pidfile ./run/slapd.pid
argsfile ./run/slapd.args

# Enable TLS if port is defined for ldaps

# TLSVerifyClient never
# TLSCipherSuite HIGH:MEDIUM:-SSLv2
# TLSCertificateFile ./secure/certs/server.pem
# TLSCertificateKeyFile ./secure/certs/server.pem
# TLSCACertificateFile ./secure/certs/server.pem

#######################################################################
# bdb database definitions
#######################################################################

database bdb
suffix "dc=example,dc=com"
rootdn "cn=Directory Manager,dc=example,dc=com"
# Cleartext passwords, especially for the rootdn, should
# be avoid. See slappasswd(8) and slapd.conf(5) for details.
# Use of strong authentication encouraged.
rootpw test

# The database directory MUST exist prior to running slapd AND
# should only be accessible by the slapd and slap tools.
# Mode 700 recommended.
directory /bitnami/openldap/slapd.d
# dirtyread
# searchstack 20
# Indices to maintain
# index mail pres,eq
# index objectclass pres
# index default eq,sub
# index sn eq,sub,subinitial
# index telephonenumber
# index cn
```


`/etc/openldap/slapd.ldif`
```
dn: cn=config
objectClass: olcGlobal
cn: config
olcConfigFile: /etc/openldap/slapd.conf
olcConfigDir: /etc/openldap/slapd.d
olcAllows: bind_v2
olcArgsFile: /var/run/openldap/slapd.args
olcAttributeOptions: lang-
olcAuthzPolicy: none
olcConcurrency: 0
olcConnMaxPending: 100
olcConnMaxPendingAuth: 1000
olcGentleHUP: FALSE
olcIndexSubstrIfMaxLen: 4
olcIndexSubstrIfMinLen: 2
olcIndexSubstrAnyLen: 4
olcIndexSubstrAnyStep: 2
olcIndexIntLen: 4
olcLocalSSF: 71
olcPidFile: /var/run/openldap/slapd.pid
olcReadOnly: FALSE
olcReverseLookup: FALSE
olcSaslSecProps: noplain,noanonymous
olcSockbufMaxIncoming: 262143
olcSockbufMaxIncomingAuth: 16777215
olcThreads: 16
olcTLSVerifyClient: never
olcToolThreads: 1
olcWriteTimeout: 0
structuralObjectClass: olcGlobal
entryUUID: bad2f150-a555-1030-8560-b11b5975f51b
creatorsName: cn=config
createTimestamp: 20111117105038Z
olcLogLevel: 256
olcServerID: 1 ldap://test1.example.net:389
olcServerID: 2 ldap://test3.example.net:389
olcIdleTimeout: 240
entryCSN: 20161212091105.462477Z#000000#001#000000
modifiersName: cn=Directory Manager,dc=example,dc=com
modifyTimestamp: 20161212091105Z
contextCSN: 20161212091105.462477Z#000000#001#000000
contextCSN: 20130206174016.344374Z#000000#000#000000
contextCSN: 20161020084126.344602Z#000000#002#000000
```

Log Levels
https://www.openldap.org/doc/admin24/slapdconfig.html

Troubleshooting
https://docs.apigee.com/api-platform/troubleshoot/ldap/troubleshooting-openldap-problems#unabletostartopenldap-possiblecauses

st rnet
```
ldapsearch -x -b "dc=example,dc=com" -H ldap://192.168.*.* -u test05 -w test05
```