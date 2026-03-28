https://access.redhat.com/solutions/7008559

```
oc delete pod/<ovnkube-control-plane-xxx> -n openshift-ovn-kubernetes

oc get pod -n openshift-ovn-kubernetes | grep control-plane
ovnkube-control-plane-xxxxxxxxxx-xxxxx                        2/2     Running     0          82s
ovnkube-control-plane-xxxxxxxxxx-xxxxx                        2/2     Running     0          2m22s
```