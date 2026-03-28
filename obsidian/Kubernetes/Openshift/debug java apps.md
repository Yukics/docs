# Instalar herramienta oc (kubectl de Openshift)
1. Hacemos login en: https://console-openshift-console.apps.cluster.net/command-line-tools
2. Descargamos: https://downloads-openshift-console.apps.cluster.net/amd64/windows/oc.zip
3. Abrimos el explorador de Windows
4. Accedemos a `%userprofile%` y creamos la carpeta Apps
5. Extraemos el binario en la carpeta Apps
6. Buscamos en Windows: "Editar las variables de entorno de esta cuenta"
7. Variables de usuario para `<usuario>` -> Path -> Editar -> Nuevo -> `%USERPROFILE%\Apps`
# Configurar JMX en la aplicación SpringBoot
1. Agregamos al *"application.properties"*: `spring.jmx.enabled=true`
2. Agregar al la JVM como variable de entorno JAVA_OPTS: 
```
-Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.port=5000 -Dcom.sun.management.jmxremote.rmi.port=5001 -Djava.rmi.server.hostname=127.0.0.1 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false
``` 
# Crear el port-forward para acceder al puerto JMX configurado
1. Accedemos al *"cluster"*: `oc login -u <usuario> <api server>:6443`
2. Seleccionamos el proyecto: `oc project <namespace>`
3. Creamos el *"port-forward"*: `oc port-forward <pod> <puerto JMX remoto> <puerto JMX local>`
4. Con nuestra herramienta de *"profiling"*, configuramos: `localhost:<puerto JMX local>`
# Bibliografia
+ [Remote Debugging of Java Applications on OpenShift](https://www.redhat.com/en/blog/remote-debugging-java-applications-openshift)