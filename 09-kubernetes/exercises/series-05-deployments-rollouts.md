# Series 5 - Deployments: Rolling Updates, Rollouts, Scaling, Debugging - Labs 5.4 to 5.7

> **Date**: 2026-06-07
> **Module**: 09 - Kubernetes
> **Status**: Complete - Labs 5.4, 5.5, 5.6, 5.7

---

## סקירה

ארבעת ה-labs האלה הם המשך ישיר של Lab 5.3, שם יצרנו Deployment של nginx עם 5 replicas. כאן נבדוק מה קורה כשמחליפים image, איך rollout history עובד, מה ההבדל בין scale ידני לבין YAML declarative, ואיך מאבחנים rollout שנתקע בגלל image שגוי.

הסדרה הזאת היא הבסיס לעבוד עם Deployments בפועל. מי שמבין את הארבעה האלה מבין את ה-lifecycle של Deployment.

---

## מצב התחלתי מ-Lab 5.3

לפני שמתחילים, זה מה שהיה קיים:

```
תיקייה: deployments/
קובץ:   nginx-deploy.yaml
```

תוכן nginx-deploy.yaml:

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

מצב קלאסטר:

```
NAME               READY   UP-TO-DATE   AVAILABLE
nginx-deployment   5/5     5            5

ReplicaSet פעיל: nginx-deployment-85bc587484
Pods: nginx-deployment-85bc587484-xxxxx (5 בסך הכל)
```

---

## Lab 5.4 - Rolling Update

### מה תרגלנו

החלפת image ב-Deployment ומעקב חי אחרי rolling update. זה הפעם הראשונה שראינו Deployment יוצר ReplicaSet חדש ומוריד את הישן בהדרגה.

### שלב 1 - שינוי Image ב-YAML

שינינו את image מ-`nginx:1.27.0` ל-`nginx:1.27.0-alpine` ב-nginx-deploy.yaml.

### שלב 2 - בדיקה לפני apply

```bash
kubectl diff -f nginx-deploy.yaml
```

הפלט הראה שתי שורות שונות:
- `generation` השתנה מ-1 ל-2
- `image` השתנה מ-`nginx:1.27.0` ל-`nginx:1.27.0-alpine`

זה הרגל חשוב: לא לעשות apply בלי לראות מה הולך להשתנות.

### שלב 3 - הפעלת watch בשני terminals

```bash
# Terminal 1
kubectl get pods --watch

# Terminal 2
kubectl get rs --watch
```

שני watches בו-זמנית נותנים תמונה שלמה - אפשר לראות איך ReplicaSet חדש עולה בזמן שהישן יורד.

### שלב 4 - Apply

```bash
# Terminal 3
kubectl apply -f nginx-deploy.yaml
```

### מה ראיתי בפועל

ב-Terminal 1 (pods watch) ראיתי Pods חדשים נוצרים עם hash שונה:

```
nginx-deployment-85bc587484-xxxxx   Running -> Terminating
nginx-deployment-7864f464cb-xxxxx   Pending -> ContainerCreating -> Running
```

ב-Terminal 2 (rs watch) ראיתי את ה-ReplicaSets עוברים:

```
NAME                          DESIRED   CURRENT   READY
nginx-deployment-85bc587484   5         5         5    <- ReplicaSet ישן
nginx-deployment-7864f464cb   0         0         0    <- ReplicaSet חדש נוצר
nginx-deployment-7864f464cb   2         2         0
nginx-deployment-85bc587484   4         4         4
nginx-deployment-7864f464cb   2         2         2
nginx-deployment-85bc587484   3         3         3
nginx-deployment-7864f464cb   3         3         3
nginx-deployment-85bc587484   1         1         1
nginx-deployment-7864f464cb   5         5         5
nginx-deployment-85bc587484   0         0         0    <- ישן ב-0
```

### מה זה מוכיח

