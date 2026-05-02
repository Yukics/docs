```bash
kubectl patch application loki -n argocd \ --type json \ -p '[{"op":"remove","path":"/metadata/finalizers"}]'
```