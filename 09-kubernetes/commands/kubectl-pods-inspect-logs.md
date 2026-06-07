# kubectl - Pods, Inspect, Logs

> Commands covered in Day 03 - Hands-On 3.2

---

| פקודה | מטרה | Context | הערות |
|-------|------|---------|-------|
| `kubectl run nginx --image=nginx:1.27.0` | יצירת Pod עצמאי | Host PowerShell | Pod מנוהל ישירות, אין controller |
| `kubectl get pods` | סטטוס מהיר | Host PowerShell | |
| `kubectl get pods -o wide` | סטטוס עם IP ו-Node | Host PowerShell | שימושי לדיבוג רשת |
| `kubectl describe pod nginx` | inspect מלא | Host PowerShell | כולל Events |
| `curl.exe --max-time 5 http://10.244.0.5` | ניסיון גישה ל-Pod IP | Host PowerShell | צפוי timeout ב-minikube |
| `kubectl run alpine -it --image=alpine:3.20 -- sh` | Pod אינטראקטיבי | Host PowerShell | `-it` = interactive terminal |
| `apk update` | עדכון package index | Inside Alpine Pod | |
| `apk add curl` | התקנת curl | Inside Alpine Pod | |
| `curl 10.244.0.5` | בדיקת Pod-to-Pod לפי IP | Inside Alpine Pod | עובד |
| `curl nginx` | בדיקת DNS by name | Inside Alpine Pod | נכשל ללא Service |
| `exit` | יציאה מה-shell | Inside Alpine Pod | |
| `kubectl logs nginx` | קריאת לוגים | Host PowerShell | |
| `kubectl logs <pod> -c <container>` | לוגים מ-container ספציפי | Host PowerShell | ל-multi-container Pods |
| `kubectl delete pod alpine` | מחיקת Pod | Host PowerShell | |
| `kubectl delete pod alpine --ignore-not-found` | מחיקה בטוחה | Host PowerShell | לא נכשל אם לא קיים |
| `minikube status` | בדיקת cluster | Host PowerShell | |
| `docker ps --no-trunc --filter "id=<id>"` | זיהוי container | Host PowerShell | לפני נגיעה ב-Docker |

---

## הערות

- כל הפקודות ב-Host PowerShell מניחות שה-context הוא `minikube`
- Inside Alpine Pod - הפקודות רצות בתוך `kubectl run alpine -it --image=alpine:3.20 -- sh`
- Pod IP משתנה בכל פעם שה-Pod נמחק ונוצר מחדש - לא להניח שהוא קבוע