Deployment לא מחליף Pods בבת אחת. הוא מעלה ReplicaSet חדש בהדרגה ומוריד את הישן במקביל. בשום רגע לא כל ה-Pods למטה.

### אימות אחרי rolling update

```bash
# פרטים על Deployment
kubectl describe deployment nginx-deployment
```

הפלט הראה:
- `Annotations: deployment.kubernetes.io/revision: 2`
- image ב-Pod Template: `nginx:1.27.0-alpine`
- `OldReplicaSets: nginx-deployment-85bc587484 (0/0 replicas created)`
- `NewReplicaSet: nginx-deployment-7864f464cb (5/5 replicas created)`

```bash
# בדיקת image ב-Pod ספציפי
kubectl describe pod nginx-deployment-7864f464cb-8rfb7 | grep Image
# Image: nginx:1.27.0-alpine

# בדיקת ReplicaSets
kubectl get rs
# nginx-deployment-85bc587484   0     0     0   (ישן, נשמר לצרכי rollback)
# nginx-deployment-7864f464cb   5     5     5   (חדש, פעיל)

# בדיקת Deployment
kubectl get deploy nginx-deployment
# READY 5/5   UP-TO-DATE 5   AVAILABLE 5
```

### דיאגרמה - Rolling Update Flow

```
לפני:
  Deployment
      |
  RS: nginx-deployment-85bc587484 (5/5)
      |--- Pod-1 (nginx:1.27.0)
      |--- Pod-2 (nginx:1.27.0)
      |--- Pod-3 (nginx:1.27.0)
      |--- Pod-4 (nginx:1.27.0)
      `--- Pod-5 (nginx:1.27.0)

במהלך (snapshot אמצעי):
  Deployment
      |--- RS: nginx-deployment-85bc587484 (3/3) <- יורד
      |         |--- Pod-1 (nginx:1.27.0)
      |         |--- Pod-2 (nginx:1.27.0)
      |         `--- Pod-3 (nginx:1.27.0)
      |
      `--- RS: nginx-deployment-7864f464cb (2/2) <- עולה
                |--- Pod-A (nginx:1.27.0-alpine)
                `--- Pod-B (nginx:1.27.0-alpine)

אחרי:
  Deployment
      |--- RS: nginx-deployment-85bc587484 (0/0) <- ישן, שמור לrollback
      `--- RS: nginx-deployment-7864f464cb (5/5) <- פעיל
                |--- Pod-A (nginx:1.27.0-alpine)
                |--- Pod-B (nginx:1.27.0-alpine)
                |--- Pod-C (nginx:1.27.0-alpine)
                |--- Pod-D (nginx:1.27.0-alpine)
                `--- Pod-E (nginx:1.27.0-alpine)
```

### טעויות שעשיתי ולמה הן שימושיות

**watch לא מחזיר prompt** - `kubectl get pods --watch` לא מסתיים לבד. צריך Ctrl+C לסגירה. מי שלא יודע את זה ממתין לזה שיסתיים ומתבלבל. watch הוא streaming, לא one-shot.

---

## Lab 5.5 - Rollouts, Revisions and Annotations

### מה תרגלנו

rollback, rollout history, ו-annotations. הקונספט המרכזי: revision history הוא לא מספר עוקב שחוזר אחורה - כל פעולה, כולל rollback, מוסיפה revision חדש.

### rollout help

```bash
kubectl rollout --help
```

Sub-commands רלוונטיים:
- `history` - רשימת revisions
- `pause` / `resume` - עצירה והמשך rollout
- `restart` - הפעלה מחדש של כל Pods
- `status` - מצב rollout נוכחי
- `undo` - חזרה ל-revision קודם

### rollout history

```bash
kubectl rollout history deployment/nginx-deployment
```

פלט ראשוני (ללא annotations):

```
DEPLOYMENT         CHANGE-CAUSE
nginx-deployment   <none>
nginx-deployment   <none>
```

