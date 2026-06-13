# Hands-On 6.6 - ExternalName Service

> **Series**: Kubernetes Services Deep Dive — Lab 6.6
> **Environment**: Docker Desktop / minikube (Windows)
> **Status**: completed

---

## Goal

Deploy an ExternalName Service and understand what it actually does — and does not do — compared to ClusterIP and NodePort.

ExternalName is fundamentally different: it does not create a ClusterIP, does not use selectors, and does not route traffic to Pods. It is a DNS alias. CoreDNS returns a CNAME record pointing to an external hostname. The cluster does the rest.

---

## Files

```
manifests/
  color-api-deployment.yaml    # 5-replica Color API deployment
  color-api-clusterip.yaml     # ClusterIP service for internal routing
  color-api-nodeport.yaml      # NodePort service (for reference only)
  google-externalname.yaml     # The ExternalName service pointing to google.com
  traffic-generator.yaml       # Pod used as internal client for curl tests

outputs/
  01-lab-files.txt             # Lab directory listing before apply
  04-externalname-describe.txt # kubectl describe of ExternalName service
  05-curl-externalname-html.txt  # Full HTML response from curl via ExternalName
  06-curl-externalname-headers.txt  # HTTP headers response (HTTP/2 404)
  07-externalname-service-wide.txt  # kubectl get svc -o wide showing no ClusterIP
  08-externalname-no-endpoints.txt  # Proof: no Endpoints exist for ExternalName
  09-lab-conclusion.txt        # Lab summary
  10-final-file-list.txt       # Final file listing
  11-cleanup.txt               # kubectl delete output
  12-pods-after-cleanup.txt    # Pod state immediately after --force delete
  13-services-after-cleanup.txt  # Services remaining after cleanup
  14-deploy-after-cleanup.txt  # Deployments after cleanup

images/
  README.md                    # Screenshot plan
```

---

## ExternalName YAML

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-external-svc
spec:
  type: ExternalName
  externalName: google.com
```

Important: `externalName` must be a plain hostname — `google.com`, not `https://google.com`. The field takes a DNS name, not a URL.

---

## Apply

```bash
kubectl apply -f .
```

Expected output:
```
deployment.apps/color-api-deployment unchanged
service/color-api-clusterip unchanged
service/my-external-svc created
pod/traffic-generator created
```

The ClusterIP and deployment were already present from earlier labs, so they show `unchanged`.

---

## Service Behavior

After apply, running `kubectl get svc -o wide` shows:

```
NAME              TYPE           CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE    SELECTOR
my-external-svc   ExternalName   <none>       google.com    <none>    110s   <none>
```

Key observations:
- `CLUSTER-IP` is `<none>` — no virtual IP was allocated
- `EXTERNAL-IP` shows `google.com` — this is the CNAME target
- `SELECTOR` is `<none>` — no Pods are attached
- `PORT(S)` is `<none>` — no port translation

Running `kubectl describe svc my-external-svc` confirms:

```
Name:              my-external-svc
Namespace:         default
Selector:          <none>
Type:              ExternalName
IP:
IPs:               <none>
External Name:     google.com
```

No ClusterIP. No Endpoints.

---

## Exec into traffic-generator

```bash
kubectl exec traffic-generator -- sh -c 'curl -I -k https://my-external-svc || true'
```

The `traffic-generator` Pod is used as an internal cluster client. Inside the cluster, `my-external-svc` resolves through CoreDNS to a CNAME pointing to `google.com`. The actual HTTP request then goes out to Google.

---

## curl Test

Headers response (`-I -k https://my-external-svc`):

```
HTTP/2 404
date: Sat, 13 Jun 2026 18:09:49 GMT
content-type: text/html; charset=UTF-8
alt-svc: h3=":443"; ma=2592000,h3-29=":443"; ma=2592000
```

Full HTML curl also returned a Google 404 error page with Google branding.

---

## What Actually Happened

`HTTP/2 404` is proof the lab worked correctly.

Here is the chain of events:
1. `curl https://my-external-svc` from inside the cluster
2. CoreDNS resolved `my-external-svc` → CNAME → `google.com`
3. The request went out to Google's servers over HTTPS
4. Google received a request for `/` on a hostname that didn't match a virtual host
5. Google returned 404

The 404 is a Google-side response, not a DNS failure. If DNS had failed, you would get a connection refused or name resolution error. Getting an HTTP response from Google is success.

---

## What ExternalName Does Not Do

- Does not create a ClusterIP
- Does not use label selectors
- Does not create normal Endpoints (confirmed: `Error from server (NotFound): endpoints "my-external-svc" not found`)
- Does not load balance between Pods
- Does not use kube-proxy or iptables rules like ClusterIP/NodePort
- Does not handle TLS termination
- Does not work like a reverse proxy

It is a DNS alias. That is the entire feature.

---

## Cleanup

```bash
kubectl delete -f . --force --ignore-not-found=true
```

Output:
```
service "color-api-clusterip" force deleted
deployment.apps "color-api-deployment" force deleted
service "color-api-nodeport" force deleted
service "my-external-svc" force deleted
pod "traffic-generator" force deleted
```

After cleanup, the color-api Pods went into `Terminating` state temporarily because `--force` was used. This is expected. Unrelated older resources (`demo-statefulset-*`, `movie-api-deployment`, etc.) were intentionally not touched.

---

## Comparison Table

| Feature | ClusterIP | NodePort | ExternalName |
|---------|-----------|----------|--------------|
| Creates ClusterIP | yes | yes | **no** |
| Creates Endpoints | yes (when selector matches Pods) | yes | **no** |
| Routes to Pods | yes | yes | **no** |
| DNS only | no | no | **yes** |
| External access | no | yes (NodeIP:NodePort) | depends on external DNS target |
| kube-proxy / iptables | yes | yes | **no** |
| CoreDNS behavior | A record → ClusterIP | A record → ClusterIP | **CNAME → externalName** |

---

## Conclusion

ExternalName is the simplest Service type in Kubernetes. It does one thing: tell CoreDNS to return a CNAME for a given service name. There is no load balancing, no ClusterIP, no Endpoints object.

Use cases in production:
- Abstracting external databases or SaaS endpoints behind a stable cluster-internal DNS name
- Switching between internal and external services without changing application config (change the externalName, not the app)

The `HTTP/2 404` from Google was valid proof. DNS worked, the request left the cluster, reached Google, and Google responded.

---

## Screenshot Plan

See [images/README.md](./images/README.md)
