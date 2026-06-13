# Images - Hands-On 6.6 ExternalName Service

Planned screenshots for this lab.

| File | Description |
|------|-------------|
| `00-externalname-yaml.png` | The ExternalName manifest: `type: ExternalName`, `externalName: google.com` |
| `01-externalname-service-created.png` | Terminal output after `kubectl apply -f .` showing `my-external-svc created` |
| `02-traffic-generator-ready.png` | `kubectl get pods` showing traffic-generator Pod in Running state |
| `03-curl-google-through-service.png` | curl output inside traffic-generator: HTTP/2 404 response from Google |
| `04-no-clusterip-no-endpoints.png` | `kubectl get svc -o wide` + `kubectl get endpoints` showing no ClusterIP and NotFound for endpoints |
| `05-cleanup-final-state.png` | Terminal after `kubectl delete -f . --force` — all 6.6 resources removed |
