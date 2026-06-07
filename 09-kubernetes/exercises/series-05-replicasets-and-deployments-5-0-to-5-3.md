# Series 5 - ReplicaSets and Deployments: Labs 5.0 to 5.3

> **Date**: 2026-06-07
> **Module**: 09 - Kubernetes
> **Status**: Complete - Labs 5.0, 5.1, 5.2, 5.3

---

## הקשר

סדרה זו מכסה את ReplicaSet ואת Deployment בצורה מעשית. Lab 5.0 ו-5.1 הם חזרה מאורגנת מחדש על נושאים שכבר נגענו בהם קודם, אבל הפעם בצורה שיטתית יותר עם תרגולי command-line מלאים. Lab 5.2 הוא תרגיל חדש שבוחן מה קורה כשיש Pod ידני עם label שתואמת ל-selector של ReplicaSet. Lab 5.3 פותח את Deployment לראשונה ומחבר את כל השכבות - Deployment, ReplicaSet, ו-Pods.

---

## Lab 5.0 - יצירה וניהול של ReplicaSet

### מה תרגלנו

יצירת ReplicaSet בסיסי, אימות שהוא מנהל את הכמות הנכונה של Pods, ובדיקת self-healing.

### הקובץ שנוצר: nginx-rs.yaml

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-replicaset
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.27
```

### פקודות Lab 5.0

| פקודה | מה היא עושה |
|-------|------------|
| `touch nginx-rs.yaml` | יצירת קובץ ריק |
| `nano nginx-rs.yaml` | עריכת הקובץ |
| `kubectl apply -f nginx-rs.yaml` | יצירת ReplicaSet בקלאסטר |
| `kubectl get rs` | רשימת כל ReplicaSets |
| `kubectl get rs nginx-replicaset` | בדיקת ReplicaSet ספציפי |
| `kubectl get pods -l app=nginx -o wide` | בדיקת Pods עם label ספציפי |
| `kubectl delete pod <real-pod-name>` | מחיקת Pod ידנית לבדיקת self-healing |
| `kubectl delete -f nginx-rs.yaml` | מחיקת ReplicaSet (ואת ה-Pods שלו) |

### פלט לדוגמה - kubectl get rs

```
NAME               DESIRED   CURRENT   READY   AGE
nginx-replicaset   3         3         3       63s
```

### פלט לדוגמה - kubectl get pods -l app=nginx -o wide

```
NAME                     READY   STATUS    RESTARTS   AGE   IP           NODE
nginx-replicaset-hm4tp   1/1     Running   0          63s   10.244.0.5   minikube
nginx-replicaset-kbx92   1/1     Running   0          63s   10.244.0.6   minikube
nginx-replicaset-9tprd   1/1     Running   0          63s   10.244.0.7   minikube
```

### מה קרה לאחר מחיקת Pod ידנית

מחקנו Pod אחד. תוך שנייה-שתיים Kubernetes יצר Pod חדש כדי לחזור ל-3.

```
NAME                     READY   STATUS    RESTARTS   AGE
nginx-replicaset-z4hsn   1/1     Running   0          4s    <- חדש
nginx-replicaset-kbx92   1/1     Running   0          2m
nginx-replicaset-9tprd   1/1     Running   0          2m
```

### מצב לאחר Lab 5.0

ReplicaSet נמחק עם `kubectl delete -f nginx-rs.yaml`. לא נשארו Pods.

```
Error from server (NotFound): replicasets.apps "nginx-replicaset" not found
```

### לקח מרכזי

ReplicaSet הוא reconciliation loop - לא יצירה חד-פעמית. הוא בודק ברציפות: כמה Pods יש? כמה צריכים להיות? ומגיב בהתאם.

---

## ASCII Diagram - לוגיקת ה-reconciliation של ReplicaSet

```
desired replicas: 3
        |
        v
ReplicaSet selector: app=nginx
        |
        v
count matching Pods
        |
        +-- less than 3 -> create Pods from template
        |
        +-- exactly 3   -> do nothing
        |
        +-- more than 3 -> delete extra matching Pods