revision 1 ו-2, שניהם ללא change-cause כי לא הוספנו annotation.

### rollback

```bash
# Terminal 1 - מעקב
kubectl get pods --watch

# Terminal 3 - rollback
kubectl rollout undo deployment/nginx-deployment
```

```bash
# אימות image אחרי rollback
kubectl describe pod nginx-deployment-85bc587484-896tg | grep Image
# Image: nginx:1.27.0
```

הפלט הוכיח שחזרנו ל-image המקורי.

### history אחרי rollback

```bash
kubectl rollout history deployment/nginx-deployment
```

```
REVISION   CHANGE-CAUSE
2          <none>
3          <none>
```

**שים לב:** revision 1 נעלם, revision 3 נוצר. Rollback לא מחזיר את revision 1 - הוא יוצר revision 3 שמכיל את אותו state. המספר תמיד עולה.

### בדיקת revision ספציפי

```bash
kubectl rollout history deployment/nginx-deployment --revision=2 -o yaml
```

הפלט הראה:
- ReplicaSet: `nginx-deployment-7864f464cb`
- image: `nginx:1.27.0-alpine`
- replicas: `0` (כי revision 2 הוא כרגע ה-"ישן")
- selector כלל `app=nginx` ו-`pod-template-hash=7864f464cb`

### Annotation - Declarative (בתוך YAML)

הוספנו שורה ל-nginx-deploy.yaml תחת `metadata`:

```yaml
metadata:
  name: nginx-deployment
  labels:
    app: nginx
  annotations:
    kubernetes.io/change-cause: "Update nginx to tag 1.27.0-alpine"
```

גם החזרנו את image ל-`nginx:1.27.0-alpine`.

```bash
kubectl diff -f nginx-deploy.yaml
kubectl apply -f nginx-deploy.yaml
kubectl rollout history deployment/nginx-deployment
```

```
REVISION   CHANGE-CAUSE
3          <none>
4          Update nginx to tag 1.27.0-alpine
```

revision 4 כבר מראה את ה-change-cause.

### Annotation - Imperative (ישירות על הקלאסטר)

```bash
kubectl annotate deployment/nginx-deployment \
  kubernetes.io/change-cause="Update nginx to tag 1.27.1-alpine" \
  --overwrite
```

```bash
kubectl rollout history deployment/nginx-deployment
# revision האחרון מראה "Update nginx to tag 1.27.1-alpine"

kubectl describe deployment nginx-deployment
# Annotations: kubernetes.io/change-cause: Update nginx to tag 1.27.1-alpine
```

**נקודה חשובה:** ה-annotation אמר `1.27.1-alpine` אבל ה-image בפועל היה `nginx:1.27.0-alpine`. Annotation הוא תיעוד, לא שינוי אמיתי. הוא יכול לשקר.

### דיאגרמה - Revision Flow

```
revision 1: nginx:1.27.0      (נוצר בapply ראשון)
    |
revision 2: nginx:1.27.0-alpine  (אחרי שינוי image)
    |
rollback (undo) -> יוצר revision חדש, לא חוזר ל-1
    |
revision 3: nginx:1.27.0       (אותו state כמו revision 1)
    |
apply עם annotation -> revision 4: nginx:1.27.0-alpine + change-cause
    |
apply שוב -> revision 5
```

### דיאגרמה - Declarative vs Imperative Annotation

```
Declarative (YAML):
  nginx-deploy.yaml -> kubectl apply -> קלאסטר + YAML מסונכרנים

Imperative (kubectl annotate):
  kubectl annotate -> קלאסטר בלבד -> YAML לא השתנה -> drift אפשרי
```

### טעויות שעשיתי ולמה הן שימושיות

**alpine-alpine** - בעת החזרת image לאחר rollback, הקלדתי `nginx:1.27.0-alpine-alpine` בטעות. תיקון:

