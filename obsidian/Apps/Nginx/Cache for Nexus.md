https://nginx.org/en/docs/http/ngx_http_proxy_module.html
https://docs.nginx.com/nginx/admin-guide/content-cache/content-caching/#specify-which-requests-to-cache
https://docs.nginx.com/nginx/admin-guide/content-cache/content-caching/
https://www.f5.com/company/blog/nginx/avoiding-top-10-nginx-configuration-mistakes#proxy_buffering-off
https://blog.nginx.org/blog/nginx-caching-guide
https://adrianalonsodev.medium.com/acelera-tu-web-con-nginx-como-cach%C3%A9-de-proxy-inverso-fd25722a0dc2

# Agregar disco

```
pvcreate /dev/sdf
vgcreate VolGroup04 /dev/sdf
lvcreate -l 100%FREE -n cache VolGroup04
mkfs.xfs /dev/VolGroup04/cache
cp /etc/fstab /etc/fstab.bak
mkdir /opt/nexus/nginx-cache
chown nginx:nginx /opt/nexus/nginx-cache
echo "/dev/VolGroup04/cache /opt/nexus/nginx-cache                xfs     defaults        0 0" >> /etc/fstab
systemctl daemon-reload
mount -a
```
# Configurar nginx

```
cp -ra /etc/nginx/nginx.conf /etc/nginx/nginx.conf.$(date +%Y%m%d)
```

```
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {

    #recommended log format
    log_format nginx '\$remote_addr - \$remote_user [\$time_local] '
                  '"\$request" \$status \$body_bytes_sent \$request_time '
                  '"\$http_referer" "\$http_user_agent"';

    access_log /var/log/nginx/access.log;
    proxy_send_timeout 120;
    proxy_read_timeout 300;
    proxy_buffering    on;
    proxy_request_buffering on;
    keepalive_timeout  5 5;
    tcp_nodelay        on;

    proxy_cache_path /opt/nexus/nginx-cache/ levels=1:2 keys_zone=nexus_cache:100m max_size=50g inactive=1024h use_temp_path=off;
    proxy_cache_key "$request_method$request_uri";
    proxy_cache_methods GET;
    proxy_cache_valid 200 302 360h;

    include /etc/nginx/conf.d/*.conf;

    server {
        listen 80 default_server;
        server_name _;

        return 301 https://$host$request_uri;
    }

    server {
        listen   *:443;
        server_name  nexus-des.example.net default_server;

        # allow large uploads of files
        client_max_body_size 1G;

        # optimize downloading files larger than 1G
        #proxy_max_temp_file_size 2G;

        ssl on;
        ssl_certificate      /etc/nginx/ssl/cert.crt;
        ssl_certificate_key  /etc/nginx/ssl/cert.key;

        location /repository/npm-group/-/npm/v1/security/ {
            proxy_pass https://registry.npmjs.org/-/npm/v1/security/;
        }

        # Regular Nexus requests
        location / {

            proxy_cache nexus_cache;
            expires -1;

            proxy_cache_min_uses 1;
            proxy_cache_use_stale error timeout http_500 http_502 http_503 http_504;
            proxy_cache_background_update on;
            proxy_cache_lock on;

            proxy_ignore_headers Expires;
            proxy_ignore_headers X-Accel-Expires;
            proxy_ignore_headers Cache-Control;
            proxy_ignore_headers Set-Cookie;

            proxy_hide_header X-Accel-Expires;
            proxy_hide_header Expires;
            proxy_hide_header Cache-Control;
            proxy_hide_header Pragma;

            add_header X-Cache $upstream_cache_status;
            add_header X-Cache-Status $upstream_status;

            proxy_set_header Host $host:$server_port;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto "https";
            proxy_pass http://127.0.0.1:8081;
        }
    }
}
```