```

---

## Lab 5.1 - עדכון Image ב-ReplicaSet והבנת המגבלות

### מה תרגלנו

שינוי ה-image ב-manifest של ReplicaSet ואישור שה-Pods הקיימים לא מתעדכנים - רק Pods חדשים שייווצרו בעתיד ישתמשו ב-image החדשה.

### שלב 1 - יצירה מחדש של ReplicaSet עם nginx:1.27

```bash
kubectl apply -f nginx-rs.yaml
# image: nginx:1.27
```

אימות שה-Pods רצים עם nginx:1.27:

```bash
kubectl get pods -l app=nginx -o jsonpath='{range .items[*]}{.metadata.name}{" -> "}{.spec.containers[0].image}{"\n"}{end}'
```

פלט:
```
nginx-replicaset-hm4tp -> nginx:1.27
nginx-replicaset-kbx92 -> nginx:1.27
nginx-replicaset-9tprd -> nginx:1.27
```

### שלב 2 - שינוי ה-image ב-manifest

```bash
sed -i 's#image: nginx:1.27#image: nginx:1.27.0-alpine#' nginx-rs.yaml
grep image nginx-rs.yaml
# image: nginx:1.27.0-alpine
```

### שלב 3 - apply ובדיקה

```bash
kubectl apply -f nginx-rs.yaml
# replicaset.apps/nginx-replicaset configured
```

בדיקה מה רץ בפועל:

```bash
kubectl get pods -l app=nginx -o jsonpath='{range .items[*]}{.metadata.name}{" -> "}{.spec.containers[0].image}{"\n"}{end}'
```

פלט - **הבעיה מתגלה**:
```
nginx-replicaset-hm4tp -> nginx:1.27     <- לא השתנה
nginx-replicaset-kbx92 -> nginx:1.27     <- לא השתנה
nginx-replicaset-9tprd -> nginx:1.27     <- לא השתנה
```

### שלב 4 - מחיקת Pod ידנית לאימות

מחקנו Pod אחד. ReplicaSet יצר Pod חדש מה-template המעודכן:

```bash
kubectl get pods -l app=nginx -o jsonpath='{range .items[*]}{.metadata.name}{" -> "}{.spec.containers[0].image}{"\n"}{end}'
```

פלט - **מצב מעורב**:
```
nginx-replicaset-z4hsn -> nginx:1.27.0-alpine  <- Pod חדש עם image חדשה
nginx-replicaset-kbx92 -> nginx:1.27            <- ישן
nginx-replicaset-9tprd -> nginx:1.27            <- ישן
```

### פקודות Lab 5.1

| פקודה | מה היא עושה |
|-------|------------|
| `kubectl apply -f nginx-rs.yaml` | עדכון manifest בקלאסטר |
| `sed -i 's#old#new#' nginx-rs.yaml` | החלפת image בקובץ בשורת הפקודה |
| `grep image nginx-rs.yaml` | אימות שהקובץ עודכן |
| `kubectl get pods -l app=nginx -o jsonpath=...` | בדיקת ה-image בפועל בכל Pod |

### מצב לאחר Lab 5.1

ניקוי - נמחקו ה-ReplicaSet וה-Pods.

### לקח מרכזי

שינוי template ב-ReplicaSet משפיע רק על Pods שייווצרו מעתה. Pods קיימים ממשיכים לרוץ עם ה-image הישנה. ReplicaSet לא יודע ולא אכפת לו מה רץ בתוך Pod - הוא רק סופר.

---

## Lab 5.2 - התנהגות ReplicaSet כאשר נוצרים Pods תואמים ל-Selector

### מה תרגלנו

מה קורה כשיש Pod ידני עם label שתואמת ל-selector של ReplicaSet? שני תרחישים.

### הקבצים שנוצרו

**nginx-pod.yaml:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: solo-nginx
  labels:
    app: nginx
spec:
  containers:
    - name: nginx
      image: nginx:1.27.0
      ports:
        - containerPort: 80
```

**nginx-rs.yaml** - ReplicaSet עם `replicas: 3` ו-selector `app: nginx`.

---

### Scenario A - ReplicaSet קיים + הוספת Pod ידני

```bash
# יצירת ReplicaSet תחילה
kubectl apply -f nginx-rs.yaml
# ReplicaSet יוצר 3 Pods

# הוספת Pod ידני עם label תואמת
kubectl apply -f nginx-pod.yaml
```

**מה קרה:**
- solo-nginx נוצר, עכשיו יש 4 Pods עם `app: nginx`
- ReplicaSet זיהה שיש יותר מ-3 Pods שתואמים ל-selector שלו
- ReplicaSet **מחק את solo-nginx** כדי לחזור ל-3

**הוכחה בלוג events:**
```
kubectl get events --sort-by=.metadata.creationTimestamp | tail -20
```

```
Event:  SuccessfulDelete  replicaset/nginx-replicaset  Deleted pod: solo-nginx
```

---

