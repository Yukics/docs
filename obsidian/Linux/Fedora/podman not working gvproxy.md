Si no puedes arrancar la "machine" de podman.
Para solucionarlo hay que instalar:
```bash
sudo dnf install -y podman-gvproxy
```

Puede que tambien aparezca un problema con virtiofsd:
```bash
04:06:58 yuki@yukiv2 cl0k → sudo find / -name "virtiofsd"
find: ‘/proc/12357/task/12357/net’: Invalid argument
find: ‘/proc/12357/net’: Invalid argument
find: ‘/proc/18253/task/18253/net’: Invalid argument
find: ‘/proc/18253/net’: Invalid argument
find: ‘/run/user/1000/doc’: Permission denied
find: ‘/run/user/1000/gvfs’: Permission denied
/usr/libexec/virtiofsd
/usr/share/doc/virtiofsd
/usr/share/licenses/virtiofsd
/var/lib/snapd/snap/core24/1349/etc/apparmor.d/virtiofsd

04:07:17 yuki@yukiv2 cl0k → PATH=$PATH:/usr/libexec podman machine start
Starting machine "podman-machine-default"

This machine is currently configured in rootless mode. If your containers
require root permissions (e.g. ports < 1024), or if you run into compatibility
issues with non-podman clients, you can switch using the following command:

	podman machine set --rootful

Mounting volume... /home/yuki:/home/yuki
API forwarding listening on: /run/user/1000/podman/podman-machine-default-api.sock
You can connect Docker API clients by setting DOCKER_HOST using the
following command in your terminal session:

        export DOCKER_HOST='unix:///run/user/1000/podman/podman-machine-default-api.sock'

Machine "podman-machine-default" started successfully
```