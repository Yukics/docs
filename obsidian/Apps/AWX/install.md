# Install AWX

## Set up operator

```bash
git clone https://github.com/ansible/awx-operator.git
cd awx-operator
git tag
git checkout tags/2.19.1

export VERSION=2.19.1
make deploy
kubectl apply -k .
```

![image.png](https://s3.yukics.net/obsidian/2025/05/24/image.png)