### Scenario B - Pod ידני קיים + יצירת ReplicaSet לאחר מכן

```bash
# יצירת ReplicaSet, מחיקה
kubectl delete -f nginx-rs.yaml

# יצירת Pod הידני תחילה
kubectl apply -f nginx-pod.yaml
# solo-nginx רץ לבד

# עכשיו יצירת ReplicaSet
kubectl apply -f nginx-rs.yaml
```

**מה קרה:**
- ReplicaSet ראה ש-solo-nginx כבר קיים עם `app: nginx`
- ReplicaSet אימץ אותו (adopt) - solo-nginx הפך לחלק מהסט
- ReplicaSet יצר רק 2 Pods נוספים (לא 3) כי solo-nginx כבר נספר

**אימות ownership:**
```bash
kubectl get pods -l app=nginx -o jsonpath='{range .items[*]}{.metadata.name}{" -> "}{.metadata.ownerReferences[0].kind}{"/"}{.metadata.ownerReferences[0].name}{"\n"}{end}'
```

פלט:
```
nginx-replicaset-abc12 -> ReplicaSet/nginx-replicaset
nginx-replicaset-def34 -> ReplicaSet/nginx-replicaset
solo-nginx             -> ReplicaSet/nginx-replicaset  <- אומץ!
```

**מחיקת solo-nginx:**
```bash
kubectl delete pod solo-nginx
```

ReplicaSet זיהה ירידה ל-2 ויצר Pod חדש מה-template שלו.

### פקודות Lab 5.2

| פקודה | מה היא עושה |
|-------|------------|
| `touch nginx-pod.yaml` | יצירת קובץ Pod ידני |
| `kubectl apply -f nginx-pod.yaml` | יצירת Pod ידני |
| `kubectl get events --sort-by=.metadata.creationTimestamp \| tail -20` | בדיקת events אחרונים בסדר זמני |
| `kubectl get pods -l app=nginx -o jsonpath=...ownerReferences...` | בדיקת מי הבעלים של כל Pod |

### מצב לאחר Lab 5.2

ניקוי - נמחקו ה-ReplicaSet וה-Pods.

### לקח מרכזי

ReplicaSet סופר כל Pod שתואם ל-selector שלו - לא רק Pods שהוא יצר. הוא יכול לאמץ Pods קיימים ויכול למחוק Pods עודפים. לא לערבב Pods ידניים עם ReplicaSet על אותם labels.

---

## Lab 5.3 - יצירה וחקירה של Deployment ב-Kubernetes

### מה תרגלנו

יצירת Deployment ראשון, אימות שהוא יצר ReplicaSet אוטומטית, וחקירת הקשר בין Deployment, ReplicaSet, ו-Pods דרך pod-template-hash.

### הכנות

```bash
mkdir deployments
cd deployments
touch nginx-deploy.yaml
```

לפני ה-apply, בדקנו את מצב הקלאסטר:

```bash
kubectl get pods
```

היו Pods לא קשורים: `color-api-deployment-...` ו-`rogue-pod`. לא ניקינו אותם כי ה-lab רק ביקש להיות מודעים.

### הקובץ nginx-deploy.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 5
  selector:
    matchLabels:
      app: nginx
  strategy:
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.27.0
          ports:
            - containerPort: 80
```

**הערה**: `metadata.labels` ברמת ה-Deployment עצמו הוא label על האובייקט - לא ה-selector. ה-selector הוא `spec.selector.matchLabels` ורק הוא קובע אילו Pods שייכים ל-Deployment.

### Apply ואימות

```bash
kubectl apply -f nginx-deploy.yaml
# deployment.apps/nginx-deployment created
```

```bash
kubectl get deploy
```

```
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   5/5     5            5           30s
```

### בדיקת describe

```bash
kubectl describe deployment nginx-deployment
```

פלט רלוונטי:
```
StrategyType:           RollingUpdate
RollingUpdateStrategy:  25% max unavailable, 25% max surge
NewReplicaSet:          nginx-deployment-85bc587484 (5/5 replicas created)

Events:
  Scaled up replica set nginx-deployment-85bc587484 from 0 to 5
