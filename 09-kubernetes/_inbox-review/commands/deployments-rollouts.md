# Commands - Deployments: Rollouts, Scaling, Debugging

> פקודות מ-Series 5: Labs 5.4-5.7

---

## Rollout Commands

```bash
# היסטוריית revisions
kubectl rollout history deployment/nginx-deployment

# YAML מלא של revision ספציפי
kubectl rollout history deployment/nginx-deployment --revision=2 -o yaml

# rollback ל-revision קודם
kubectl rollout undo deployment/nginx-deployment

# מצב rollout (מחכה עד גמר - Ctrl+C לסיום)
kubectl rollout status deployment/nginx-deployment

# עזרה על sub-commands
kubectl rollout --help
```

---

## Scale Commands

```bash
# scale down
kubectl scale deployment/nginx-deployment --replicas=3

# scale to zero (restart pattern)
kubectl scale deployment/nginx-deployment --replicas=0

# scale back up
kubectl scale deployment/nginx-deployment --replicas=5
```

scale משנה קלאסטר בלבד. `kubectl apply` מחזיר לmatch ל-YAML.

---

## Diff and Apply Workflow

```bash
# בדיקת הבדלים לפני כל apply
kubectl diff -f nginx-deploy.yaml

# apply state מוצהר
kubectl apply -f nginx-deploy.yaml
```

תמיד `diff` לפני `apply`. זה לא אופציונלי.

---

## Watch Commands

```bash
# מעקב חי אחרי Pods (Terminal 1)
kubectl get pods --watch

# מעקב חי אחרי ReplicaSets (Terminal 2)
kubectl get rs --watch

# apply ו-rollout (Terminal 3)
kubectl apply -f nginx-deploy.yaml
```

watch הוא streaming. Ctrl+C לסיום.

---

## Pod Debugging - Image Pull Errors

```bash
# בדיקת image ב-Pod ספציפי
kubectl describe pod nginx-deployment-7864f464cb-8rfb7 | grep Image

# מציאת Pod כושל ו-describe
BADPOD=$(kubectl get pods -l app=nginx --no-headers | awk '$3=="ImagePullBackOff" || $3=="ErrImagePull" {print $1; exit}'); kubectl describe pod "$BADPOD"

# describe מלא על Pod
kubectl describe pod nginx-deployment-7bc864cc88-4zh2z
```

Events ב-`kubectl describe pod` הם המקום הראשון לחפש כשimage לא עולה.

---

## Annotation Commands

```bash
# annotation declarative - מוסיפים ל-YAML תחת metadata
# annotations:
#   kubernetes.io/change-cause: "Update nginx to tag 1.27.0-alpine"

# annotation imperative - ישירות על הקלאסטר
kubectl annotate deployment/nginx-deployment \
  kubernetes.io/change-cause="Update nginx to tag 1.27.1-alpine" \
  --overwrite

# אימות annotation
kubectl describe deployment nginx-deployment | grep change-cause
kubectl rollout history deployment/nginx-deployment
```

annotation imperative לא משנה את ה-YAML. הוא עלול לסחוף מה-YAML אחרי apply הבא.

---

## YAML Inspection and Edit

```bash
# בדיקת image ב-YAML
grep -n "image:" nginx-deploy.yaml

# בדיקת annotation ו-image ביחד
grep -n "change-cause\|image:" nginx-deploy.yaml

# עריכת image בשורת הפקודה
perl -pi -e 's/image: nginx:1\.27\.0-alpine/image: nginx:1.27.1-alpine/' nginx-deploy.yaml

# תיקון typo כפול (לדוגמה: alpine-alpine)
perl -pi -e 's/nginx:1\.27\.0-alpine-alpine/nginx:1.27.0-alpine/g' nginx-deploy.yaml

# תיקון tag שגוי (חסר מינוס)
perl -pi -e 's/image: nginx:1\.27\.1alpine/image: nginx:1.27.1-alpine/' nginx-deploy.yaml
```

---

## Deployment Inspection

```bash
# רשימה קצרה
kubectl get deploy

# Deployment ספציפי
kubectl get deploy nginx-deployment

# פרטים מלאים - Strategy, ReplicaSets, Events, annotations
kubectl describe deployment nginx-deployment

# ReplicaSets
kubectl get rs
```

---

## Cleanup Commands

```bash
# מחיקת Deployment לפי YAML (מוחק גם RS ו-Pods)
kubectl delete -f nginx-deploy.yaml

# אימות cleanup
kubectl get deploy
kubectl get rs
kubectl get pods
```
