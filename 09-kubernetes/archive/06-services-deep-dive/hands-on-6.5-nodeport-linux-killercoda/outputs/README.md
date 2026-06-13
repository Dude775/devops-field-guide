# Outputs - Hands-On 6.5 NodePort Linux Killercoda

פלטים שנלכדו במהלך הלאב ב-Killercoda playground.

| File | Description |
|------|-------------|
| 01-pods-created.txt | פלט `kubectl apply -f .` — יצירת Deployment |
| 02-services-created.txt | פלט `kubectl apply -f .` — יצירת Service |
| 03-pods-ready-distributed.txt | `kubectl get pods -o wide` — Pods מוכנים ומופץ על Nodes |
| 04-nodes-wide.txt | `kubectl get nodes -o wide` — Nodes עם Internal IPs |
| 05-node-ip-used.txt | `echo $NODE_IP` — 172.30.1.2 |
| 06-first-nodeport-curl.txt | curl ראשון ל-NodePort — תגובה עם COLOR ו-HOSTNAME |
| 07-nodeport-load-balancing.txt | לולאת 10 קריאות — הפצה בין 5 Pods |
| 08-pods-distribution-before-delete.txt | `kubectl get pods -o wide` לפני מחיקת Pod |
| 09-node01-ip-used.txt | `echo $NODE2_IP` — 172.30.2.2 |
| 10-nodeport-from-node01-ip.txt | לולאת curl דרך node01 IP — cross-node routing |
| 11-victim-pod-selected.txt | שם ה-Pod שנמחק |
| 12-pods-after-delete.txt | `kubectl get pods -o wide` — Pod חדש g5qmt על node01 |
| 13-traffic-after-pod-delete.txt | תעבורה ממשיכה לעבוד לאחר מחיקת Pod |
| 14-clusterip-before-service-recreate.txt | ClusterIP המקורי: 10.102.65.208 |
| 15-nodeport-before-recreate.txt | nodePort לפני מחיקה: 30007 |
| 16-clusterip-changed-nodeport-stable.txt | ClusterIP חדש: 10.108.180.84, nodePort: 30007 (יציב) |
| 17-nodeport-after-recreate.txt | `kubectl get svc` אחרי שחזור Service |
| 18-traffic-after-service-recreate.txt | תעבורה ממשיכה לעבוד אחרי שחזור Service |
| 19-nodeport-final-describe.txt | `kubectl describe svc color-api-nodeport` — Endpoints, ExternalTrafficPolicy |
| 20-lab-conclusion.txt | סיכום תצפיות הלאב |
| 21-final-file-list.txt | `ls -la` — רשימת קבצים סופית בתיקיית הלאב |
| 22-cleanup.txt | `kubectl delete -f .` — מחיקת כל משאבי הלאב |
| 23-after-cleanup-get-all.txt | `kubectl get all` — רק service/kubernetes נותר |

> הקבצים נלכדו ב-Killercoda ולא הועתקו למחשב המקומי.
