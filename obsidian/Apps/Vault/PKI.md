---
tags:
  - vault
---
# Nuevo secret engine PKI
Desde aquí puedes o bien generar una nueva rootCA o usar la que ya tenías pegandola/subiendola (rootCA.crt+rootCA.key) como un `.pem`.
En este caso llamaremos a nuestro secret engine "pki"

## Generando la CA

```bash
vault write pki/root/generate/internal common_name="rootCA" ttl=87600h # 10 años
```

# Configuramos las URL relacionadas

```bash
vault write pki/config/urls \ 
	issuing_certificates="https://vault.yuki.es/v1/pki/ca" \ 
	crl_distribution_points="https://vault.yuki.es/v1/pki/crl" \
	ocsp_servers="https://vault.yuki.es/v1/pki/ocsp"

# output
Key                           Value                               
crl_distribution_points       ["https://vault.yuki.es/v1/pki/crl"]
delta_crl_distribution_points []                                  
enable_templating             false                               
issuing_certificates          ["https://vault.yuki.es/v1/pki/ca"] 
ocsp_servers                  []
```

También hay que configurar los path y los response headers:
```bash
vault write pki/config/cluster path=https://vault.yuki.es/v1/pki aia_path=https://vault.yuki.es/v1/pki

# output
Key      Value                       
aia_path https://vault.yuki.es/v1/pki
path     https://vault.yuki.es/v1/pki

# este comando no funciona por la UI, hay que ejecutarlo con la CLI
export VAULT_TOKEN=<UI -> User -> copy token>
vault secrets tune -allowed-response-headers=Last-Modified -allowed-response-headers=Location -allowed-response-headers=Replay-Nonce -allowed-response-headers=Link pki/

# output
Success! Tuned the secrets engine at: pki/
```
# Habilitamos ACME

```bash
# vault tiene que saber cual es su URL publica
vault write sys/config/cluster api_addr="https://vault.yuki.es"
# para comprobar que la configuración es correcta
vault read sys/config/state/sanitized

vault write pki/config/acme enabled=true

# output
Key                      Value        
allow_role_ext_key_usage false        
allowed_issuers          ["*"]        
allowed_roles            ["*"]        
default_directory_policy sign-verbatim
dns_resolver                          
eab_policy               not-required 
enabled                  true         
max_ttl                  7776000
```

# Creamos el role para los certificados

```bash
vault write pki/roles/traefik \ 
	allowed_domains="yuki.es,*.yuki.es" \ 
	allow_subdomains=true \ 
	allow_wildcard_certificates=true \
	issuer_ref="rootCA" \
	max_ttl=2160h \ 
	key_type=rsa \ 
	key_bits=4096
	
# output
Key                                Value                                                
allow_any_name                     false                                                
allow_bare_domains                 false                                                
allow_glob_domains                 false                                                
allow_ip_sans                      true                                                 
allow_localhost                    true                                                 
allow_subdomains                   true                                                 
allow_token_displayname            false                                                
allow_wildcard_certificates        true                                                 
allowed_domains                    ["yuki.es","*.yuki.es"]                              
allowed_domains_template           false                                                
allowed_other_sans                 []                                                   
allowed_serial_numbers             []                                                   
allowed_uri_sans                   []                                                   
allowed_uri_sans_template          false                                                
allowed_user_ids                   []                                                   
basic_constraints_valid_for_non_ca false                                                
client_flag                        true                                                 
cn_validations                     ["email","hostname"]                                 
code_signing_flag                  false                                                
country                            []                                                   
email_protection_flag              false                                                
enforce_hostnames                  true                                                 
ext_key_usage                      []                                                   
ext_key_usage_oids                 []                                                   
generate_lease                     false                                                
issuer_ref                         rootCA                                               
key_bits                           4096                                                 
key_type                           rsa                                                  
key_usage                          ["DigitalSignature","KeyAgreement","KeyEncipherment"]
locality                           []                                                   
max_ttl                            7776000                                              
no_store                           false                                                
not_after                                                                               
not_before_duration                30                                                   
organization                       []                                                   
ou                                 []                                                   
policy_identifiers                 []                                                   
postal_code                        []                                                   
province                           []                                                   
require_cn                         true                                                 
serial_number_source               json-csr                                             
server_flag                        true                                                 
signature_bits                     256                                                  
street_address                     []                                                   
ttl                                0                                                    
use_csr_common_name                true                                                 
use_csr_sans                       true                                                 
use_pss                            false	
```