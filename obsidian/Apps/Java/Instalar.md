1. Descargar desde https://developers.redhat.com/products/openjdk/download, el paquete OpenJDK, previa comprobación de la última versión soportada por el SO. 
	1. RHEL6 soporta `1.8._275` como máximo. Por lo que muy probablemente se deba actualizar.
2. Movernos a la carpeta (de no existir, crear la carpeta):
```
cd /usr/java
```
3. Copiar en esta ruta el fichero descargado y extraerlo, ej: 
```
tar -xf java-1.8.0-openjdk-portable-1.8.0.322.b06-4.portable.jre.el7.x86_64.tar.xz
```
4. Renombrar la carpeta:
```
mv java-1.8.0-openjdk-portable-1.8.0.322.b06-4.portable.jre.el7.x86_64 jre1.8.0_342
```
5. Deshacer enlace simbolico anterior de existir: 
```
unlink jre8
```
7.  En caso de querer actualizar las instancias relacionadas hacer un, `ln -s` de la carpeta `jre1.8.0_342`  hacia `jre8`. <span style="color: red;">¡Depende de cada sistema, chequeadlo antes!</span>:
```
ln -s jre1.8.0_342 jre8
```
7. Comprobar que el binario de java funcione:
```
/usr/java/jre8/bin/java -version
```
9. Comprobar que los procesos dependientes del runtime que acabamos de modificar funcionen correctamente: tomcats, elastics, crontabs...

### Referencia
+ [Installing and using OpenJDK 8 for RHEL OpenJDK 8 | Red Hat Customer Portal](https://access.redhat.com/documentation/en-us/openjdk/8/html-single/installing_and_using_openjdk_8_for_rhel/index#installing-jre-on-rhel-using-archive_openjdk)
