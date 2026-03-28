# CouchDB
## Backup and restore
https://medium.com/@glynn_bird/how-i-do-couchdb-backups-e71360a5afa1


File: `docker-compose.yaml`
```yaml
networks:
  net_traefik:
    external: true
services:
  couchdb:
    image: couchdb:latest
    environment:
      COUCHDB_USER: "**********"
      COUCHDB_PASSWORD: "************"
    ports:
      - 5984:5984
    networks:
      - net_traefik
    volumes:
      - ./data:/opt/couchdb/data
```


```bash
docker compose up -d

#CLI
docker compose exec bash
curl -X PUT http://127.0.0.1:5984/_users
curl -X PUT http://127.0.0.1:5984/_replicator
curl -X PUT http://127.0.0.1:5984/_global_changes
```

## UI
Acceder a: http://confucio.yuki.es:5984/_utils/#login
![Pasted image 20250223003434](https://i.gyazo.com/fa0b1abca30d4f647b7fbb3517eca3fa.png)

Creamos la DB de users y de obsidian
![Pasted image 20250223003535](https://i.gyazo.com/0e1a03b07a032a57402d1a2f62582126.png)

Definiremos los permisos oportunos:
![Pasted image 20250223003644](https://i.gyazo.com/c4c3bfb7f0be2ae7d98202d1ec14bbd0.png)


