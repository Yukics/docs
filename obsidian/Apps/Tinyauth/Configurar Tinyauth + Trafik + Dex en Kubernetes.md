---
tags:
  - traefik
  - dex
  - tinyauth
  - kubernetes
date: 2026-06-05
---
# Introducción

Lo que vamos a implementar a continuación es una pieza que se va a encargar de implementar autenticación en cualquier servicio que necesitemos proteger.

+ Dex: https://dex.yuki.es -> OIDC
+ Tinyauth: https://auth.yuki.es -> Autenticación
+ Traefik -> Proxy
+ Traefik Dashboard: https://traefik.yuki.es -> Aplicación a proteger
# Creamos el cliente en Dex

Referencia: https://dexidp.io/docs/connectors/local/

Obviamente debemos tener un Dex minimamente configurado:

```yaml
issuer: https://dex.yuki.es
storage:
  type: memory
enablePasswordDB: true
oauth2:
  passwordConnector: local
  skipApprovalScreen: true # skip grant access page
staticClients:
  - id: tinyauth
    secret: "secret-random"
    name: 'TinyAuth'
    redirectURIs:
      - 'https://auth.yuki.es/api/oauth/callback/dex'
    scopes:
      - openid
      - profile
      - email
      - groups
```

# Desplegamos Tinyauth

Previa creación del namespace "tinyauth", desplegamos:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tinyauth
  namespace: tinyauth
spec:
  replicas: 1
  revisionHistoryLimit: 2
  selector:
    matchLabels:
      app: tinyauth
  template:
    metadata:
      labels:
        app: tinyauth
    spec:
      containers:
        - name: tinyauth
          resources: {}
          image: ghcr.io/steveiliop56/tinyauth:v5.0.7
          args:
            - '--appurl=https://auth.yuki.es'
            - '--server.port=3000'
            - '--log.level=info'
            # CONFIGURACIÓN OAUTH (Para conectar con Dex)
            - '--oauth.providers.dex.name=Dex'
            - '--oauth.providers.dex.clientid=tinyauth'
            - '--oauth.providers.dex.clientsecret=secret-random' # lo que hemos configurado antes en Dex
            - '--oauth.providers.dex.redirecturl=https://auth.yuki.es/api/oauth/callback/dex'
            # URLs específicas de Dex
            - '--oauth.providers.dex.authurl=https://dex.yuki.es/auth'
            - '--oauth.providers.dex.tokenurl=https://dex.yuki.es/token'
            - '--oauth.providers.dex.userinfourl=https://dex.yuki.es/userinfo'
            - '--oauth.providers.dex.scopes=openid,profile,email,groups'
            - '--oauth.providers.dex.insecure=true'
            # ACLS
            - '--apps.default.config.domain=*.yuki.es' # dominios que vamos a permitir por defecto
            - '--apps.default.users.allow=*' # usuarios que vamos a permitir por defecto
            - '--apps.default.path.allow=*' # paths que vamos a permitir por defecto
            - '--ui.title=TinyAuth' # Nombre de la UI
            - '--auth.securecookie=true' # forzamos el uso de https
          ports:
            - containerPort: 3000
              name: http
              protocol: TCP
          livenessProbe:
            httpGet:
              path: /api/healthz
              port: 3000
          readinessProbe:
            httpGet:
              path: /api/healthz
              port: 3000
---
# creamos un serivcio para exponer nuestro pod
apiVersion: v1
kind: Service
metadata:
  name: tinyauth-service
  namespace: tinyauth
spec:
  selector:
    app: tinyauth
  ports:
    - protocol: TCP
      port: 3000
      targetPort: http
  type: LoadBalancer
---
# exponemos auth.yuki.es
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: ingressroutes
  namespace: tinyauth
spec:
  entryPoints:
    - websecure
  tls:
    certResolver: vault # solo si usais un ACME interno
    domains:
      - main: auth.yuki.es
  routes:
  - kind: Rule
    match: Host(`auth.yuki.es`)
    services:
    - kind: Service
      name: tinyauth-service
      namespace: tinyauth
      passHostHeader: true
      port: 3000
    observability:
      accessLogs: true
      traceVerbosity: minimal
```

# Securizar Traefik Dashboard

Creamos el middleware en traefik:

```yaml
apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: auth
  namespace: traefik
spec:
  forwardAuth:
    address: https://auth.yuki.es/api/auth/traefik?rd=https://auth.yuki.es/login&auth=true
    trustForwardHeader: true # Necesario para que pasen las cabeceras X-Forwarded-*
    authResponseHeaders:
      - "X-Forwarded-Uri"
      - "X-Forwarded-User"
      - "X-Forwarded-Proto"
      - "X-Forwarded-Host"
      - "Authorization"
      - "Set-Cookie"
```

Configuramos Traefik para permitir enviar headers al sistema de autenticación. También es posible configurar las IP de origen. Aunque en este caso para no complicarnos la vida lo podemos simplemente agregar a la configuración:

```yaml
dashboard:
  enabled: true
ports:
  web:
    forwardedHeaders:
      insecure: true
  websecure:
    forwardedHeaders:
      insecure: true
```

Creamos un IngressRoute (aunque podemos usar Ingress o HTTPRoutes) y agregamos el plugin que acabamos de crear:

```yaml
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: traefik-ingressroute-dashboard
  namespace: traefik
spec:
  entryPoints:
    - websecure
  tls:
    certResolver: vault # solo si usais un ACME interno
    domains:
      - main: traefik.yuki.es
  routes:
  - kind: Rule
    match: Host(`traefik.yuki.es`)
    middlewares:
    - name: auth
      namespace: traefik
    services:
    - kind: TraefikService
      name: api@internal
      passHostHeader: true
      strategy: RoundRobin
      sticky:
        cookie:
          httpOnly: true
          name: cookie
          secure: true
          sameSite: none
```

# Referenciar middlewares de otros namespaces

Para conseguir esto y poder aplicar el mismo middleware en varios IngressRoutes debemos configurar Traefik para permitir "crossnamespace":

```yaml
providers:
  kubernetesCRD:
    allowCrossNamespace: true
```

# Posibles problemas con crossorigins

Cuando estaba haciendo pruebas con el dashboard de Traefik vi que habia ciertas llamadas que finalizaban en 404 a manifest.json resulta que cuando un `<link>` no tiene definido `crossorigin="use-credentials"` falla, porque realmente se está proxeando a través de Tinyauth con un dominio diferente.

Para solucionarlo hemos tenido que crear un middleware con el plugin `rewritebody` oficial de Traefik.

En la conf de Traefik habilitamos el plugin:

```yaml
experimental:
  abortOnPluginFailure: false
  plugins:
    rewritebody:
      moduleName: "github.com/traefik/plugin-rewritebody"
      version: "v0.3.1"
```

Y en el middleware vamos agregando las reescrituras que necesitamos:

```yaml
apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: fix-manifest-credentials
spec:
  plugin:
    rewritebody:
      rewrites:
        - regex: 'rel=\"manifest\"'
          replacement: 'rel="manifest" crossorigin="use-credentials"'
      lastModified: true
```
# Elementos relacionados
+ [[Apps/Traefik/index|Traefik]]
+ [[Apps/Dex/index|Dex]]