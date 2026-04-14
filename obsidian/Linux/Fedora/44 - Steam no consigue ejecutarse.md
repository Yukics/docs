Al ejecutar steam desde la terminal vemos:

```bash
src/common/opensslconnection.cpp (1636) : unable to load trusted SSL root certificates
```

Se soluciona con:

```bash
sudo update-ca-trust extract --rhbz2387674
```

Referencias: https://bugzilla.redhat.com/show_bug.cgi?id=2387674