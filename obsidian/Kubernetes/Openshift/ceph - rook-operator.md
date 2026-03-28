# Procedimiento

## Acceder a la shell 

```sh
oc rsh -n openshift-storage $(oc get pods -n openshift-storage -o name -l app=rook-ceph-operator)
```

```sh
export CEPH_ARGS='-c /var/lib/rook/openshift-storage/openshift-storage.config'
```

## Listar pools

```sh
ceph osd pool ls
```

## Estado del balanceo 

```sh
ceph balancer status
```
