### Hilos java por pid
```shell
grep Threads /proc/<pid>/status
```

### Get java runtimes
```
find /usr -path "*/bin/java" -type f
find /etc -path "*/bin/java" -type f
```

### Get tomcat version from catalina.jar
```shell
/usr/java/jre7/bin/java -cp catalina.jar org.apache.catalina.util.ServerInfo
```

### cwiki 
Reference: https://cwiki.apache.org/confluence/display/tomcat/HowTo#HowTo-HowdoIobtainathreaddumpofmyrunningwebapp?

### Thread stratus JSP
Reference: http://sunnydays2.blogspot.com/2014/04/how-to-kill-http-tomcat-stuck-thread.html

```java
<%@page language="java"%>  
 <%  
     String threadNameToKill = request.getParameter("threadName");  
     killThread(threadNameToKill, out);  
 %>  
 <%!  
     public void killThread(String threadNameToKill, JspWriter out) throws Exception {  
         ThreadGroup root = Thread.currentThread().getThreadGroup().getParent();  
         while (root.getParent() != null) {  
             root = root.getParent();  
         }  
         visit(root, 0, threadNameToKill,out);  
     }  
  
    public void visit(ThreadGroup group, int level, String threadNameToKill,JspWriter out) throws Exception {  
         int numThreads = group.activeCount();  
         Thread[] threads = new Thread[numThreads * 2];  
         numThreads = group.enumerate(threads, false);  
         for (int i = 0; i < numThreads; i++) { // Get thread  
             Thread thread = threads[i];  
             if (threadNameToKill.equals(thread.getName())) {  
         thread.stop();  
                 out.write("  
Thread " + threadNameToKill + " stopped. It should disappear from threads list in few seconds...");  
                 break;  
             }  
         }  
         int numGroups = group.activeGroupCount();  
         ThreadGroup[] groups = new ThreadGroup[numGroups * 2];  
         numGroups = group.enumerate(groups, false);  
         for (int i = 0; i < numGroups; i++) {  
             visit(groups[i], level + 1, threadNameToKill, out);  
         }  
     }  
 %>
```