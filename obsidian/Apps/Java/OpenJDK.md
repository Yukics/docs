#init #tech
## JVM
Referencias:
+ https://www.digitalocean.com/community/tutorials/java-jvm-memory-model-memory-management-in-java

## Instalación
Referencias:
+ https://developers.redhat.com/products/openjdk/download
+ https://access.redhat.com/documentation/en-us/openjdk/8/html-single/installing_and_using_openjdk_8_for_rhel/index#installing-jre-on-rhel-using-archive_openjdk

## Estados de un Thread
A thread state. A thread can be in one of the following states:
-   [`NEW`](https://docs.oracle.com/javase/7/docs/api/java/lang/Thread.State.html#NEW)  
    A thread that has not yet started is in this state.
-   [`RUNNABLE`](https://docs.oracle.com/javase/7/docs/api/java/lang/Thread.State.html#RUNNABLE)  
    A thread executing in the Java virtual machine is in this state.
-   [`BLOCKED`](https://docs.oracle.com/javase/7/docs/api/java/lang/Thread.State.html#BLOCKED)  
    A thread that is blocked waiting for a monitor lock is in this state.
-   [`WAITING`](https://docs.oracle.com/javase/7/docs/api/java/lang/Thread.State.html#WAITING)  
    A thread that is waiting indefinitely for another thread to perform a particular action is in this state.
-   [`TIMED_WAITING`](https://docs.oracle.com/javase/7/docs/api/java/lang/Thread.State.html#TIMED_WAITING)  
    A thread that is waiting for another thread to perform an action for up to a specified waiting time is in this state.
-   [`TERMINATED`](https://docs.oracle.com/javase/7/docs/api/java/lang/Thread.State.html#TERMINATED)  
    A thread that has exited is in this state.

## Licencias Java
+ https://redresscompliance.com/oracle-java-licensing-changes-explaned-free/