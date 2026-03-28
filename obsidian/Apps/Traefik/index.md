# Full config file
```yaml
## CODE GENERATED AUTOMATICALLY
## THIS FILE MUST NOT BE EDITED BY HAND
http:
  routers:
    Router0:
      entryPoints:
        - foobar
        - foobar
      middlewares:
        - foobar
        - foobar
      service: foobar
      rule: foobar
      ruleSyntax: foobar
      priority: 42
      tls:
        options: foobar
        certResolver: foobar
        domains:
          - main: foobar
            sans:
              - foobar
              - foobar
          - main: foobar
            sans:
              - foobar
              - foobar
      observability:
        accessLogs: true
        tracing: true
        metrics: true
    Router1:
      entryPoints:
        - foobar
        - foobar
      middlewares:
        - foobar
        - foobar
      service: foobar
      rule: foobar
      ruleSyntax: foobar
      priority: 42
      tls:
        options: foobar
        certResolver: foobar
        domains:
          - main: foobar
            sans:
              - foobar
              - foobar
          - main: foobar
            sans:
              - foobar
              - foobar
      observability:
        accessLogs: true
        tracing: true
        metrics: true
  services:
    Service01:
      failover:
        service: foobar
        fallback: foobar
        healthCheck: {}
    Service02:
      loadBalancer:
        sticky:
          cookie:
            name: foobar
            secure: true
            httpOnly: true
            sameSite: foobar
            maxAge: 42
            path: foobar
        servers:
          - url: foobar
            weight: 42
            preservePath: true
          - url: foobar
            weight: 42
            preservePath: true
        healthCheck:
          scheme: foobar
          mode: foobar
          path: foobar
          method: foobar
          status: 42
          port: 42
          interval: 42s
          timeout: 42s
          hostname: foobar
          followRedirects: true
          headers:
            name0: foobar
            name1: foobar
        passHostHeader: true
        responseForwarding:
          flushInterval: 42s
        serversTransport: foobar
    Service03:
      mirroring:
        service: foobar
        mirrorBody: true
        maxBodySize: 42
        mirrors:
          - name: foobar
            percent: 42
          - name: foobar
            percent: 42
        healthCheck: {}
    Service04:
      weighted:
        services:
          - name: foobar
            weight: 42
          - name: foobar
            weight: 42
        sticky:
          cookie:
            name: foobar
            secure: true
            httpOnly: true
            sameSite: foobar
            maxAge: 42
            path: foobar
        healthCheck: {}
  middlewares:
    Middleware01:
      addPrefix:
        prefix: foobar
    Middleware02:
      basicAuth:
        users:
          - foobar
          - foobar
        usersFile: foobar
        realm: foobar
        removeHeader: true
        headerField: foobar
    Middleware03:
      buffering:
        maxRequestBodyBytes: 42
        memRequestBodyBytes: 42
        maxResponseBodyBytes: 42
        memResponseBodyBytes: 42
        retryExpression: foobar
    Middleware04:
      chain:
        middlewares:
          - foobar
          - foobar
    Middleware05:
      circuitBreaker:
        expression: foobar
        checkPeriod: 42s
        fallbackDuration: 42s
        recoveryDuration: 42s
        responseCode: 42
    Middleware06:
      compress:
        excludedContentTypes:
          - foobar
          - foobar
        includedContentTypes:
          - foobar
          - foobar
        minResponseBodyBytes: 42
        encodings:
          - foobar
          - foobar
        defaultEncoding: foobar
    Middleware07:
      contentType:
        autoDetect: true
    Middleware08:
      digestAuth:
        users:
          - foobar
          - foobar
        usersFile: foobar
        removeHeader: true
        realm: foobar
        headerField: foobar
    Middleware09:
      errors:
        status:
          - foobar
          - foobar
        service: foobar
        query: foobar
    Middleware10:
      forwardAuth:
        address: foobar
        tls:
          ca: foobar
          cert: foobar
          key: foobar
          insecureSkipVerify: true
          caOptional: true
        trustForwardHeader: true
        authResponseHeaders:
          - foobar
          - foobar
        authResponseHeadersRegex: foobar
        authRequestHeaders:
          - foobar
          - foobar
        addAuthCookiesToResponse:
          - foobar
          - foobar
        headerField: foobar
        forwardBody: true
        maxBodySize: 42
        preserveLocationHeader: true
    Middleware11:
      grpcWeb:
        allowOrigins:
          - foobar
          - foobar
    Middleware12:
      headers:
        customRequestHeaders:
          name0: foobar
          name1: foobar
        customResponseHeaders:
          name0: foobar
          name1: foobar
        accessControlAllowCredentials: true
        accessControlAllowHeaders:
          - foobar
          - foobar
        accessControlAllowMethods:
          - foobar
          - foobar
        accessControlAllowOriginList:
          - foobar
          - foobar
        accessControlAllowOriginListRegex:
          - foobar
          - foobar
        accessControlExposeHeaders:
          - foobar
          - foobar
        accessControlMaxAge: 42
        addVaryHeader: true
        allowedHosts:
          - foobar
          - foobar
        hostsProxyHeaders:
          - foobar
          - foobar
        sslProxyHeaders:
          name0: foobar
          name1: foobar
        stsSeconds: 42
        stsIncludeSubdomains: true
        stsPreload: true
        forceSTSHeader: true
        frameDeny: true
        customFrameOptionsValue: foobar
        contentTypeNosniff: true
        browserXssFilter: true
        customBrowserXSSValue: foobar
        contentSecurityPolicy: foobar
        contentSecurityPolicyReportOnly: foobar
        publicKey: foobar
        referrerPolicy: foobar
        permissionsPolicy: foobar
        isDevelopment: true
        featurePolicy: foobar
        sslRedirect: true
        sslTemporaryRedirect: true
        sslHost: foobar
        sslForceHost: true
    Middleware13:
      ipAllowList:
        sourceRange:
          - foobar
          - foobar
        ipStrategy:
          depth: 42
          excludedIPs:
            - foobar
            - foobar
          ipv6Subnet: 42
        rejectStatusCode: 42
    Middleware14:
      ipWhiteList:
        sourceRange:
          - foobar
          - foobar
        ipStrategy:
          depth: 42
          excludedIPs:
            - foobar
            - foobar
          ipv6Subnet: 42
    Middleware15:
      inFlightReq:
        amount: 42
        sourceCriterion:
          ipStrategy:
            depth: 42
            excludedIPs:
              - foobar
              - foobar
            ipv6Subnet: 42
          requestHeaderName: foobar
          requestHost: true
    Middleware16:
      passTLSClientCert:
        pem: true
        info:
          notAfter: true
          notBefore: true
          sans: true
          serialNumber: true
          subject:
            country: true
            province: true
            locality: true
            organization: true
            organizationalUnit: true
            commonName: true
            serialNumber: true
            domainComponent: true
          issuer:
            country: true
            province: true
            locality: true
            organization: true
            commonName: true
            serialNumber: true
            domainComponent: true
    Middleware17:
      plugin:
        PluginConf0:
          name0: foobar
          name1: foobar
        PluginConf1:
          name0: foobar
          name1: foobar
    Middleware18:
      rateLimit:
        average: 42
        period: 42s
        burst: 42
        sourceCriterion:
          ipStrategy:
            depth: 42
            excludedIPs:
              - foobar
              - foobar
            ipv6Subnet: 42
          requestHeaderName: foobar
          requestHost: true
    Middleware19:
      redirectRegex:
        regex: foobar
        replacement: foobar
        permanent: true
    Middleware20:
      redirectScheme:
        scheme: foobar
        port: foobar
        permanent: true
    Middleware21:
      replacePath:
        path: foobar
    Middleware22:
      replacePathRegex:
        regex: foobar
        replacement: foobar
    Middleware23:
      retry:
        attempts: 42
        initialInterval: 42s
    Middleware24:
      stripPrefix:
        prefixes:
          - foobar
          - foobar
        forceSlash: true
    Middleware25:
      stripPrefixRegex:
        regex:
          - foobar
          - foobar
  serversTransports:
    ServersTransport0:
      serverName: foobar
      insecureSkipVerify: true
      rootCAs:
        - foobar
        - foobar
      certificates:
        - certFile: foobar
          keyFile: foobar
        - certFile: foobar
          keyFile: foobar
      maxIdleConnsPerHost: 42
      forwardingTimeouts:
        dialTimeout: 42s
        responseHeaderTimeout: 42s
        idleConnTimeout: 42s
        readIdleTimeout: 42s
        pingTimeout: 42s
      disableHTTP2: true
      peerCertURI: foobar
      spiffe:
        ids:
          - foobar
          - foobar
        trustDomain: foobar
    ServersTransport1:
      serverName: foobar
      insecureSkipVerify: true
      rootCAs:
        - foobar
        - foobar
      certificates:
        - certFile: foobar
          keyFile: foobar
        - certFile: foobar
          keyFile: foobar
      maxIdleConnsPerHost: 42
      forwardingTimeouts:
        dialTimeout: 42s
        responseHeaderTimeout: 42s
        idleConnTimeout: 42s
        readIdleTimeout: 42s
        pingTimeout: 42s
      disableHTTP2: true
      peerCertURI: foobar
      spiffe:
        ids:
          - foobar
          - foobar
        trustDomain: foobar
tcp:
  routers:
    TCPRouter0:
      entryPoints:
        - foobar
        - foobar
      middlewares:
        - foobar
        - foobar
      service: foobar
      rule: foobar
      ruleSyntax: foobar
      priority: 42
      tls:
        passthrough: true
        options: foobar
        certResolver: foobar
        domains:
          - main: foobar
            sans:
              - foobar
              - foobar
          - main: foobar
            sans:
              - foobar
              - foobar
    TCPRouter1:
      entryPoints:
        - foobar
        - foobar
      middlewares:
        - foobar
        - foobar
      service: foobar
      rule: foobar
      ruleSyntax: foobar
      priority: 42
      tls:
        passthrough: true
        options: foobar
        certResolver: foobar
        domains:
          - main: foobar
            sans:
              - foobar
              - foobar
          - main: foobar
            sans:
              - foobar
              - foobar
  services:
    TCPService01:
      loadBalancer:
        proxyProtocol:
          version: 42
        servers:
          - address: foobar
            tls: true
          - address: foobar
            tls: true
        serversTransport: foobar
        terminationDelay: 42
    TCPService02:
      weighted:
        services:
          - name: foobar
            weight: 42
          - name: foobar
            weight: 42
  middlewares:
    TCPMiddleware01:
      ipAllowList:
        sourceRange:
          - foobar
          - foobar
    TCPMiddleware02:
      ipWhiteList:
        sourceRange:
          - foobar
          - foobar
    TCPMiddleware03:
      inFlightConn:
        amount: 42
  serversTransports:
    TCPServersTransport0:
      dialKeepAlive: 42s
      dialTimeout: 42s
      terminationDelay: 42s
      tls:
        serverName: foobar
        insecureSkipVerify: true
        rootCAs:
          - foobar
          - foobar
        certificates:
          - certFile: foobar
            keyFile: foobar
          - certFile: foobar
            keyFile: foobar
        peerCertURI: foobar
        spiffe:
          ids:
            - foobar
            - foobar
          trustDomain: foobar
    TCPServersTransport1:
      dialKeepAlive: 42s
      dialTimeout: 42s
      terminationDelay: 42s
      tls:
        serverName: foobar
        insecureSkipVerify: true
        rootCAs:
          - foobar
          - foobar
        certificates:
          - certFile: foobar
            keyFile: foobar
          - certFile: foobar
            keyFile: foobar
        peerCertURI: foobar
        spiffe:
          ids:
            - foobar
            - foobar
          trustDomain: foobar
udp:
  routers:
    UDPRouter0:
      entryPoints:
        - foobar
        - foobar
      service: foobar
    UDPRouter1:
      entryPoints:
        - foobar
        - foobar
      service: foobar
  services:
    UDPService01:
      loadBalancer:
        servers:
          - address: foobar
          - address: foobar
    UDPService02:
      weighted:
        services:
          - name: foobar
            weight: 42
          - name: foobar
            weight: 42
tls:
  certificates:
    - certFile: foobar
      keyFile: foobar
      stores:
        - foobar
        - foobar
    - certFile: foobar
      keyFile: foobar
      stores:
        - foobar
        - foobar
  options:
    Options0:
      minVersion: foobar
      maxVersion: foobar
      cipherSuites:
        - foobar
        - foobar
      curvePreferences:
        - foobar
        - foobar
      clientAuth:
        caFiles:
          - foobar
          - foobar
        clientAuthType: foobar
      sniStrict: true
      alpnProtocols:
        - foobar
        - foobar
      preferServerCipherSuites: true
    Options1:
      minVersion: foobar
      maxVersion: foobar
      cipherSuites:
        - foobar
        - foobar
      curvePreferences:
        - foobar
        - foobar
      clientAuth:
        caFiles:
          - foobar
          - foobar
        clientAuthType: foobar
      sniStrict: true
      alpnProtocols:
        - foobar
        - foobar
      preferServerCipherSuites: true
  stores:
    Store0:
      defaultCertificate:
        certFile: foobar
        keyFile: foobar
      defaultGeneratedCert:
        resolver: foobar
        domain:
          main: foobar
          sans:
            - foobar
            - foobar
    Store1:
      defaultCertificate:
        certFile: foobar
        keyFile: foobar
      defaultGeneratedCert:
        resolver: foobar
        domain:
          main: foobar
          sans:
            - foobar
            - foobar
```
# Labels
https://doc.traefik.io/traefik/reference/dynamic-configuration/docker/

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.docker.network=foobar"
  ## CODE GENERATED AUTOMATICALLY
  ## THIS FILE MUST NOT BE EDITED BY HAND
  - "traefik.http.middlewares.middleware01.addprefix.prefix=foobar"
  - "traefik.http.middlewares.middleware02.basicauth.headerfield=foobar"
  - "traefik.http.middlewares.middleware02.basicauth.realm=foobar"
  - "traefik.http.middlewares.middleware02.basicauth.removeheader=true"
  - "traefik.http.middlewares.middleware02.basicauth.users=foobar, foobar"
  - "traefik.http.middlewares.middleware02.basicauth.usersfile=foobar"
  - "traefik.http.middlewares.middleware03.buffering.maxrequestbodybytes=42"
  - "traefik.http.middlewares.middleware03.buffering.maxresponsebodybytes=42"
  - "traefik.http.middlewares.middleware03.buffering.memrequestbodybytes=42"
  - "traefik.http.middlewares.middleware03.buffering.memresponsebodybytes=42"
  - "traefik.http.middlewares.middleware03.buffering.retryexpression=foobar"
  - "traefik.http.middlewares.middleware04.chain.middlewares=foobar, foobar"
  - "traefik.http.middlewares.middleware05.circuitbreaker.checkperiod=42s"
  - "traefik.http.middlewares.middleware05.circuitbreaker.expression=foobar"
  - "traefik.http.middlewares.middleware05.circuitbreaker.fallbackduration=42s"
  - "traefik.http.middlewares.middleware05.circuitbreaker.recoveryduration=42s"
  - "traefik.http.middlewares.middleware05.circuitbreaker.responsecode=42"
  - "traefik.http.middlewares.middleware06.compress=true"
  - "traefik.http.middlewares.middleware06.compress.defaultencoding=foobar"
  - "traefik.http.middlewares.middleware06.compress.encodings=foobar, foobar"
  - "traefik.http.middlewares.middleware06.compress.excludedcontenttypes=foobar, foobar"
  - "traefik.http.middlewares.middleware06.compress.includedcontenttypes=foobar, foobar"
  - "traefik.http.middlewares.middleware06.compress.minresponsebodybytes=42"
  - "traefik.http.middlewares.middleware07.contenttype=true"
  - "traefik.http.middlewares.middleware07.contenttype.autodetect=true"
  - "traefik.http.middlewares.middleware08.digestauth.headerfield=foobar"
  - "traefik.http.middlewares.middleware08.digestauth.realm=foobar"
  - "traefik.http.middlewares.middleware08.digestauth.removeheader=true"
  - "traefik.http.middlewares.middleware08.digestauth.users=foobar, foobar"
  - "traefik.http.middlewares.middleware08.digestauth.usersfile=foobar"
  - "traefik.http.middlewares.middleware09.errors.query=foobar"
  - "traefik.http.middlewares.middleware09.errors.service=foobar"
  - "traefik.http.middlewares.middleware09.errors.status=foobar, foobar"
  - "traefik.http.middlewares.middleware10.forwardauth.addauthcookiestoresponse=foobar, foobar"
  - "traefik.http.middlewares.middleware10.forwardauth.address=foobar"
  - "traefik.http.middlewares.middleware10.forwardauth.authrequestheaders=foobar, foobar"
  - "traefik.http.middlewares.middleware10.forwardauth.authresponseheaders=foobar, foobar"
  - "traefik.http.middlewares.middleware10.forwardauth.authresponseheadersregex=foobar"
  - "traefik.http.middlewares.middleware10.forwardauth.forwardbody=true"
  - "traefik.http.middlewares.middleware10.forwardauth.headerfield=foobar"
  - "traefik.http.middlewares.middleware10.forwardauth.maxbodysize=42"
  - "traefik.http.middlewares.middleware10.forwardauth.preservelocationheader=true"
  - "traefik.http.middlewares.middleware10.forwardauth.tls.ca=foobar"
  - "traefik.http.middlewares.middleware10.forwardauth.tls.caoptional=true"
  - "traefik.http.middlewares.middleware10.forwardauth.tls.cert=foobar"
  - "traefik.http.middlewares.middleware10.forwardauth.tls.insecureskipverify=true"
  - "traefik.http.middlewares.middleware10.forwardauth.tls.key=foobar"
  - "traefik.http.middlewares.middleware10.forwardauth.trustforwardheader=true"
  - "traefik.http.middlewares.middleware11.grpcweb.alloworigins=foobar, foobar"
  - "traefik.http.middlewares.middleware12.headers.accesscontrolallowcredentials=true"
  - "traefik.http.middlewares.middleware12.headers.accesscontrolallowheaders=foobar, foobar"
  - "traefik.http.middlewares.middleware12.headers.accesscontrolallowmethods=foobar, foobar"
  - "traefik.http.middlewares.middleware12.headers.accesscontrolalloworiginlist=foobar, foobar"
  - "traefik.http.middlewares.middleware12.headers.accesscontrolalloworiginlistregex=foobar, foobar"
  - "traefik.http.middlewares.middleware12.headers.accesscontrolexposeheaders=foobar, foobar"
  - "traefik.http.middlewares.middleware12.headers.accesscontrolmaxage=42"
  - "traefik.http.middlewares.middleware12.headers.addvaryheader=true"
  - "traefik.http.middlewares.middleware12.headers.allowedhosts=foobar, foobar"
  - "traefik.http.middlewares.middleware12.headers.browserxssfilter=true"
  - "traefik.http.middlewares.middleware12.headers.contentsecuritypolicy=foobar"
  - "traefik.http.middlewares.middleware12.headers.contentsecuritypolicyreportonly=foobar"
  - "traefik.http.middlewares.middleware12.headers.contenttypenosniff=true"
  - "traefik.http.middlewares.middleware12.headers.custombrowserxssvalue=foobar"
  - "traefik.http.middlewares.middleware12.headers.customframeoptionsvalue=foobar"
  - "traefik.http.middlewares.middleware12.headers.customrequestheaders.name0=foobar"
  - "traefik.http.middlewares.middleware12.headers.customrequestheaders.name1=foobar"
  - "traefik.http.middlewares.middleware12.headers.customresponseheaders.name0=foobar"
  - "traefik.http.middlewares.middleware12.headers.customresponseheaders.name1=foobar"
  - "traefik.http.middlewares.middleware12.headers.featurepolicy=foobar"
  - "traefik.http.middlewares.middleware12.headers.forcestsheader=true"
  - "traefik.http.middlewares.middleware12.headers.framedeny=true"
  - "traefik.http.middlewares.middleware12.headers.hostsproxyheaders=foobar, foobar"
  - "traefik.http.middlewares.middleware12.headers.isdevelopment=true"
  - "traefik.http.middlewares.middleware12.headers.permissionspolicy=foobar"
  - "traefik.http.middlewares.middleware12.headers.publickey=foobar"
  - "traefik.http.middlewares.middleware12.headers.referrerpolicy=foobar"
  - "traefik.http.middlewares.middleware12.headers.sslforcehost=true"
  - "traefik.http.middlewares.middleware12.headers.sslhost=foobar"
  - "traefik.http.middlewares.middleware12.headers.sslproxyheaders.name0=foobar"
  - "traefik.http.middlewares.middleware12.headers.sslproxyheaders.name1=foobar"
  - "traefik.http.middlewares.middleware12.headers.sslredirect=true"
  - "traefik.http.middlewares.middleware12.headers.ssltemporaryredirect=true"
  - "traefik.http.middlewares.middleware12.headers.stsincludesubdomains=true"
  - "traefik.http.middlewares.middleware12.headers.stspreload=true"
  - "traefik.http.middlewares.middleware12.headers.stsseconds=42"
  - "traefik.http.middlewares.middleware13.ipallowlist.ipstrategy=true"
  - "traefik.http.middlewares.middleware13.ipallowlist.ipstrategy.depth=42"
  - "traefik.http.middlewares.middleware13.ipallowlist.ipstrategy.excludedips=foobar, foobar"
  - "traefik.http.middlewares.middleware13.ipallowlist.ipstrategy.ipv6subnet=42"
  - "traefik.http.middlewares.middleware13.ipallowlist.rejectstatuscode=42"
  - "traefik.http.middlewares.middleware13.ipallowlist.sourcerange=foobar, foobar"
  - "traefik.http.middlewares.middleware14.ipwhitelist.ipstrategy=true"
  - "traefik.http.middlewares.middleware14.ipwhitelist.ipstrategy.depth=42"
  - "traefik.http.middlewares.middleware14.ipwhitelist.ipstrategy.excludedips=foobar, foobar"
  - "traefik.http.middlewares.middleware14.ipwhitelist.ipstrategy.ipv6subnet=42"
  - "traefik.http.middlewares.middleware14.ipwhitelist.sourcerange=foobar, foobar"
  - "traefik.http.middlewares.middleware15.inflightreq.amount=42"
  - "traefik.http.middlewares.middleware15.inflightreq.sourcecriterion.ipstrategy.depth=42"
  - "traefik.http.middlewares.middleware15.inflightreq.sourcecriterion.ipstrategy.excludedips=foobar, foobar"
  - "traefik.http.middlewares.middleware15.inflightreq.sourcecriterion.ipstrategy.ipv6subnet=42"
  - "traefik.http.middlewares.middleware15.inflightreq.sourcecriterion.requestheadername=foobar"
  - "traefik.http.middlewares.middleware15.inflightreq.sourcecriterion.requesthost=true"
  - "traefik.http.middlewares.middleware16.passtlsclientcert.info.issuer.commonname=true"
  - "traefik.http.middlewares.middleware16.passtlsclientcert.info.issuer.country=true"
  - "traefik.http.middlewares.middleware16.passtlsclientcert.info.issuer.domaincomponent=true"
  - "traefik.http.middlewares.middleware16.passtlsclientcert.info.issuer.locality=true"
  - "traefik.http.middlewares.middleware16.passtlsclientcert.info.issuer.organization=true"
  - "traefik.http.middlewares.middleware16.passtlsclientcert.info.issuer.province=true"
  - "traefik.http.middlewares.middleware16.passtlsclientcert.info.issuer.serialnumber=true"
  - "traefik.http.middlewares.middleware16.passtlsclientcert.info.notafter=true"
  - "traefik.http.middlewares.middleware16.passtlsclientcert.info.notbefore=true"
  - "traefik.http.middlewares.middleware16.passtlsclientcert.info.sans=true"
  - "traefik.http.middlewares.middleware16.passtlsclientcert.info.serialnumber=true"
  - "traefik.http.middlewares.middleware16.passtlsclientcert.info.subject.commonname=true"
  - "traefik.http.middlewares.middleware16.passtlsclientcert.info.subject.country=true"
  - "traefik.http.middlewares.middleware16.passtlsclientcert.info.subject.domaincomponent=true"
  - "traefik.http.middlewares.middleware16.passtlsclientcert.info.subject.locality=true"
  - "traefik.http.middlewares.middleware16.passtlsclientcert.info.subject.organization=true"
  - "traefik.http.middlewares.middleware16.passtlsclientcert.info.subject.organizationalunit=true"
  - "traefik.http.middlewares.middleware16.passtlsclientcert.info.subject.province=true"
  - "traefik.http.middlewares.middleware16.passtlsclientcert.info.subject.serialnumber=true"
  - "traefik.http.middlewares.middleware16.passtlsclientcert.pem=true"
  - "traefik.http.middlewares.middleware17.plugin.pluginconf0.name0=foobar"
  - "traefik.http.middlewares.middleware17.plugin.pluginconf0.name1=foobar"
  - "traefik.http.middlewares.middleware17.plugin.pluginconf1.name0=foobar"
  - "traefik.http.middlewares.middleware17.plugin.pluginconf1.name1=foobar"
  - "traefik.http.middlewares.middleware18.ratelimit.average=42"
  - "traefik.http.middlewares.middleware18.ratelimit.burst=42"
  - "traefik.http.middlewares.middleware18.ratelimit.period=42s"
  - "traefik.http.middlewares.middleware18.ratelimit.sourcecriterion.ipstrategy.depth=42"
  - "traefik.http.middlewares.middleware18.ratelimit.sourcecriterion.ipstrategy.excludedips=foobar, foobar"
  - "traefik.http.middlewares.middleware18.ratelimit.sourcecriterion.ipstrategy.ipv6subnet=42"
  - "traefik.http.middlewares.middleware18.ratelimit.sourcecriterion.requestheadername=foobar"
  - "traefik.http.middlewares.middleware18.ratelimit.sourcecriterion.requesthost=true"
  - "traefik.http.middlewares.middleware19.redirectregex.permanent=true"
  - "traefik.http.middlewares.middleware19.redirectregex.regex=foobar"
  - "traefik.http.middlewares.middleware19.redirectregex.replacement=foobar"
  - "traefik.http.middlewares.middleware20.redirectscheme.permanent=true"
  - "traefik.http.middlewares.middleware20.redirectscheme.port=foobar"
  - "traefik.http.middlewares.middleware20.redirectscheme.scheme=foobar"
  - "traefik.http.middlewares.middleware21.replacepath.path=foobar"
  - "traefik.http.middlewares.middleware22.replacepathregex.regex=foobar"
  - "traefik.http.middlewares.middleware22.replacepathregex.replacement=foobar"
  - "traefik.http.middlewares.middleware23.retry.attempts=42"
  - "traefik.http.middlewares.middleware23.retry.initialinterval=42s"
  - "traefik.http.middlewares.middleware24.stripprefix.forceslash=true"
  - "traefik.http.middlewares.middleware24.stripprefix.prefixes=foobar, foobar"
  - "traefik.http.middlewares.middleware25.stripprefixregex.regex=foobar, foobar"
  - "traefik.http.routers.router0.entrypoints=foobar, foobar"
  - "traefik.http.routers.router0.middlewares=foobar, foobar"
  - "traefik.http.routers.router0.observability.accesslogs=true"
  - "traefik.http.routers.router0.observability.metrics=true"
  - "traefik.http.routers.router0.observability.tracing=true"
  - "traefik.http.routers.router0.priority=42"
  - "traefik.http.routers.router0.rule=foobar"
  - "traefik.http.routers.router0.rulesyntax=foobar"
  - "traefik.http.routers.router0.service=foobar"
  - "traefik.http.routers.router0.tls=true"
  - "traefik.http.routers.router0.tls.certresolver=foobar"
  - "traefik.http.routers.router0.tls.domains[0].main=foobar"
  - "traefik.http.routers.router0.tls.domains[0].sans=foobar, foobar"
  - "traefik.http.routers.router0.tls.domains[1].main=foobar"
  - "traefik.http.routers.router0.tls.domains[1].sans=foobar, foobar"
  - "traefik.http.routers.router0.tls.options=foobar"
  - "traefik.http.routers.router1.entrypoints=foobar, foobar"
  - "traefik.http.routers.router1.middlewares=foobar, foobar"
  - "traefik.http.routers.router1.observability.accesslogs=true"
  - "traefik.http.routers.router1.observability.metrics=true"
  - "traefik.http.routers.router1.observability.tracing=true"
  - "traefik.http.routers.router1.priority=42"
  - "traefik.http.routers.router1.rule=foobar"
  - "traefik.http.routers.router1.rulesyntax=foobar"
  - "traefik.http.routers.router1.service=foobar"
  - "traefik.http.routers.router1.tls=true"
  - "traefik.http.routers.router1.tls.certresolver=foobar"
  - "traefik.http.routers.router1.tls.domains[0].main=foobar"
  - "traefik.http.routers.router1.tls.domains[0].sans=foobar, foobar"
  - "traefik.http.routers.router1.tls.domains[1].main=foobar"
  - "traefik.http.routers.router1.tls.domains[1].sans=foobar, foobar"
  - "traefik.http.routers.router1.tls.options=foobar"
  - "traefik.http.services.service02.loadbalancer.healthcheck.followredirects=true"
  - "traefik.http.services.service02.loadbalancer.healthcheck.headers.name0=foobar"
  - "traefik.http.services.service02.loadbalancer.healthcheck.headers.name1=foobar"
  - "traefik.http.services.service02.loadbalancer.healthcheck.hostname=foobar"
  - "traefik.http.services.service02.loadbalancer.healthcheck.interval=42s"
  - "traefik.http.services.service02.loadbalancer.healthcheck.method=foobar"
  - "traefik.http.services.service02.loadbalancer.healthcheck.mode=foobar"
  - "traefik.http.services.service02.loadbalancer.healthcheck.path=foobar"
  - "traefik.http.services.service02.loadbalancer.healthcheck.port=42"
  - "traefik.http.services.service02.loadbalancer.healthcheck.scheme=foobar"
  - "traefik.http.services.service02.loadbalancer.healthcheck.status=42"
  - "traefik.http.services.service02.loadbalancer.healthcheck.timeout=42s"
  - "traefik.http.services.service02.loadbalancer.passhostheader=true"
  - "traefik.http.services.service02.loadbalancer.responseforwarding.flushinterval=42s"
  - "traefik.http.services.service02.loadbalancer.serverstransport=foobar"
  - "traefik.http.services.service02.loadbalancer.sticky=true"
  - "traefik.http.services.service02.loadbalancer.sticky.cookie=true"
  - "traefik.http.services.service02.loadbalancer.sticky.cookie.httponly=true"
  - "traefik.http.services.service02.loadbalancer.sticky.cookie.maxage=42"
  - "traefik.http.services.service02.loadbalancer.sticky.cookie.name=foobar"
  - "traefik.http.services.service02.loadbalancer.sticky.cookie.path=foobar"
  - "traefik.http.services.service02.loadbalancer.sticky.cookie.samesite=foobar"
  - "traefik.http.services.service02.loadbalancer.sticky.cookie.secure=true"
  - "traefik.http.services.service02.loadbalancer.server.port=foobar"
  - "traefik.http.services.service02.loadbalancer.server.scheme=foobar"
  - "traefik.http.services.service02.loadbalancer.server.weight=42"
  - "traefik.tcp.middlewares.tcpmiddleware01.ipallowlist.sourcerange=foobar, foobar"
  - "traefik.tcp.middlewares.tcpmiddleware02.ipwhitelist.sourcerange=foobar, foobar"
  - "traefik.tcp.middlewares.tcpmiddleware03.inflightconn.amount=42"
  - "traefik.tcp.routers.tcprouter0.entrypoints=foobar, foobar"
  - "traefik.tcp.routers.tcprouter0.middlewares=foobar, foobar"
  - "traefik.tcp.routers.tcprouter0.priority=42"
  - "traefik.tcp.routers.tcprouter0.rule=foobar"
  - "traefik.tcp.routers.tcprouter0.rulesyntax=foobar"
  - "traefik.tcp.routers.tcprouter0.service=foobar"
  - "traefik.tcp.routers.tcprouter0.tls=true"
  - "traefik.tcp.routers.tcprouter0.tls.certresolver=foobar"
  - "traefik.tcp.routers.tcprouter0.tls.domains[0].main=foobar"
  - "traefik.tcp.routers.tcprouter0.tls.domains[0].sans=foobar, foobar"
  - "traefik.tcp.routers.tcprouter0.tls.domains[1].main=foobar"
  - "traefik.tcp.routers.tcprouter0.tls.domains[1].sans=foobar, foobar"
  - "traefik.tcp.routers.tcprouter0.tls.options=foobar"
  - "traefik.tcp.routers.tcprouter0.tls.passthrough=true"
  - "traefik.tcp.routers.tcprouter1.entrypoints=foobar, foobar"
  - "traefik.tcp.routers.tcprouter1.middlewares=foobar, foobar"
  - "traefik.tcp.routers.tcprouter1.priority=42"
  - "traefik.tcp.routers.tcprouter1.rule=foobar"
  - "traefik.tcp.routers.tcprouter1.rulesyntax=foobar"
  - "traefik.tcp.routers.tcprouter1.service=foobar"
  - "traefik.tcp.routers.tcprouter1.tls=true"
  - "traefik.tcp.routers.tcprouter1.tls.certresolver=foobar"
  - "traefik.tcp.routers.tcprouter1.tls.domains[0].main=foobar"
  - "traefik.tcp.routers.tcprouter1.tls.domains[0].sans=foobar, foobar"
  - "traefik.tcp.routers.tcprouter1.tls.domains[1].main=foobar"
  - "traefik.tcp.routers.tcprouter1.tls.domains[1].sans=foobar, foobar"
  - "traefik.tcp.routers.tcprouter1.tls.options=foobar"
  - "traefik.tcp.routers.tcprouter1.tls.passthrough=true"
  - "traefik.tcp.services.tcpservice01.loadbalancer.proxyprotocol=true"
  - "traefik.tcp.services.tcpservice01.loadbalancer.proxyprotocol.version=42"
  - "traefik.tcp.services.tcpservice01.loadbalancer.serverstransport=foobar"
  - "traefik.tcp.services.tcpservice01.loadbalancer.terminationdelay=42"
  - "traefik.tcp.services.tcpservice01.loadbalancer.server.port=foobar"
  - "traefik.tcp.services.tcpservice01.loadbalancer.server.tls=true"
  - "traefik.tls.stores.store0.defaultgeneratedcert.domain.main=foobar"
  - "traefik.tls.stores.store0.defaultgeneratedcert.domain.sans=foobar, foobar"
  - "traefik.tls.stores.store0.defaultgeneratedcert.resolver=foobar"
  - "traefik.tls.stores.store1.defaultgeneratedcert.domain.main=foobar"
  - "traefik.tls.stores.store1.defaultgeneratedcert.domain.sans=foobar, foobar"
  - "traefik.tls.stores.store1.defaultgeneratedcert.resolver=foobar"
  - "traefik.udp.routers.udprouter0.entrypoints=foobar, foobar"
  - "traefik.udp.routers.udprouter0.service=foobar"
  - "traefik.udp.routers.udprouter1.entrypoints=foobar, foobar"
  - "traefik.udp.routers.udprouter1.service=foobar"
  - "traefik.udp.services.udpservice01.loadbalancer.server.port=foobar"
```