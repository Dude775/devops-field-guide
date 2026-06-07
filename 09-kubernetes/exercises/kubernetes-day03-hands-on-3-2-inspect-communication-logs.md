# Hands-On 3.2 - Inspect, Communication and Logs עם kubectl

| שדה | ערך |
|-----|-----|
| Module | Kubernetes |
| Day | 03 |
| Lab | 3.2 |
| Environment | Windows PowerShell, minikube, Docker driver |
| Main objects | `nginx`, `alpine` |
| Status | mostly completed - DNS-by-name verification pending (curl nginx מ-Alpine לא הוכח) |

---

## מטרות הלאב

- להבין כיצד לבדוק Pod עם `kubectl get` ו-`kubectl describe`
- לבחון תקשורת בין Pods על ידי IP פנימי
- להבין למה Pod IP לא נגיש מ-Windows Host
- להוכיח תנועה דרך `kubectl logs`
- להבין את ההבדל בין Pod IP לבין DNS-by-name (דורש Service)

---

## Environment Snapshot

- kubectl client: v1.34.1
- kubectl server: v1.35.1
- minikube: v1.38.1
- context: minikube
- node: minikube, Ready, control-plane
- node IP: 192.168.49.2
- driver: Docker
- **חשוב: Docker Desktop חייב לרוץ כדי שה-cluster יעבוד**

---

## Command Flow

### שלב 1 - יצירת nginx Pod

```powershell
kubectl run nginx --image=nginx:1.27.0
```

יוצר Pod עצמאי בשם nginx עם nginx גרסה 1.27.0

### שלב 2 - בדיקה מהירה

```powershell
kubectl get pods
kubectl get pods -o wide
```

`-o wide` מוסיף עמודות: IP, NODE, NOMINATED NODE, READINESS GATES
נצפה IP: `10.244.0.5`

### שלב 3 - inspect מעמיק

```powershell
kubectl describe pod nginx
```

מציג: Namespace, Node, Pod IP, Image, Conditions, Events
Events שנצפו: Scheduled, Pulled, Created, Started

### שלב 4 - ניסיון גישה מ-Windows Host (צפוי להיכשל)

```powershell
curl.exe --max-time 5 http://10.244.0.5
```

תוצאה: timeout - Pod IP הוא internal לcluster, לא נגיש מ-Windows

### שלב 5 - יצירת Alpine Pod אינטראקטיבי

```powershell
kubectl run alpine -it --image=alpine:3.20 -- sh
```

פותח shell בתוך Pod חדש

### שלב 6 - התקנת curl בתוך Alpine

```sh
apk update
apk add curl
```

### שלב 7 - בדיקת Pod-to-Pod תקשורת לפי IP

```sh
curl 10.244.0.5
```

תוצאה: דף HTML של nginx - **הוכחה שתקשורת Pod-to-Pod לפי IP עובדת**

### שלב 8 - בדיקת DNS by name (PENDING VERIFICATION)

```sh
curl nginx
```

> **PENDING** - הפקודה הזו לא בוצעה מבפנים ב-Alpine. ראה פירוט בסעיף התיקון למטה.
> ציפייה ללא Service: `curl: (6) Could not resolve host: nginx`

### שלב 9 - יציאה מ-Alpine

```sh
exit
```

### שלב 10 - קריאת לוגים

```powershell
kubectl logs nginx
```

נצפה:

```
10.244.0.6 - - [03/Jun/2026:12:59:03 +0000] "GET / HTTP/1.1" 200 615 "-" "curl/8.14.1" "-"
```

**הוכחה**: Alpine (IP 10.244.0.6) פנתה ל-nginx (IP 10.244.0.5)

### שלב 11 - מחיקת Alpine

```powershell
kubectl delete pod alpine
```

### שלב 12 - בדיקה סופית

```powershell
kubectl get pods
```

נצפה: רק `nginx 1/1 Running 0`

---

## Evidence - ערכים שנצפו בפועל

| ערך | נצפה |
|-----|------|
| nginx Pod IP | 10.244.0.5 |
| alpine Pod IP | 10.244.0.6 |
| nginx status (סופי) | 1/1 Running |
| nginx log line | `10.244.0.6 - - [03/Jun/2026:12:59:03 +0000] "GET / HTTP/1.1" 200 615` |

---

## תיקון חשוב - PowerShell vs Alpine DNS

**הבעיה**: בשלב הבדיקה של DNS-by-name, הפקודה `curl nginx` הורצה מ-Windows PowerShell ולא מבפנים ב-Alpine Pod.

**מה נצפה ב-PowerShell**:

```
curl : The remote name could not be resolved: 'nginx'
```

**למה זה לא מספיק?** כי DNS context שונה:
- Windows PowerShell - DNS ברמת ה-host, אין לו מושג מה זה Kubernetes service names
- Alpine Pod - DNS של Kubernetes cluster, מחובר ל-CoreDNS שיודע על Services

