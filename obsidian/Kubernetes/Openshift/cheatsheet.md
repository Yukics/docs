# Operativa del cluster

Debugear estado de un nodo (abrir una shel en él)
```shell
oc debug node <hostname>
chroot /host
```

SOS report versión openshift
```shell
oc adm must-gather --dest-dir /home/yuki/oc-debug
```

Consumo de milicores y Ram por pod
```shell
oc adm top pods -A --sum
```

Consumo por nodo
```shell
oc adm top node
```

Saber lo que un nodo puede proporcionar en cuanto a recursos
```shell
oc get node <hostname> -o jsonpath='Allocatable: {.status.allocatable.cpu}{"\n"}''Capacity: {.status.capacity.cpu}{"\n"}'
```

Listar nodos e IP:
```bash
oc get node -o custom-columns=node:metadata.name,IP:status.addresses[0].address
```

# Operativa Proyecto

Export all
```shell
oc get all,cm,secret,ing -o yaml > dev-old.yaml
```

Otra forma de exportarlo todo de un proyecto
```shell
oc api-resources | grep true | awk '{print $1}' |xargs -I % oc get % -o yaml > %-dsi-e-invoicing-dev.yaml
```

Describir un recurso o alguno de sus atributos
```shell
oc explain pod
oc explain pod.spec.securityContext
```

Mostrar recursos de un tipo de api
```shell
oc api-resources --api-group operator.openshift.io/v1
```

Lanzar comando en pod
```shell
oc exec pod <nombre_pod> -- sh
oc debug pod <nombre_pod>
```

Eliminar un proyecto entero
```shell
oc delete all --all -n erjcan-stage
```

Sacar los uid:
```bash
oc get pod -o jsonpath='{range .items[*]}{@.metadata.name}{" runAsUser: "}{@.spec.containers[*].securityContext.runAsUser}{" fsGroup: "}{@.spec.securityContext.fsGroup}{" seLinuxOptions: "}{@.spec.securityContext.seLinuxOptions.level}{"\n"}{end}'
```
# Imágenes

Importar una imagen de un namespace a otro
```bash
oc import-image imagestremadestino:latest dsi-namespaceorigen-dev/nombre-ims:latest -n namespacedestino
```

Listar tags asociados con la imagen
```bash
skopeo list-tags docker://<ruta del resgitry con la img>
```

Copiar de un registry a otro:
```bash
skopeo copy \  
    docker://default-route-openshift-image-registry.apps.<cluster>/NS-viejo/imagen:latest \  
    docker://default-route-openshift-image-registry.apps.<cluster>/NS-nuevo/imagen \  
    --src-creds $USER:$SRC_CREDS \  
    --dest-creds $USER:$DST_CREDS \  
    --dest-tls-verify=false \  
    --src-tls-verify=false
```

# Listas
```bash
for node in $(oc adm top node -l <key>!=<value>  | grep wor | awk '{print $1}'); do 
    oc get pods -A -o wide | grep Running | grep $node
done | awk '{print $2}' | sed -r 's/^(.*)-(.*)$/\1/' | sort -u


for node in $(oc adm top node -l <key>=<value>  | grep wor | awk '{print $1}'); do 
    oc get pods -A -o wide | grep Running | grep $node
done | awk '{print $2}' | sed -r 's/^(.*)-(.*)$/\1/' | sort -u

for node in $(oc adm top node -l type=bke | grep wor | awk '{print $1}'); do 
    oc get pods -A -o wide | grep Running | grep $node
done | awk '{print $2}' | sed -r 's/^(.*)-(.*)$/\1/' | sort -u


oc get pods -A -o custom-columns=node:spec.nodeName,Nombre:metadata.name,ram:spec.containers[0].resources.limits.memory,datadog:metadata.labels."admission\.datadoghq\.com/enabled" |grep wor
```