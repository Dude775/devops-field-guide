# Images - Hands-On 6.5 NodePort Linux Killercoda

Planned screenshots for this lab (captured in Killercoda browser playground).

| File | Description |
|------|-------------|
| 00-killercoda-linux-environment.png | `cat /etc/os-release` — Ubuntu 24.04.4 LTS + prompt root@controlplane |
| 01-nodes-wide.png | `kubectl get nodes -o wide` — controlplane + node01, Internal IPs |
| 02-nodeport-service-created.png | `kubectl get svc` — color-api-nodeport, ClusterIP 10.102.65.208, 80:30007/TCP |
| 03-nodeip-curl-success.png | `curl http://172.30.1.2:30007/api` — תגובה ראשונה עם COLOR + HOSTNAME |
| 04-load-balancing-hostnames.png | לולאת curl — 5 Pods שונים מגיבים |
| 05-pods-across-nodes.png | `kubectl get pods -o wide` — Pods מפוזרים על controlplane + node01 |
| 06-pod-delete-traffic-continues.png | תעבורה לפני ואחרי מחיקת Pod — Pod חדש g5qmt מגיב |
| 07-nodeport-final-describe.png | `kubectl describe svc color-api-nodeport` — Endpoints + ExternalTrafficPolicy: Cluster |

> Screenshots לא הועתקו ממסך ה-Killercoda. קבצי PNG לא קיימים.