```

### אימות ReplicaSet שנוצר

```bash
kubectl get rs
```

```
NAME                          DESIRED   CURRENT   READY   AGE
nginx-deployment-85bc587484   5         5         5       45s
```

### אימות Pods - שמות מכילים את ה-hash

```bash
kubectl get pods
```

```
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-85bc587484-x7kln   1/1     Running   0          50s
nginx-deployment-85bc587484-p2msv   1/1     Running   0          50s
nginx-deployment-85bc587484-qrt9b   1/1     Running   0          50s
nginx-deployment-85bc587484-wkj4n   1/1     Running   0          50s
nginx-deployment-85bc587484-zhs8m   1/1     Running   0          50s
```

### חקירת Pod YAML

```bash
kubectl get pod nginx-deployment-85bc587484-x7kln -o yaml
```

Labels על ה-Pod:
```yaml
labels:
  app: nginx
  pod-template-hash: 85bc587484
```

ownerReferences:
```yaml
ownerReferences:
  - apiVersion: apps/v1
    kind: ReplicaSet
    name: nginx-deployment-85bc587484
```

### חקירת ReplicaSet - labels ו-ownership

```bash
kubectl get rs nginx-deployment-85bc587484 --show-labels
```

```
NAME                          ...   LABELS
nginx-deployment-85bc587484   ...   app=nginx,pod-template-hash=85bc587484
```

```bash
kubectl describe rs nginx-deployment-85bc587484
```

```
Controlled By:  Deployment/nginx-deployment
```

### פקודות Lab 5.3

| פקודה | מה היא עושה |
|-------|------------|
| `mkdir deployments` | יצירת תיקיית עבודה |
| `touch nginx-deploy.yaml` | יצירת קובץ Deployment |
| `kubectl get pods` | בדיקת מצב קלאסטר לפני apply |
| `kubectl apply -f nginx-deploy.yaml` | יצירת Deployment |
| `kubectl get deploy` | רשימת Deployments |
| `kubectl describe deployment nginx-deployment` | פרטים מלאים - Strategy, Events, RS |
| `kubectl get rs` | אימות ש-Deployment יצר ReplicaSet |
| `kubectl get pod <pod-name> -o yaml` | YAML מלא של Pod כולל labels ו-ownerReferences |
| `kubectl get pod <pod-name> --show-labels` | הצגת labels בלבד |
| `kubectl get rs <rs-name> --show-labels` | הצגת labels על ReplicaSet |
| `kubectl describe rs <rs-name>` | פרטים מלאים - Controlled By, Events |
| `pwd` | אימות תיקייה נוכחית |
| `ls -l` | רשימת קבצים בתיקייה |

### מצב לאחר Lab 5.3

**לא בוצע ניקוי** - Lab 5.3 לא כלל הוראות cleanup. ה-Deployment נשאר פעיל.

### לקח מרכזי

Deployment יוצר ומנהל ReplicaSets. ה-pod-template-hash מקשר את כל שלוש השכבות: Deployment template - ReplicaSet name - Pod names. שינוי ב-template יגרום ל-hash חדש ול-ReplicaSet חדש.

---

## ASCII Diagram - היררכיית Deployment

```
Deployment
    |
    v
ReplicaSet
    |
    v
Pods
```

---

## ASCII Diagram - קשר ה-hash

```
Deployment template
    |
    v
pod-template-hash: 85bc587484
    |
    +--> ReplicaSet: nginx-deployment-85bc587484
    |
    +--> Pods: nginx-deployment-85bc587484-xxxxx
