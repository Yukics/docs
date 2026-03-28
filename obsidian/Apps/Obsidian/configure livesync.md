```yaml
networks:
  net_traefik:
    external: true
services:
  couchdb:
    image: couchdb:latest
    environment:
      COUCHDB_USER: "admin"
      COUCHDB_PASSWORD: "*********"
    networks:
      - net_traefik
    volumes:
      - ./data:/opt/couchdb/data
      - ./etc:/opt/couchdb/etc/local.d
```

```bash
dc up -d 

export hostname=https://couchdb.confucio.yuki.es:8443
export username=admin
export password=*********

if [[ -z "$hostname" ]]; then
    echo "ERROR: Hostname missing"
    exit 1
fi
if [[ -z "$username" ]]; then
    echo "ERROR: Username missing"
    exit 1
fi

if [[ -z "$password" ]]; then
    echo "ERROR: Password missing"
    exit 1
fi

echo "-- Configuring CouchDB by REST APIs... -->"

until (curl -X POST "${hostname}/_cluster_setup" -H "Content-Type: application/json" -d "{\"action\":\"enable_single_node\",\"username\":\"${username}\",\"password\":\"${password}\",\"bind_address\":\"0.0.0.0\",\"port\":5984,\"singlenode\":true}" --user "${username}:${password}"); do sleep 5; done
until (curl -X PUT "${hostname}/_node/nonode@nohost/_config/chttpd/require_valid_user" -H "Content-Type: application/json" -d '"true"' --user "${username}:${password}"); do sleep 5; done
until (curl -X PUT "${hostname}/_node/nonode@nohost/_config/chttpd_auth/require_valid_user" -H "Content-Type: application/json" -d '"true"' --user "${username}:${password}"); do sleep 5; done
until (curl -X PUT "${hostname}/_node/nonode@nohost/_config/httpd/WWW-Authenticate" -H "Content-Type: application/json" -d '"Basic realm=\"couchdb\""' --user "${username}:${password}"); do sleep 5; done
until (curl -X PUT "${hostname}/_node/nonode@nohost/_config/httpd/enable_cors" -H "Content-Type: application/json" -d '"true"' --user "${username}:${password}"); do sleep 5; done
until (curl -X PUT "${hostname}/_node/nonode@nohost/_config/chttpd/enable_cors" -H "Content-Type: application/json" -d '"true"' --user "${username}:${password}"); do sleep 5; done
until (curl -X PUT "${hostname}/_node/nonode@nohost/_config/chttpd/max_http_request_size" -H "Content-Type: application/json" -d '"4294967296"' --user "${username}:${password}"); do sleep 5; done
until (curl -X PUT "${hostname}/_node/nonode@nohost/_config/couchdb/max_document_size" -H "Content-Type: application/json" -d '"50000000"' --user "${username}:${password}"); do sleep 5; done
until (curl -X PUT "${hostname}/_node/nonode@nohost/_config/cors/credentials" -H "Content-Type: application/json" -d '"true"' --user "${username}:${password}"); do sleep 5; done
until (curl -X PUT "${hostname}/_node/nonode@nohost/_config/cors/origins" -H "Content-Type: application/json" -d '"app://obsidian.md,capacitor://localhost,http://localhost"' --user "${username}:${password}"); do sleep 5; done

echo "<-- Configuring CouchDB by REST APIs Done!"
```

Service
```toml
[Unit]
Description=Docker couchdb
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/bash -c "docker compose -f /docker/obsidian-db/docker-compose.yaml up --detach"
ExecStop=/bin/bash -c "docker compose -f /docker/obsidian-db/docker-compose.yaml stop"

[Install]
WantedBy=multi-user.target
```