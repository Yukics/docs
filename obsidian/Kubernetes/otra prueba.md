---
title: Cheatsheet
---
# Liveness y Rediness probe
```yaml
    spec:
      containers:
      - name: nginx
        image: nginx:stable-alpine3.23-slim
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 15
          periodSeconds: 20
          timeoutSeconds: 5
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 15
          periodSeconds: 5
          successThreshold: 1
          failureThreshold: 10
```