```bash
# בדיקה
grep -n "change-cause\|image:" nginx-deploy.yaml

# תיקון עם perl
perl -pi -e 's/nginx:1\.27\.0-alpine-alpine/nginx:1.27.0-alpine/g' nginx-deploy.yaml

# אימות
grep -n "image:" nginx-deploy.yaml
```

זאת טעות שקל לעשות - `sed` עם regex שגוי לא תמיד שגיאה. `perl -pi -e` נותן יותר שליטה וכבר כולל `-i` לעריכה in-place.

---

## Lab 5.6 - Scaling: Temporary vs Declarative

### מה תרגלנו

ההבדל בין `kubectl scale` שמשנה את הקלאסטר בלבד לבין `kubectl apply` שמחזיר את המצב המוצהר מ-YAML. זאת אחת הנקודות שמבדילות בין מי שמבין declarative לבין מי שחושב שK8s הוא רק CLI tool.

### אימות מצב התחלתי

```bash
kubectl get deploy
# nginx-deployment   5/5   5   5
```

### Scale down ידני

```bash
kubectl scale deployment/nginx-deployment --replicas=3
kubectl get deploy
# nginx-deployment   3/3   3   3
```

### diff מראה את הdrrift

```bash
kubectl diff -f nginx-deploy.yaml
```

פלט:

```diff
-  replicas: 3    <- מה שיש כרגע בקלאסטר
+  replicas: 5    <- מה שמוצהר ב-YAML
```

(גם ה-annotation השתנה בין live ל-YAML)

זה בדיוק ה-drift: הקלאסטר ב-3, ה-YAML ב-5. מי שרק מסתכל על YAML לא יודע שהקלאסטר שונה.

### החזרת declarative state

```bash
kubectl apply -f nginx-deploy.yaml
kubectl get deploy
# nginx-deployment   5/5   5   5
```

apply החזיר ל-5 לפי ה-YAML.

### Restart pattern - scale to 0 and back

```bash
kubectl scale deployment/nginx-deployment --replicas=0
kubectl get deploy
# nginx-deployment   0/0   0   0

kubectl scale deployment/nginx-deployment --replicas=5
kubectl get deploy
# nginx-deployment   5/5   5   5
```

זה pattern שימושי לrestart מהיר של כל Pods - לפעמים עדיף על `kubectl rollout restart` בסביבות פשוטות.

### rollout history לאחר scaling

```bash
kubectl rollout history deployment/nginx-deployment
```

revision לא השתנה. Scaling לא יוצר revision חדש כי pod template לא השתנה.

### דיאגרמה - Temporary vs Declarative

```
kubectl scale -> משנה live state בלבד:
  YAML: replicas: 5   <-- לא השתנה
  Cluster: replicas: 3  <- השתנה

kubectl apply -> מחזיר לstate המוצהר:
  YAML: replicas: 5
  Cluster: replicas: 5  <- מסונכרן מחדש
```

---

## Lab 5.7 - Debugging Failed Rollout and Recovery

### מה תרגלנו

הכנסת image tag שגוי בכוונה, מעקב אחרי rollout נכשל, אבחון ב-Pod level, ותיקון עם apply מתוקן.

### הכנסת image שגוי

```bash
perl -pi -e 's/image: nginx:1\.27\.0-alpine/image: nginx:1.27.1alpine/' nginx-deploy.yaml

grep -n "image:" nginx-deploy.yaml
# image: nginx:1.27.1alpine   <- שים לב: חסר מינוס בין 1 ל-alpine
```

```bash
kubectl apply -f nginx-deploy.yaml
```

### מעקב אחרי rollout נכשל

```bash
kubectl get pods --watch
```

פלט:

```
NAME                                    READY   STATUS
nginx-deployment-5f96ffbd5-xxxxx        1/1     Running
nginx-deployment-7bc864cc88-4zh2z       0/1     ErrImagePull
nginx-deployment-7bc864cc88-4zh2z       0/1     ImagePullBackOff
nginx-deployment-7bc864cc88-qxxxx       0/1     ErrImagePull
```