**מה הלאב דורש**: להריץ `curl nginx` *מבפנים* ב-Alpine Pod.

**תוצאה צפויה ללא Service**:

```
curl: (6) Could not resolve host: nginx
```

**המסקנה הזהובה**:

> גישה לפי Pod IP עובדת מתוך ה-cluster, אבל גישה לפי שם דורשת Service כי Kubernetes מספק DNS יציב דרך Services, לא דרך Pods עצמאיים.

---

## ASCII Diagram

```
Windows Host
   |
   | curl 10.244.0.5 (curl.exe --max-time 5)
   v
timeout - Pod IP is internal to cluster

Inside cluster:
alpine Pod 10.244.0.6
   |
   | curl 10.244.0.5
   v
nginx Pod 10.244.0.5
   |
   v
HTTP 200 - Welcome to nginx

DNS test (PENDING from Alpine):
alpine Pod
   |
   | curl nginx
   v
expected: Could not resolve host (without Service)
```

---

## Iron Rules

1. **תמיד דע איפה הפקודה רצה** - host או Pod. DNS context שונה לחלוטין.
2. **Pod IP הוא לא endpoint ציבורי** - לא נגיש מחוץ ל-cluster
3. **Logs מוכיחים תנועה** - `kubectl logs` הוא הכלי לאימות
4. **שם Pod לא שווה Service Discovery** - Standalone Pod לא מקבל שם DNS יציב
5. **נהל Kubernetes objects עם kubectl** - אל תעצור containers ב-Docker ישירות

---

## Troubleshooting

### PowerShell continuation prompt

**בעיה**: הקלדת `Set-Location "kubectl get pods -o wide` פתחה `>>` prompt
**פתרון**: `Ctrl+C` ואז הפקודה הנכונה בנפרד:

```powershell
kubectl get pods -o wide
```

### TLS handshake timeout / cluster לא מגיב

```powershell
docker ps                       # בדוק Docker Desktop פועל
minikube status                 # בדוק מצב cluster
minikube start --driver=docker  # אם צריך להפעיל מחדש
```

### Container ID נראה מ-Docker

```powershell
docker ps --no-trunc --filter "id=<container-id>"
```

**לא** לעצור containers של Kubernetes ישירות. השתמש ב-`kubectl delete pod`.

---

## שאלות ראיון

**1. מה ההבדל בין `get` ל-`describe`?**
`get` - סקירה מהירה של סטטוס. `describe` - כל הפרטים: events, conditions, env vars, volumes.

**2. למה Pod אחד יכול להגיע ל-Pod אחר לפי IP?**
כל Pods ב-cluster חולקים רשת flat - כל Pod יכול לפנות ל-IP של Pod אחר ישירות.

**3. למה Windows Host לא יכול לגשת ל-Pod IP?**
Pod IP הוא internal לרשת הוירטואלית של minikube (192.168.49.x). Windows Host לא נמצא ברשת הזו.

**4. למה `curl nginx` נכשל ללא Service?**
Kubernetes DNS (CoreDNS) מרשם שמות ל-Services, לא ל-Pods עצמאיים. בלי Service אין DNS record ל-nginx.

**5. איך מוכיחים ש-nginx קיבל תנועה?**
`kubectl logs nginx` - בלוג נראה GET request עם IP המקור של Alpine Pod.

**6. מה פותר `kubectl logs -c`?**
ב-Pod עם כמה containers, מפרט מאיזה container לקרוא לוגים:

```powershell
kubectl logs <pod-name> -c <container-name>
```

**7. למה `docker stop` מסוכן ב-Kubernetes?**
Kubernetes לא יודע שעצרת container ישירות. ה-kubelet ינסה להפעיל מחדש. במקרה גרוע יותר תפריע ל-control plane components.

**8. מה תפקיד Events ב-debugging?**
Events מציגים את ה-timeline: Scheduled, Pulled, Created, Started. אם משהו נכשל (ImagePullBackOff, OOMKilled) - Events הם המקום הראשון לבדוק.

---

## Suggested Screenshots

צלם ושמור בתיקייה `09-kubernetes/resources/images/day03-hands-on-3-2/`:

- `00-pods-wide-nginx-alpine.png` - פלט `kubectl get pods -o wide` עם שני Pods פעילים
- `01-nginx-logs-curl-200.png` - פלט `kubectl logs nginx` עם שורת ה-200
- `02-final-nginx-only.png` - פלט סופי `kubectl get pods` עם nginx בלבד
- `03-powershell-curl-nginx-pitfall.png` - פלט השגיאה `curl nginx` מ-PowerShell
- `04-describe-pod-events.png` - חלק ה-Events מ-`kubectl describe pod nginx`
