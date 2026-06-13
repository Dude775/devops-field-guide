# Hands-On 6.5 - NodePort מלא ב-Linux Killercoda

> **Status**: done
> **Environment**: Killercoda browser playground (Ubuntu 24.04.4 LTS, Kubernetes v1.35.1)
> **Cluster**: 2 nodes — controlplane + node01

---

## Goal

לחזור על תרגיל NodePort מ-6.4, הפעם בסביבת Linux אמיתית ב-Killercoda במקום Windows Minikube.
ההבדל המרכזי: גישה ישירה דרך `<NodeIP>:<NodePort>` ללא tunnel של minikube.

מטרות:
- לאמת סביבת Linux
- ליצור Deployment עם 5 replicas
- ליצור NodePort Service על פורט 30007
- לגשת לאפליקציה ישירות דרך Node Internal IP
- לוודא load balancing בין Pods
- לוודא שתעבורה יכולה לעבור בין Nodes
- להשוות Node Internal IP / ClusterIP / NodePort
- למחוק Pod ולוודא שהתעבורה ממשיכה
- למחוק ולשחזר את ה-Service ולוודא שה-ClusterIP משתנה בעוד ה-nodePort נשאר יציב
- ניקוי משאבים

---

## Environment

```
OS: Ubuntu 24.04.4 LTS
Kubernetes version: v1.35.1
Container runtime: containerd://2.2.1

Nodes:
NAME           ROLE            INTERNAL-IP
controlplane   control-plane   172.30.1.2
node01         worker          172.30.2.2
```

---

## Files

```
manifests/
  color-api-deployment.yaml   — Deployment, 5 replicas, image lironefitoussi/color-api:1.1.0
  color-api-nodeport.yaml     — NodePort Service, port 80 → nodePort 30007
outputs/
  README.md                   — רשימת פלטים שנלכדו במהלך הלאב
images/
  README.md                   — רשימת screenshots מתוכננים
```

---

## Commands

```bash
# אימות סביבה
cat /etc/os-release

# הכנת תיקיות
mkdir -p services/hands-on-6.5-nodeport-linux-killercoda/{outputs,images}
cd services/hands-on-6.5-nodeport-linux-killercoda

# deploy
kubectl apply -f .

# בדיקת מצב
kubectl get pods -o wide
kubectl get svc
kubectl get nodes -o wide

# גישה דרך Node IP
NODE_IP=$(kubectl get node controlplane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
curl -s "http://$NODE_IP:30007/api"

# בדיקת load balancing
for i in 1 2 3 4 5 6 7 8 9 10; do curl -s "http://$NODE_IP:30007/api"; echo; done

# גישה דרך node01 (cross-node)
NODE2_IP=$(kubectl get node node01 -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
for i in 1 2 3 4 5 6 7 8 9 10; do curl -s "http://$NODE2_IP:30007/api"; echo; done

# מחיקת Pod
kubectl delete pod <pod-name>
kubectl get pods -l app=color-api -o wide
kubectl get svc color-api-nodeport -o wide

# מחיקה ושחזור Service
kubectl delete svc color-api-nodeport
kubectl apply -f color-api-nodeport.yaml
kubectl describe svc color-api-nodeport

# ניקוי
kubectl delete -f .
kubectl get all
```

---

## Key Observations

### NodePort behavior

NodePort יוצר:
1. ClusterIP פנימי — לתקשורת בין Pods ו-Services בתוך הקלאסטר
2. חשיפה חיצונית על **כל** Node דרך ה-nodePort המוגדר

גישה ישירה בלאב:
```
http://172.30.1.2:30007/api
```

### ClusterIP vs Node IP

| סוג | כתובת | נגישות |
|-----|--------|---------|
| ClusterIP | 10.102.65.208 | פנימי בקלאסטר בלבד |
| NodePort | 172.30.1.2:30007 | נגיש מחוץ לקלאסטר |

### Cross-node routing

גם כשפונים ל-IP של controlplane (172.30.1.2), Kubernetes יכול לנתב את התעבורה ל-Pods שרצים על node01.
זה קורה כי **External Traffic Policy** הוגדר כ-`Cluster` (ברירת מחדל).

### Load balancing output

```
COLOR: blue, HOSTNAME: color-api-deployment-7dd66bdc46-b9jpn
COLOR: blue, HOSTNAME: color-api-deployment-7dd66bdc46-6kjqk
COLOR: blue, HOSTNAME: color-api-deployment-7dd66bdc46-pb6h9
COLOR: blue, HOSTNAME: color-api-deployment-7dd66bdc46-fzvgc
COLOR: blue, HOSTNAME: color-api-deployment-7dd66bdc46-c2dwm
```

---

## Pod Deletion Test

מחקנו Pod אחד. Kubernetes יצר Pod חדש מיד:
```
NAME: color-api-deployment-7dd66bdc46-g5qmt
IP:   192.168.1.27
NODE: node01
```

תעבורה המשיכה לעבוד ללא הפרעה — ה-Service ניתב לכל ה-Pods הזמינים:
```
COLOR: blue, HOSTNAME: color-api-deployment-7dd66bdc46-pb6h9
COLOR: blue, HOSTNAME: color-api-deployment-7dd66bdc46-fzvgc
COLOR: blue, HOSTNAME: color-api-deployment-7dd66bdc46-g5qmt
COLOR: blue, HOSTNAME: color-api-deployment-7dd66bdc46-b9jpn
```

---

## Service Deletion/Recreation Test

אחרי מחיקת ה-Service ויצירתו מחדש:

| פרמטר | לפני | אחרי |
|-------|------|------|
| ClusterIP | 10.102.65.208 | 10.108.180.84 |
| nodePort | 30007 | 30007 |

**מסקנה**: ClusterIP הוא ephemeral ומשתנה בכל יצירה מחדש. nodePort נשאר יציב כי הוגדר במניפסט.

### Service describe — אחרי שחזור

```
Name:                     color-api-nodeport
Type:                     NodePort
IP:                       10.108.180.84
NodePort:                 30007/TCP
Endpoints:                192.168.0.244:80,192.168.1.241:80,192.168.1.179:80 + 2 more...
External Traffic Policy:  Cluster
Internal Traffic Policy:  Cluster
```

---

## Cleanup

```bash
kubectl delete -f .
# deployment.apps "color-api-deployment" deleted
# service "color-api-nodeport" deleted

kubectl get all
# Only service/kubernetes remained
```

---

## Service Types Comparison

| Type | Access | Use Case |
|------|--------|----------|
| ClusterIP | Internal only | Service-to-service communication |
| NodePort | NodeIP:NodePort | Dev/test, direct access |
| LoadBalancer | External cloud IP | Production in cloud environments |

---

## Conclusion

הלאב הוכיח שהמנגנון של NodePort עובד בדיוק אותו דבר בסביבת Linux אמיתית.
היתרון על פני Windows Minikube: אין צורך ב-tunnel — גישה ישירה ל-NodeIP:30007.
ה-External Traffic Policy: Cluster מאפשר ל-Kubernetes לנתב תעבורה לכל Pod בכל Node, גם אם הפנייה היתה ל-Node אחר.

---

## Screenshot Plan

ראה [images/README.md](./images/README.md)
