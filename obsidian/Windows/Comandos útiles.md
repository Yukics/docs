### Instalar en windows ansible
```bash
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org ansible -vvv
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org  pip-system-certs
```

```shell
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org --no-cache-dir ansible --cert /etc/pki/ca-trust/source/anchors/<proxy>.crt
```
### Instalar wsl
https://learn.microsoft.com/en-us/windows/wsl/install-manual
### Eliminar perfil de usuario 
Windows+ r -> `systempropertiesadvanced`

```
git -c http.sslVerify=false clone https://github.com/vmware/vsphere-automation-sdk-python.git
```

### Comprobar usuarios logeados en Windows
```shell
qwinsta /server:$env:conmputername
```