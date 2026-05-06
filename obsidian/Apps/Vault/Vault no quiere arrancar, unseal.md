---
tags:
  - vault
---
Puede que en log, veamos algo similar a:
```
2026-05-03T18:15:39.531115532+02:00 ==> Vault server configuration:
2026-05-03T18:15:39.531157255+02:00 
2026-05-03T18:15:39.531162835+02:00 Administrative Namespace: 
2026-05-03T18:15:39.531166456+02:00              Api Address: http://10.42.0.130:8200
2026-05-03T18:15:39.531169708+02:00                      Cgo: disabled
2026-05-03T18:15:39.531172868+02:00          Cluster Address: https://vault-0.vault-internal:8201
2026-05-03T18:15:39.531176876+02:00    Environment Variables: HOME, HOSTNAME, HOST_IP, KUBERNETES_PORT, KUBERNETES_PORT_443_TCP, KUBERNETES_PORT_443_TCP_ADDR, KUBERNETES_PORT_443_TCP_PORT, KUBERNETES_PORT_443_TCP_PROTO, KUBERNETES_SERVICE_HOST, KUBERNETES_SERVICE_PORT, KUBERNETES_SERVICE_PORT_HTTPS, NAME, PATH, POD_IP, PWD, SHLVL, SKIP_CHOWN, SKIP_SETCAP, VAULT_ADDR, VAULT_API_ADDR, VAULT_CLUSTER_ADDR, VAULT_K8S_NAMESPACE, VAULT_K8S_POD_NAME, VAULT_PORT, VAULT_PORT_8200_TCP, VAULT_PORT_8200_TCP_ADDR, VAULT_PORT_8200_TCP_PORT, VAULT_PORT_8200_TCP_PROTO, VAULT_PORT_8201_TCP, VAULT_PORT_8201_TCP_ADDR, VAULT_PORT_8201_TCP_PORT, VAULT_PORT_8201_TCP_PROTO, VAULT_SERVICE_HOST, VAULT_SERVICE_PORT, VAULT_SERVICE_PORT_HTTP, VAULT_SERVICE_PORT_HTTPS_INTERNAL
2026-05-03T18:15:39.531180987+02:00               Go Version: go1.25.5
2026-05-03T18:15:39.531185462+02:00               Listener 1: tcp (addr: "[::]:8200", cluster address: "[::]:8201", disable_request_limiter: "false", max_json_array_element_count: "10000", max_json_depth: "300", max_json_object_entry_count: "10000", max_json_string_value_length: "1048576", max_request_duration: "1m30s", max_request_size: "33554432", tls: "disabled")
2026-05-03T18:15:39.531188864+02:00                Log Level: 
2026-05-03T18:15:39.531192052+02:00                    Mlock: supported: true, enabled: false
2026-05-03T18:15:39.531195410+02:00            Recovery Mode: false
2026-05-03T18:15:39.531198582+02:00                  Storage: file
2026-05-03T18:15:39.531201994+02:00                  Version: Vault v1.21.2, built 2026-01-06T08:33:05Z
2026-05-03T18:15:39.531205483+02:00              Version Sha: 781ba452d731fe2d59ccbc1b37ca7c5a18edb998
2026-05-03T18:15:39.531208453+02:00 
2026-05-03T18:15:39.586047080+02:00 ==> Vault server started! Log data will stream in below:
2026-05-03T18:15:39.586071629+02:00 
2026-05-03T18:15:39.586057482+02:00 2026-05-03T16:15:39.529Z [INFO]  proxy environment: http_proxy="" https_proxy="" no_proxy=""
2026-05-03T18:15:39.586086001+02:00 2026-05-03T16:15:39.530Z [INFO]  incrementing seal generation: generation=1
2026-05-03T18:15:39.586089879+02:00 2026-05-03T16:15:39.530Z [INFO]  core: Initializing version history cache for core
2026-05-03T18:15:39.586093352+02:00 2026-05-03T16:15:39.530Z [INFO]  events: Starting event system
2026-05-03T18:15:43.428170432+02:00 ==> Vault shutdown triggered
```

Esto es un problema, porque vault necesita un "unseal" o en castellano "desprecintar" el vault. 
Para ello necesitaremos las claves de "unsealing" que debimos haber guardado cuando arrancamos el vault la primera vez.

Justo cuando esté arrancando el pod, antes de que el healtcheck nos mate el pod ejecutamos:
```bash
kubectl exec -n vault vault-0 -- vault operator unseal <unseal-1> && \
kubectl exec -n vault vault-0 -- vault operator unseal <unseal-2> && \
kubectl exec -n vault vault-0 -- vault operator unseal <unseal-3>
```

Si estás usando helm, es posible que necesites modificar el readinessProbe:
```yaml
values:
  server:
    readinessProbe:
      enabled: true
      # If you need to use a http path instead of the default exec
      # path: /v1/sys/health?standbyok=true
      path: /v1/sys/health?standbyok=true&sealedcode=204&uninitcode=204
      # Port number on which readinessProbe will be checked.
      port: 8200
      # When a probe fails, Kubernetes will try failureThreshold times before giving up
      failureThreshold: 2
      # Number of seconds after the container has started before probe initiates
      initialDelaySeconds: 5
      # How often (in seconds) to perform the probe
      periodSeconds: 5
      # Minimum consecutive successes for the probe to be considered successful after having failed
      successThreshold: 1
      # Number of seconds after which the probe times out.
      timeoutSeconds: 3
```