Pods חדשים עם hash `7bc864cc88` לא הצליחו לעלות. Pods ישנים עם hash `5f96ffbd5` נשארו Running.

### rollout status תקוע

```bash
kubectl rollout status deployment/nginx-deployment
# Waiting for deployment "nginx-deployment" rollout to finish...
# (לא מסתיים - צריך Ctrl+C)
```

kubectl rollout status מחכה עד שה-rollout מסתיים. כשהוא נתקע - הוא נתקע.

### אבחון Pod כושל

```bash
BADPOD=$(kubectl get pods -l app=nginx --no-headers | awk '$3=="ImagePullBackOff" || $3=="ErrImagePull" {print $1; exit}'); kubectl describe pod "$BADPOD"
```

פלט רלוונטי מ-describe:

```
Name:     nginx-deployment-7bc864cc88-4zh2z
Image:    nginx:1.27.1alpine

State:    Waiting
Reason:   ImagePullBackOff

Events:
  Warning  Failed     Back-off pulling image "nginx:1.27.1alpine"
  Warning  Failed     Error: ImagePullBackOff
  Warning  Failed     Failed to pull image "nginx:1.27.1alpine": manifest for nginx:1.27.1alpine not found
  Warning  Failed     Error: ErrImagePull
```

הבעיה: `nginx:1.27.1alpine` אינו tag חוקי ב-Docker Hub. הtag הנכון הוא `nginx:1.27.1-alpine` עם מינוס.

### מה זה מוכיח

RollingUpdate הגן על הזמינות. הוא לא מחק את ה-Pods הישנים עד שהחדשים בריאים. כשהחדשים נכשלו, הישנים נשארו ב-Running. זה בדיוק המטרה של rolling update strategy.

### תיקון

```bash
perl -pi -e 's/image: nginx:1\.27\.1alpine/image: nginx:1.27.1-alpine/' nginx-deploy.yaml

grep -n "image:" nginx-deploy.yaml
# image: nginx:1.27.1-alpine

kubectl diff -f nginx-deploy.yaml
kubectl apply -f nginx-deploy.yaml
```

### annotation לתיעוד

```bash
kubectl annotate deployment/nginx-deployment \
  kubernetes.io/change-cause="Fix incorrect tag back to 1.27.1-alpine" \
  --overwrite
```

### rollout history סופי

```bash
kubectl rollout history deployment/nginx-deployment
```

```
REVISION   CHANGE-CAUSE
...
8          Fix incorrect tag back to 1.27.1-alpine
```

### אימות סופי

```bash
kubectl get pods
# nginx-deployment-5f96ffbd5-xxxxx   1/1   Running
# (5 pods, כולם Running)

kubectl get deploy
# nginx-deployment   5/5   5   5

kubectl rollout status deployment/nginx-deployment
# deployment "nginx-deployment" successfully rolled out
```

### Cleanup

```bash
kubectl delete -f nginx-deploy.yaml
kubectl get deploy
kubectl get rs
kubectl get pods
```

אחרי cleanup:
- nginx-deployment - gone
- nginx ReplicaSets - gone
- nginx Pods - gone
- משאבים לא קשורים (`color-api-deployment`, `rogue-pod`) - נשארו, לא שייכים לlab זה

### דיאגרמה - Failed Rollout

```
apply עם image שגוי:
  Deployment
      |--- RS: nginx-deployment-5f96ffbd5 (5/5 Running)    <- ישן, נשמר
      `--- RS: nginx-deployment-7bc864cc88 (0/2 Running)   <- חדש, נכשל

  Pods חדשים:  ErrImagePull -> ImagePullBackOff
  Pods ישנים:  Running        <- זמינות נשמרת

