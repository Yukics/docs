---
tags:
  - vault
---
Referencia: https://developer.hashicorp.com/vault/docs/auth/jwt
# Habilitamos OIDC

```bash
vault auth enable oidc 2>/dev/null || echo "OIDC already enabled, continuing..."
```

# Configuramos conexión OIDC

```bash
vault write auth/oidc/config \
	oidc_discovery_url="https://dex.yuki.es" \
	oidc_client_id="vault" \
	oidc_client_secret="********" \
	oidc_scopes="email,profile,groups" \
	default_role="default-user" \
	oidc_discovery_ca_pem=@/usr/local/share/ca-certificates/extra/ca/ca.crt # importante si usamos un certificado autofirmado
```
# Creación de policy

De esta forma estamos creando un policy con todos los permisos sobre todos los rescursos:
```bash
vault policy write admin - <<EOF
path "*" {
	capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOF
```

# Creación de roles

En este caso estamos creando el "default-user" que hemos definido como role por defecto, y dandole permisos sobre todo. Obviamente en un entorno productivo esto no es una buena practica:
```bash
vault write auth/oidc/role/default-user -<<EOF
{
  "bound_audiences": "vault",
  "user_claim": "sub",
  "role_type": "oidc",
  "allowed_redirect_uris": [ "https://vault.yuki.es/ui/vault/auth/oidc/oidc/callback","http://localhost:8250/oidc/callback"],
  "oidc_scopes": ["openid", "profile", "email"],
  "bound_claims": { "email": ["admin@yuki.es"] },
  "policies": ["admin"],
  "ttl": "1h"
}
EOF
```

## Creación de role bindeando por grupo

Creamos un grupo de Vault mapeado a la política "admin" de antes:
```bash
vault write identity/group \
	name="admin-group" \
	type="external" \
	policies="admin"
```

Si quieres mapear grupos de Dex a grupos de Vault, puedes usar el siguiente bloque de código:
```bash
vault write auth/oidc/role/default-user -<<EOF
{
  "bound_audiences": "vault",
  "user_claim": "sub",
  "role_type": "oidc",
  "allowed_redirect_uris": [ "https://vault.yuki.es/ui/vault/auth/oidc/oidc/callback","http://localhost:8250/oidc/callback"],
  "oidc_scopes": ["openid", "profile", "email", "groups"],
  "bound_claims": { "groups": ["identity/group/name/admin-group"] },
  "policies": ["admin"],
  "ttl": "1h"
}
EOF
```

Por último mapeamos el grupo de Vault con el grupo del OIDC:
```bash
OIDC_ACCESSOR=$(vault auth list -format=json | jq -r '.["oidc/"].accessor')
GROUP_ID=$(vault read -field=id identity/group/name/admin-group)
vault write identity/group-alias \
	name="admin" \
	mount_accessor=$OIDC_ACCESSOR \
	canonical_id=$GROUP_ID
```