```

---

## טעויות וtיקונים

### kubectl delete pod עם < >

**טעות:** הקלדת הפקודה עם placeholder כמו שמופיע בתיעוד:
```bash
kubectl delete pod <pod-name>
```

**מה קרה:** Bash פירש את `<pod-name>` כ-redirection - ניסה לפתוח קובץ בשם `pod-name`. שגיאה: `bash: pod-name: No such file or directory`.

**תיקון:** להחליף את `<pod-name>` בשם האמיתי של ה-Pod:
```bash
kubectl delete pod nginx-replicaset-hm4tp
```

---

### .kubectl במקום kubectl

**טעות:**
```bash
.kubectl get rs nginx-replicaset
```

**מה קרה:** Bash ניסה להריץ קובץ בשם `.kubectl` בתיקייה הנוכחית. לא נמצא.

**תיקון:**
```bash
kubectl get rs nginx-replicaset
```

---

## Iron Rules

1. ReplicaSet הוא reconciliation loop - לא יצירה חד-פעמית
2. `replicas` הוא desired state - לא הוראה חד-פעמית
3. `selector` קובע אילו Pods נספרים
4. `template` קובע איך ייראו Pods חדשים
5. `selector.matchLabels` חייב להיות זהה ל-`template.metadata.labels`
6. ReplicaSet סופר כל Pod שתואם ל-selector - גם Pods ידניים
7. ReplicaSet יכול לאמץ Pods שנוצרו לפניו אם הם תואמים ל-selector
8. אל תערבב Pods ידניים עם ReplicaSet-managed Pods על אותם labels
9. שינוי template ב-ReplicaSet לא מעדכן Pods קיימים
10. ReplicaSet לא מבצע rolling updates
11. Deployment הוא ה-abstraction הרגיל מעל ReplicaSet
12. Deployment יוצר ומנהל ReplicaSets - לא נוגעים ב-RS ישירות
13. RollingUpdate הוא ה-strategy ברירת המחדל
14. pod-template-hash מקשר Deployment template, ReplicaSet, ו-Pods
15. שינוי template ב-Deployment יוצר ReplicaSet חדש עם hash חדש

---

## שאלות ראיון

**1. מה התפקיד של ReplicaSet ב-Kubernetes?**
ReplicaSet מוודא שתמיד יש מספר מסויים של Pods שרצים. הוא בודק ברציפות כמה Pods תואמים ל-selector שלו ומגיב לפי הצורך - יוצר אם חסרים, מוחק אם עודפים.

**2. מה ההבדל בין replicas, selector ו-template?**
- `replicas` - כמה Pods רוצים
- `selector` - מה הקריטריון לספור Pods קיימים
- `template` - מה ייראה Pod חדש שייווצר

**3. מה קורה אם Pod שתואם ל-selector של ReplicaSet נוצר ידנית?**
ReplicaSet יספור אותו. אם עכשיו יש יותר מ-desired count - ReplicaSet ימחק אחד מהם (כולל אולי את הידני).

**4. האם ReplicaSet יכול לאמץ Pods קיימים?**
כן. אם Pod קיים עם label שתואמת ל-selector, ReplicaSet יוסיף אותו לספירה שלו ויגדיר את עצמו כ-owner דרך ownerReferences.

**5. למה עיצוב selector רחב מדי הוא מסוכן?**
ReplicaSet ימחק Pods עודפים ללא אזהרה. אם selector תופס Pods שלא אמורים להיות תחתיו - הם ייעלמו.

**6. האם שינוי template ב-ReplicaSet מעדכן Pods קיימים?**
לא. רק Pods חדשים שייווצרו בעתיד ישתמשו ב-template המעודכן. Pods קיימים לא מושפעים.

**7. למה מעדיפים Deployments על ניהול ReplicaSets ישיר?**
Deployment מבצע rolling updates אוטומטיים, שומר היסטוריית גרסאות, ומאפשר rollback. ReplicaSet לא עושה אף אחד מאלה.

**8. מה מייצג pod-template-hash?**
hash של תוכן ה-Pod template. אם ה-template משתנה - ה-hash משתנה - Deployment יוצר ReplicaSet חדש. זה מה שמאפשר לקיים כמה ReplicaSets במקביל (ישן וחדש בזמן rolling update).

**9. איך Deployment יודע אילו Pods שייכים לאיזה ReplicaSet?**
דרך pod-template-hash label. כל Pod מקבל את ה-hash כ-label. כל ReplicaSet מחזיק pod-template-hash כ-label. Deployment מכיר את ה-hash של ה-template הנוכחי שלו.

**10. מה הם maxUnavailable ו-maxSurge ב-RollingUpdate?**
- `maxUnavailable` - כמה Pods מקסימום יכולים להיות לא זמינים בזמן update (ברירת מחדל 25%)
- `maxSurge` - כמה Pods מקסימום אפשר לייצור מעבר ל-desired count בזמן update (ברירת מחדל 25%)

---

## Screenshots to Add

| שם קובץ | מה להצלם |
|---------|----------|
| `09-kubernetes/resources/images/00-rs-three-pods-running.png` | פלט `kubectl get pods -l app=nginx -o wide` עם 3 Pods רצים |
| `09-kubernetes/resources/images/01-rs-image-change-no-rollout.png` | פלט jsonpath שמראה שה-image לא השתנה ב-Pods קיימים אחרי apply |
| `09-kubernetes/resources/images/02-rs-adopts-solo-pod.png` | פלט jsonpath של ownerReferences שמראה ש-solo-nginx אומץ ע"י ReplicaSet |
| `09-kubernetes/resources/images/03-deployment-created-rs.png` | פלט `kubectl get deploy` ו-`kubectl get rs` ביחד |
| `09-kubernetes/resources/images/04-pod-template-hash-labels.png` | פלט `kubectl get pod <name> -o yaml` שמראה labels עם pod-template-hash |
