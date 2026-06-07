# Commands - ReplicaSets and Deployments

> פקודות מ-Series 5: Labs 5.0-5.3

---

## ReplicaSet Commands

```bash
# רשימת כל ReplicaSets
kubectl get rs

# בדיקת ReplicaSet ספציפי
kubectl get rs nginx-replicaset

# פרטים מלאים - StrategyType, Events, Pods
kubectl describe rs nginx-replicaset

# מחיקת ReplicaSet (ואת ה-Pods שבבעלותו)
kubectl delete -f nginx-rs.yaml

# הצגת labels על ReplicaSet
kubectl get rs nginx-replicaset --show-labels
```

---

## Pod Inspection Commands

```bash
# Pods לפי label
kubectl get pods -l app=nginx

# Pods עם IP ו-Node
kubectl get pods -l app=nginx -o wide

# הצגת labels על Pods
kubectl get pods --show-labels

# הצגת labels על Pod ספציפי
kubectl get pod nginx-deployment-85bc587484-x7kln --show-labels

# YAML מלא של Pod - כולל labels ו-ownerReferences
kubectl get pod nginx-deployment-85bc587484-x7kln -o yaml

# מחיקת Pod ידנית
kubectl delete pod nginx-replicaset-hm4tp
```

---

## JSONPath Commands

```bash
# שם כל Pod + image שרצה בו
kubectl get pods -l app=nginx -o jsonpath='{range .items[*]}{.metadata.name}{" -> "}{.spec.containers[0].image}{"\n"}{end}'

# שם כל Pod + ownerReferences (מי הבעלים)
kubectl get pods -l app=nginx -o jsonpath='{range .items[*]}{.metadata.name}{" -> "}{.metadata.ownerReferences[0].kind}{"/"}{.metadata.ownerReferences[0].name}{"\n"}{end}'
```

JSONPath מאפשר לשלוף שדות ספציפיים מ-JSON response ולפרמט אותם. `{range .items[*]}` עובר על כל הפריטים ברשימה.

---

## Events Commands

```bash
# כל events ממוינים לפי זמן
kubectl get events --sort-by=.metadata.creationTimestamp

# events אחרונים בלבד
kubectl get events --sort-by=.metadata.creationTimestamp | tail -20
```

Events מראים מה עשה Kubernetes - Scaled up, Scaled down, SuccessfulDelete, SuccessfulCreate. שימושי לבדיקה שה-ReplicaSet אמנם פעל.

---

## Deployment Commands

```bash
# רשימת Deployments
kubectl get deploy

# פרטים מלאים - Strategy, maxSurge, maxUnavailable, Events, ReplicaSet name
kubectl describe deployment nginx-deployment

# מחיקת Deployment (ואת ה-RS ו-Pods שלו)
kubectl delete -f nginx-deploy.yaml

# watch - בדיקת rollout חי
kubectl rollout status deployment/nginx-deployment
```

---

## Describe Commands

```bash
# פרטים מלאים על Deployment
kubectl describe deployment nginx-deployment

# פרטים מלאים על ReplicaSet
kubectl describe rs nginx-deployment-85bc587484

# פרטים מלאים על Pod
kubectl describe pod nginx-deployment-85bc587484-x7kln
```

`kubectl describe` מראה Events שלא מופיעים ב-`kubectl get`. תמיד להפעיל כשמשהו לא עובד.

---

## Cleanup Commands

```bash
# מחיקת ReplicaSet לפי קובץ
kubectl delete -f nginx-rs.yaml

# מחיקת Pod ידני לפי קובץ
kubectl delete -f nginx-pod.yaml

# מחיקת Deployment לפי קובץ
kubectl delete -f nginx-deploy.yaml

# מחיקת ReplicaSet לפי שם
kubectl delete rs nginx-replicaset

# מחיקת Pod לפי שם
kubectl delete pod solo-nginx

# אימות שהמשאב נמחק
kubectl get rs nginx-replicaset
# Error from server (NotFound): replicasets.apps "nginx-replicaset" not found
```

---

## Manifest Authoring

```bash
# יצירת קובץ חדש
touch nginx-rs.yaml

# עריכה ב-nano
nano nginx-rs.yaml

# כתיבה מ-terminal בלי עורך - overwrite נקי
cat > nginx-rs.yaml <<'EOF'
apiVersion: apps/v1
kind: ReplicaSet
...
EOF

# שינוי image בשורת הפקודה
sed -i 's#image: nginx:1.27#image: nginx:1.27.0-alpine#' nginx-rs.yaml

# אימות השינוי
grep image nginx-rs.yaml

# בדיקת תוכן הקובץ
cat nginx-rs.yaml
```

> heredoc (`<<'EOF'`) עובד ב-Bash. ב-PowerShell להשתמש בעורך טקסט או בדרך אחרת.

---

## File and Directory Commands

```bash
# בדיקת תיקייה נוכחית
pwd

# רשימת קבצים עם פרטים
ls -l

# יצירת תיקייה
mkdir deployments
```
