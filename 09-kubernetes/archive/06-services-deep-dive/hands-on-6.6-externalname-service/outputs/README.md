# Outputs - Hands-On 6.6 ExternalName Service

Captured terminal outputs from the lab session.

| File | Description |
|------|-------------|
| `01-lab-files.txt` | Directory listing before applying manifests |
| `04-externalname-describe.txt` | `kubectl describe svc my-external-svc` — no ClusterIP, no Endpoints, CNAME target is google.com |
| `05-curl-externalname-html.txt` | Full HTML body from `curl http://my-external-svc` — Google 404 error page |
| `06-curl-externalname-headers.txt` | `curl -I -k https://my-external-svc` — returns HTTP/2 404 from Google |
| `07-externalname-service-wide.txt` | `kubectl get svc -o wide` — CLUSTER-IP is `<none>`, SELECTOR is `<none>` |
| `08-externalname-no-endpoints.txt` | `kubectl get endpoints my-external-svc` — server returns NotFound (expected) |
| `09-lab-conclusion.txt` | Lab summary notes |
| `10-final-file-list.txt` | File list at end of lab |
| `11-cleanup.txt` | `kubectl delete -f . --force --ignore-not-found=true` output |
| `12-pods-after-cleanup.txt` | Pods immediately after --force delete (color-api Pods in Terminating) |
| `13-services-after-cleanup.txt` | Services remaining after cleanup (unrelated: busybox, kubernetes, movie-api-service) |
| `14-deploy-after-cleanup.txt` | Deployments remaining (unrelated: movie-api-deployment) |

## Notes

- `02-services-with-externalname.txt` and `03-pods-before-exec.txt` were not captured locally during this session.
- The key proof of the lab is in `06-curl-externalname-headers.txt`: `HTTP/2 404` confirms DNS resolution via ExternalName worked and the request reached Google.
- `08-externalname-no-endpoints.txt` shows the expected error: ExternalName services do not create Endpoints objects.
