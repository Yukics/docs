https://console-openshift-console.apps.okd.yuki.es/k8s/cluster/config.openshift.io~v1~OperatorHub/cluster/yaml
### Catalog source

A _catalog source_ represents a store of metadata, typically by referencing an _index image_ stored in a container registry. Operator Lifecycle Manager (OLM) queries catalog sources to discover and install Operators and their dependencies. OperatorHub in the OKD web console also displays the Operators provided by catalog sources.

Cluster administrators can view the full list of Operators provided by an enabled catalog source on a cluster by using the **Administration** → **Cluster Settings** → **Configuration** → **OperatorHub** page in the web console.

The `spec` of a `CatalogSource` object indicates how to construct a pod or how to communicate with a service that serves the Operator Registry gRPC API.