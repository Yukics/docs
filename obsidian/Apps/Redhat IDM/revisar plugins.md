```
ldapdelete -Y EXTERNAL -H ldapi:///run/slapd-YUKI-ES.socket "cn=users,cn=Schema Compatibility,cn=plugins,cn=config"
ldapdelete -Y EXTERNAL -H ldapi:///run/slapd-YUKI-ES.socket "cn=groups,cn=Schema Compatibility,cn=plugins,cn=config"
```