אחרי תיקון (apply עם image נכון):
  Deployment
      |--- RS: nginx-deployment-7bc864cc88 (0/0)           <- נכשל, מחוסל
      `--- RS: nginx-deployment-5f96ffbd5  (5/5 Running)   <- חדש תקין
```

---

## סיכום פקודות

| פקודה | מה היא עושה |
|-------|------------|
| `kubectl diff -f nginx-deploy.yaml` | מראה הבדלים בין YAML לקלאסטר לפני apply |
| `kubectl apply -f nginx-deploy.yaml` | מחיל state מוצהר על הקלאסטר |
| `kubectl get pods --watch` | מעקב חי אחרי Pods |
| `kubectl get rs --watch` | מעקב חי אחרי ReplicaSets |
| `kubectl describe deployment nginx-deployment` | כל פרטי Deployment כולל Events |
| `kubectl describe pod <name> \| grep Image` | בדיקת image ספציפי ב-Pod |
| `kubectl get rs` | רשימת ReplicaSets |
| `kubectl get deploy` | רשימת Deployments |
| `kubectl rollout history deployment/nginx-deployment` | היסטוריית revisions |
| `kubectl rollout history deployment/nginx-deployment --revision=2 -o yaml` | YAML של revision ספציפי |
| `kubectl rollout undo deployment/nginx-deployment` | rollback ל-revision קודם |
| `kubectl rollout status deployment/nginx-deployment` | מצב rollout נוכחי |
| `kubectl annotate deployment/nginx-deployment kubernetes.io/change-cause="..." --overwrite` | annotation ידני |
| `kubectl scale deployment/nginx-deployment --replicas=3` | שינוי replicas ידני |
| `kubectl scale deployment/nginx-deployment --replicas=0` | scale down ל-0 (restart pattern) |
| `kubectl scale deployment/nginx-deployment --replicas=5` | החזרת replicas |
| `kubectl delete -f nginx-deploy.yaml` | מחיקת Deployment לפי YAML |
| `grep -n "image:" nginx-deploy.yaml` | בדיקת image ב-YAML |
| `grep -n "change-cause\|image:" nginx-deploy.yaml` | בדיקת annotation ו-image |
| `perl -pi -e 's/old/new/' nginx-deploy.yaml` | עריכת YAML בשורת הפקודה |
| `BADPOD=$(kubectl get pods -l app=nginx --no-headers \| awk '$3=="ImagePullBackOff" \|\| $3=="ErrImagePull" {print $1; exit}'); kubectl describe pod "$BADPOD"` | מציאת Pod כושל ותיאורו |

---

## Screenshots

תמונות אלה עדיין לא צולמו - David ישלים בהמשך.

| קובץ | מה לצלם |
|------|---------|
| `resources/images/series-05-deployments/00-lab-5-4-rolling-update-watch.png` | pods ו-rs משתנים במהלך rolling update |
| `resources/images/series-05-deployments/01-lab-5-5-rollout-history.png` | rollout history עם revisions |
| `resources/images/series-05-deployments/02-lab-5-6-scale-diff.png` | diff שמראה replicas 3 בקלאסטר מול 5 ב-YAML |
| `resources/images/series-05-deployments/03-lab-5-7-imagepullbackoff.png` | Pods עם ErrImagePull או ImagePullBackOff |
| `resources/images/series-05-deployments/04-lab-5-7-describe-events.png` | describe pod Events עם manifest not found |

---

## Iron Rules

