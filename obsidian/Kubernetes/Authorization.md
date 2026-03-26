---
title: Authorization
---
# Node
![Pasted image 20260117181839](https://i.gyazo.com/14b73e5e1c54bd926771eb0337e32795.png)
# RBAC
1. Create a role
2. Asssociate devs to roles
3. Bind roles to verbs
specific namespaces on metadata
![Pasted image 20260117182433](https://i.gyazo.com/406e075f9d3bac31a31f59d676cbc9a8.png)
Specific resources 
![Pasted image 20260117182635](https://i.gyazo.com/e825b4efb2b424a6520a7d7fdfd253d2.png)
# ABAC
Policy files -> JSON
Every change implies restarting kubeapi-server -> Difficult to manage
# Webhook
Example OpenPolicyAgent
External granted access

# Authorization-mode: AlwaysAllow & AlwaysDeny

# Multiple modes
![Pasted image 20260117182208](https://i.gyazo.com/95a2c5b4076ecc8faeeec98ced072319.png)

# Test
![Pasted image 20260117182604](https://i.gyazo.com/96a48e9bcf7054db7e50d8bd317bf664.png)