1. **שינוי pod template = ReplicaSet חדש.** שינוי image משנה את pod template hash, מה שיוצר RS חדש.
2. **Rollback יוצר revision חדש, לא חוזר לישן.** המספר תמיד עולה.
3. **`change-cause` הוא תיעוד, לא פעולה.** אפשר לרשום כל דבר - הוא לא משנה מה רץ.
4. **annotation declarative (YAML) מסונכרן. annotation imperative (kubectl annotate) עלול לסחוף.**
5. **`kubectl scale` הוא זמני. `kubectl apply` מנצח.**
6. **Scaling לא יוצר revision.** pod template לא השתנה, אז אין revision חדש.
7. **`ImagePullBackOff` מתחיל ב-Pod, לא ב-Deployment.** תמיד לעשות describe על Pod כדי לראות את ה-Events.
8. **`describe pod` Events הם המקום הראשון לחפש.** לא `kubectl get deploy`, לא `kubectl get pods` - `describe pod`.
9. **RollingUpdate שומר על זמינות גם כשהimage שגוי.** הוא לא מוריד Pods ישנים עד שחדשים בריאים.
10. **Rollback הוא תיקון זמני.** אם ה-YAML עדיין מכיל image שגוי, apply הבא יחזיר את הבעיה.
11. **`kubectl diff` לפני `kubectl apply` הוא הרגל, לא בחירה.**
12. **Cleanup עם `kubectl delete -f` מוחק רק מה שמוגדר באותו manifest.**

---

## שאלות ראיון

1. **מה גורם ל-Deployment ליצור ReplicaSet חדש?** - שינוי בpod template. שינוי replicas לא מספיק.
2. **למה שינוי replicas לא יוצר revision חדש?** - כי pod template לא השתנה. revision tracking עוקב אחרי שינויי template.
3. **מה ההבדל בין `kubectl scale` לבין שינוי replicas ב-YAML?** - scale משנה קלאסטר בלבד. YAML הוא ה-source of truth. apply מנצח.
4. **למה Deployment יכול לשמור על זמינות גם כשimage חדש שגוי?** - כי RollingUpdate לא מוחק Pods ישנים עד שחדשים בריאים.
5. **איפה מוצאים את הסיבה האמיתית ל-ImagePullBackOff?** - ב-Events של `kubectl describe pod`.
6. **מה `kubectl rollout undo` עושה ל-revisions?** - מוסיף revision חדש עם state ישן. לא חוזר למספר ישן.
7. **מה הסיכון בתיקון production רק עם `kubectl annotate` או `kubectl scale`?** - drift. YAML לא מסונכרן. apply הבא יחזיר את המצב הלא נכון.
8. **למה להשתמש ב-`kubectl diff` לפני `kubectl apply`?** - כדי לדעת בדיוק מה הולך להשתנות לפני ששינוי קורה.
9. **מה ההבדל בין declarative לimperative ב-Kubernetes?** - declarative = YAML + apply. imperative = פקודות ישירות שמשנות קלאסטר בלי לשנות קובץ.
10. **למה rollback לא מספיק אם ה-manifest עדיין מכיל image שגוי?** - כי apply הבא יפרוס שוב את ה-image השגוי. התיקון צריך להיות גם ב-YAML.

---

## טעויות נפוצות מהsession הזה

| טעות | מה קרה | מה זה לימד |
|------|---------|------------|
| `nginx:1.27.0-alpine-alpine` | הקלדה כפולה של `-alpine` | תמיד לעשות `grep -n "image:"` לאימות אחרי כל שינוי |
| `kubectl get pods --watch` לא חוזר prompt | watch הוא streaming - Ctrl+C לסגירה | watch הוא לא one-shot command |
| annotation אמר `1.27.1-alpine`, image היה `1.27.0-alpine` | annotation imperative לא שינה image | annotation =/= deploy. change-cause הוא תיעוד, לא פעולה |
| image שגוי `nginx:1.27.1alpine` | חסר מינוס - `1.27.1alpine` במקום `1.27.1-alpine` | תמיד לאמת tag עם `grep "image:"` לפני apply |

---

## מצב cleanup סופי

אחרי `kubectl delete -f nginx-deploy.yaml`:

```
nginx-deployment     DELETED
nginx ReplicaSets    DELETED
nginx Pods           DELETED

נשארו (לא קשורים לlab):
  color-api-deployment   <- לא נגענו
  rogue-pod              <- לא נגענו
```
