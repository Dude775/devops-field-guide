

---

# Linux Commands - Complete Field Guide

> **DevOps Field Guide** | David Rubin | Last Updated: 2026-03-10
> 
> מדריך מקיף לכל הפקודות שנלמדו בקורס - מאורגן לפי קטגוריות, עם הסברים מפורטים, דגלים, ודוגמאות מעשיות.

---

## Table of Contents

- [[#1 - Files and Directories Management]]
- [[#2 - Files and Directories - Advanced]]
- [[#3 - Text Processing - Essential]]
- [[#4 - Text Processing - Advanced]]
- [[#5 - Redirection, Pipes, and Streams]]
- [[#6 - Redirection - Advanced / DevOps Level]]
- [[#7 - Links - Symbolic and Hard]]
- [[#8 - Links - Advanced]]
- [[#9 - Permissions and Ownership]]
- [[#10 - Permissions - Advanced]]
- [[#11 - Users and Groups]]
- [[#12 - Users and Groups - Advanced]]
- [[#13 - Access Control Lists (ACL)]]
- [[#14 - ACL - Advanced]]
- [[#15 - Package Management - APT (Debian)]]
- [[#16 - Package Management - DNF (RHEL)]]
- [[#17 - Package Management - Advanced]]
- [[#18 - Package Management - Snap]]
- [[#19 - Snap - Advanced]]
- [[#20 - Processes and Systemd]]
- [[#21 - Processes - Advanced]]
- [[#22 - Bash Scripting - Fundamentals]]
- [[#23 - Bash Scripting - Advanced Fundamentals]]
- [[#24 - Bash Scripting - Intermediate]]
- [[#25 - Bash Scripting - Advanced / DevOps Best Practices]]

---

## 1 - Files and Directories Management

ניהול קבצים ותיקיות הוא הבסיס של כל עבודה ב-Linux. הפקודות הבאות מאפשרות ניווט במערכת הקבצים, יצירה, העתקה, העברה ומחיקה של קבצים ותיקיות.

---

### `ls` - List Contents

מציגה את תוכן התיקייה הנוכחית (או תיקייה שמצוינת כפרמטר). אחת הפקודות הנפוצות ביותר - משתמשים בה כל הזמן כדי לראות מה יש בתיקייה.

**דגלים עיקריים:**

|Flag|Name|Description|
|---|---|---|
|`-l`|Long format|תצוגה מפורטת - הרשאות, בעלים, גודל, תאריך שינוי|
|`-a`|All|מציג גם קבצים מוסתרים (שמתחילים בנקודה `.`)|
|`-h`|Human readable|גדלים קריאים (KB, MB, GB) במקום בתים|
|`-R`|Recursive|מציג גם את תוכן תתי-תיקיות|
|`-t`|Time sort|ממיין לפי זמן שינוי (החדש ביותר קודם)|
|`-S`|Size sort|ממיין לפי גודל (הגדול ביותר קודם)|
|`-r`|Reverse|הופך את סדר המיון|

**דוגמאות:**

```bash
# הצגת כל הקבצים בפורמט מפורט וקריא
ls -alh

# הצגת קבצים ממוינים לפי גודל (הגדול קודם)
ls -lhS

# הצגת קבצים ממוינים לפי זמן שינוי
ls -lt

# הצגת קבצי .log בלבד
ls -lh *.log

# הצגת תוכן תיקייה ספציפית
ls -la /var/log/
```

**פלט לדוגמה של `ls -la`:**

```
drwxr-xr-x  5 david dev  4096 Mar 10 09:00 .
drwxr-xr-x  3 david dev  4096 Mar 09 14:22 ..
-rw-r--r--  1 david dev   220 Mar 08 10:15 .bashrc
-rwxr-xr-x  1 david dev  1024 Mar 10 08:45 script.sh
drwxr-xr-x  2 david dev  4096 Mar 10 09:00 src
```

> **טיפ:** השילוב `ls -alh` הוא כנראה הכי שימושי לעבודה יומיומית - רואים הכל, כולל קבצים מוסתרים, בפורמט קריא.

---

### `cd` - Change Directory

מנווט בין תיקיות במערכת הקבצים. הפקודה משנה את ה-Working Directory הנוכחי שלך.

**קיצורים חשובים:**

|Shortcut|Description|
|---|---|
|`..`|תיקייה אחת למעלה (parent)|
|`~`|תיקיית הבית של המשתמש הנוכחי (`/home/username`)|
|`-`|חזרה לתיקייה הקודמת (כמו “Back”)|
|`/`|שורש מערכת הקבצים (root)|

**דוגמאות:**

```bash
# מעבר לתיקייה ספציפית (נתיב אבסולוטי)
cd /var/log

# מעבר לתיקיית הבית
cd ~

# עלייה שתי רמות למעלה
cd ../..

# חזרה לתיקייה הקודמת (toggle בין שתי תיקיות)
cd -

# מעבר לתיקייה יחסית (relative) מהמיקום הנוכחי
cd src/components
```

> **טיפ:** `cd -` מאוד שימושי כשעובדים בין שתי תיקיות - הוא עושה “קפיצה” הלוך וחזור.

---

### `pwd` - Print Working Directory

מדפיסה את הנתיב המלא (Absolute Path) של התיקייה שאתה נמצא בה כרגע. שימושי כשאתה “אבוד” במערכת הקבצים.

```bash
pwd
# Output: /home/david/projects/devops-field-guide
```

> אין דגלים מיוחדים. פשוט מציג איפה אתה.

---

### `mkdir` - Make Directory

יוצרת תיקייה חדשה. אחת הפקודות הבסיסיות ביותר.

**דגלים עיקריים:**

|Flag|Description|
|---|---|
|`-p`|יוצר את כל שרשרת התיקיות (Parents) - אם תיקיית אב לא קיימת, היא תיווצר אוטומטית|
|`-v`|Verbose - מדפיס הודעה על כל תיקייה שנוצרת|

**דוגמאות:**

```bash
# יצירת תיקייה בודדת
mkdir logs

# יצירת מבנה תיקיות מקונן (ללא -p יזרוק שגיאה אם app לא קיימת)
mkdir -p app/src/components

# יצירת מספר תיקיות במכה אחת
mkdir -p {frontend,backend,docs}

# יצירת מבנה פרויקט שלם בפקודה אחת
mkdir -pv project/{src/{components,utils},tests,docs,config}
```

> **טיפ:** תמיד השתמש ב-`-p` כשיוצר מבנים מקוננים - זה מונע שגיאות ולא פוגע אם התיקייה כבר קיימת.

---

### `rmdir` - Remove Empty Directory

מוחקת תיקייה ריקה בלבד. אם יש בתוכה קבצים - הפקודה תיכשל. זה בכוונה - מנגנון בטיחות.

**דגלים:**

|Flag|Description|
|---|---|
|`-p`|מוחק את כל שרשרת תיקיות האב הריקות|
|`-v`|Verbose - מדפיס מה נמחק|

```bash
# מחיקת תיקייה ריקה
rmdir old_temp

# מחיקת שרשרת תיקיות ריקות
rmdir -p old/archive/2024
```

> **בפרקטיקה:** משתמשים יותר ב-`rm -r` כי `rmdir` עובד רק על תיקיות ריקות. אבל `rmdir` בטוח יותר - הוא לא ימחק בטעות תיקייה עם תוכן.

---

### `cp` - Copy Files and Directories

מעתיקה קבצים ותיקיות. יוצרת עותק חדש ועצמאי (הקובץ המקורי לא מושפע).

**דגלים עיקריים:**

|Flag|Description|
|---|---|
|`-r`|Recursive - חובה כשמעתיקים תיקיות (מעתיק את כל התוכן)|
|`-v`|Verbose - מציג כל קובץ שמועתק|
|`-i`|Interactive - שואל לפני דריסת קובץ קיים|
|`-n`|No clobber - לא דורס קובץ קיים בשום מקרה|
|`-p`|Preserve - שומר על הרשאות, בעלות ותאריכים|
|`-a`|Archive - שווה ל-`-rpL` - שומר הכל כולל Symlinks|

**דוגמאות:**

```bash
# העתקת קובץ בודד
cp config.yaml config.yaml.bak

# העתקת תיקייה שלמה (חייבים -r)
cp -rv src/ backup/

# העתקה עם שמירה על הרשאות ותאריכים
cp -a /etc/nginx/ /backup/nginx/

# העתקה עם הגנה מפני דריסה
cp -i important.txt /shared/

# העתקת מספר קבצים לתיקייה
cp file1.txt file2.txt file3.txt /dest/
```

> **חשוב:** שכחת `-r` בהעתקת תיקייה היא טעות נפוצה - תקבל שגיאה “omitting directory”.

---

### `mv` - Move / Rename

מעבירה קובץ למיקום אחר, או משנה את שמו. שלא כמו `cp`, הקובץ המקורי נעלם.

**דגלים עיקריים:**

|Flag|Description|
|---|---|
|`-i`|Interactive - שואל לפני דריסת קובץ קיים|
|`-n`|No clobber - לא דורס בשום מקרה|
|`-v`|Verbose - מציג מה הועבר|

**דוגמאות:**

```bash
# שינוי שם קובץ
mv old_name.txt new_name.txt

# העברת קובץ לתיקייה אחרת
mv report.pdf /home/david/docs/

# העברה עם הגנה מפני דריסה
mv -i draft.txt /shared/

# העברת מספר קבצים לתיקייה
mv *.log /var/archive/

# שינוי שם תיקייה
mv old_folder/ new_folder/
```

> **שימו לב:** ב-Linux אין פקודת “rename” נפרדת - `mv` עושה את שני הדברים. אם היעד הוא אותה תיקייה עם שם שונה - זה rename. אם היעד הוא תיקייה אחרת - זה move.

---

### `rm` - Remove Files and Directories

מוחקת קבצים ותיקיות. **אין פה Recycle Bin** - מה שנמחק, נמחק לצמיתות.

**דגלים עיקריים:**

|Flag|Description|
|---|---|
|`-r`|Recursive - מוחק תיקייה וכל תוכנה|
|`-f`|Force - לא שואל שאלות, לא מציג שגיאות|
|`-i`|Interactive - שואל על כל קובץ לפני מחיקה|
|`-v`|Verbose - מציג מה נמחק|

**דוגמאות:**

```bash
# מחיקת קובץ בודד
rm temp.txt

# מחיקת תיקייה וכל תוכנה (זהירות!)
rm -rf old_project/

# מחיקה אינטראקטיבית (בטוח יותר)
rm -ri important_folder/

# מחיקת כל קבצי ה-log
rm -v *.log
```

> **אזהרה קריטית:** `rm -rf /` ימחק את כל המערכת. תמיד בדוק פעמיים את הנתיב לפני שמריץ `rm -rf`. אין Undo.

---

### `touch` - Create or Update File

יוצרת קובץ ריק חדש, או מעדכנת את ה-Timestamp של קובץ קיים (בלי לשנות את תוכנו).

**דגלים:**

|Flag|Description|
|---|---|
|`-a`|מעדכן רק את Access Time|
|`-m`|מעדכן רק את Modification Time|
|`-t`|מגדיר תאריך ספציפי (פורמט: `YYYYMMDDhhmm`)|

**דוגמאות:**

```bash
# יצירת קובץ ריק
touch script.sh

# יצירת מספר קבצים בפקודה אחת
touch file1.txt file2.txt file3.txt

# עדכון Timestamp של קובץ קיים (ללא שינוי תוכן)
touch existing_file.log

# הגדרת תאריך ספציפי
touch -t 202601010000 archive.tar.gz
```

> **שימוש נפוץ ב-DevOps:** `touch` משמש הרבה ליצירת Placeholder files, Lockfiles, ולעדכון Timestamps עבור Build Systems שמסתמכים על זמני שינוי.

---

### `ln` - Create Link

יוצרת קישור (Link) לקובץ. יש שני סוגים - Soft Link (קיצור דרך) ו-Hard Link (שם נוסף לאותו Inode). ראה פירוט מלא ב-[[#7 - Links - Symbolic and Hard]].

**דגלים:**

|Flag|Description|
|---|---|
|`-s`|Symbolic (Soft) Link - יוצר קיצור דרך|
|`-f`|Force - דורס Link קיים|

```bash
# יצירת Soft Link (הנפוץ)
ln -s /etc/nginx/nginx.conf ~/nginx-conf

# יצירת Hard Link
ln data.db data_backup.db
```

---

### `tree` - Visual Directory Structure

מציגה את מבנה התיקיות בצורה ויזואלית (עץ). צריך להתקין בנפרד (`apt install tree`).

**דגלים עיקריים:**

|Flag|Description|
|---|---|
|`-L [n]`|מגביל עומק הצגה ל-n רמות|
|`-d`|מציג תיקיות בלבד (ללא קבצים)|
|`-a`|מציג גם קבצים מוסתרים|
|`-I [pattern]`|מתעלם מתבנית (למשל `node_modules`)|

**דוגמאות:**

```bash
# מבנה עד 2 רמות עומק
tree -L 2

# תיקיות בלבד
tree -d

# מבנה פרויקט בלי node_modules ו-.git
tree -L 3 -I "node_modules|.git"
```

**פלט לדוגמה:**

```
.
├── src
│   ├── components
│   │   ├── Header.tsx
│   │   └── Footer.tsx
│   └── utils
│       └── helpers.ts
├── tests
│   └── unit
└── README.md
```

---

## 2 - Files and Directories - Advanced

כלים מתקדמים יותר לעבודה עם קבצים - חיפוש, ניתוח דיסק, זיהוי סוגי קבצים וסנכרון.

---

### `find` - Search for Files

כלי חיפוש חזק ביותר שסורק את מערכת הקבצים בזמן אמת (בניגוד ל-`locate` שמשתמש באינדקס). מאפשר חיפוש לפי שם, סוג, גודל, תאריך, הרשאות ועוד.

**דגלים עיקריים:**

|Flag|Description|
|---|---|
|`-name "pattern"`|חיפוש לפי שם (case sensitive)|
|`-iname "pattern"`|חיפוש לפי שם (case insensitive)|
|`-type f`|קבצים בלבד|
|`-type d`|תיקיות בלבד|
|`-mtime -N`|שונו בN- הימים האחרונים|
|`-mtime +N`|שונו לפני יותר מ-N ימים|
|`-size +100M`|גדולים מ-100MB|
|`-perm 755`|בעלי הרשאות ספציפיות|
|`-exec CMD {} \;`|מריץ פקודה על כל תוצאה|
|`-maxdepth N`|מגביל עומק חיפוש|
|`-empty`|קבצים או תיקיות ריקות|

**דוגמאות:**

```bash
# חיפוש כל קבצי ה-log בתיקייה נוכחית ומטה
find . -name "*.log"

# חיפוש קבצים שנוצרו ב-7 ימים אחרונים
find /home -type f -mtime -7

# חיפוש קבצים גדולים מ-100MB
find / -type f -size +100M 2>/dev/null

# חיפוש ומחיקה של קבצי tmp ישנים (מעל 30 יום)
find /tmp -type f -mtime +30 -exec rm -v {} \;

# חיפוש תיקיות ריקות
find /var -type d -empty

# חיפוש קבצים עם הרשאות 777 (בעיית אבטחה)
find / -type f -perm 777 2>/dev/null

# חיפוש משולב - קבצי Python שנערכו היום
find . -name "*.py" -type f -mtime 0
```

> **טיפ DevOps:** `find / -perm -4000` מוצא את כל הקבצים עם SUID bit - חשוב לסריקות אבטחה.

---

### `du` - Disk Usage (Folders)

מציגה כמה מקום תופסת תיקייה (ותתי-תיקיות). שימושי לאיתור “בלעני מקום”.

**דגלים עיקריים:**

|Flag|Description|
|---|---|
|`-h`|Human readable (KB/MB/GB)|
|`-s`|Summary - רק סיכום כולל (לא תתי-תיקיות)|
|`-d N`|עומק מקסימלי N|
|`--max-depth=1`|מציג רק רמה אחת|

**דוגמאות:**

```bash
# סיכום כולל של תיקייה
du -sh /var/log/

# כל תתי-תיקיות ברמה 1, ממוין לפי גודל
du -h --max-depth=1 /home/ | sort -hr

# מי הכי גדול ב-home?
du -sh /home/* | sort -hr | head -10

# גודל תיקייה נוכחית
du -sh .
```

---

### `df` - Disk Free (Filesystem Level)

מציגה את מצב הדיסקים ברמת ה-Filesystem - כמה מקום פנוי, כמה תפוס, ואחוז ניצול.

**דגלים עיקריים:**

|Flag|Description|
|---|---|
|`-h`|Human readable|
|`-T`|מציג את סוג ה-Filesystem (ext4, xfs, tmpfs…)|
|`-i`|מציג Inodes במקום בלוקים|

**דוגמאות:**

```bash
# סטטוס כל הדיסקים בפורמט קריא
df -hT

# בדיקת Inode usage (חשוב! דיסק יכול להיתקע גם אם יש מקום פנוי)
df -hi

# רק Filesystem ספציפי
df -h /dev/sda1
```

> **תרחיש DevOps:** שרת מדווח “No space left on device” אבל `df -h` מראה 40% פנוי? בדוק `df -i` - יתכן שנגמרו Inodes (קורה עם מיליוני קבצים קטנים).

---

### `file` - Identify File Type

מזהה את סוג הקובץ לפי התוכן שלו (לא לפי הסיומת!). Linux לא מסתמך על סיומות - `file` מסתכל על ה-Magic Bytes.

```bash
# בדיקת סוג קובץ
file data.bin
# Output: data.bin: gzip compressed data

file script.sh
# Output: script.sh: Bourne-Again shell script, ASCII text executable

file image.png
# Output: image.png: PNG image data, 1920 x 1080, 8-bit/color RGBA

# שימושי כשמישהו שינה סיומת
file suspicious.txt
# Output: suspicious.txt: ELF 64-bit LSB executable (!)
```

---

### `stat` - Detailed File Statistics

מציג מידע מפורט על קובץ - Inode, הרשאות, Timestamps (Access, Modify, Change), גודל ב-Blocks ועוד.

```bash
stat index.html
```

**פלט לדוגמה:**

```
  File: index.html
  Size: 4096       Blocks: 8          IO Block: 4096   regular file
Device: 802h/2050d  Inode: 131073      Links: 1
Access: (0644/-rw-r--r--)  Uid: ( 1000/david)   Gid: ( 1000/dev)
Access: 2026-03-10 09:15:22.000000000 +0200
Modify: 2026-03-09 14:30:00.000000000 +0200
Change: 2026-03-09 14:30:00.000000000 +0200
 Birth: 2026-03-01 08:00:00.000000000 +0200
```

> **ההבדל בין Timestamps:**
> 
> - **Access** - מתי הקובץ נקרא לאחרונה
> - **Modify** - מתי התוכן שונה לאחרונה
> - **Change** - מתי ה-Metadata (הרשאות, בעלות) שונו לאחרונה

---

### `locate` - Indexed File Search

חיפוש מהיר מאוד שעובד על בסיס נתונים מקומי (אינדקס). הרבה יותר מהיר מ-`find`, אבל לא תמיד מעודכן.

**דגלים:**

|Flag|Description|
|---|---|
|`-i`|Ignore case|
|`-c`|מחזיר רק ספירה (כמה תוצאות)|
|`-n N`|מגביל ל-N תוצאות ראשונות|

```bash
# חיפוש קובץ
locate nginx.conf

# חיפוש ללא רגישות לאותיות
locate -i readme.md

# עדכון האינדקס (חובה לפני חיפוש ראשון / אחרי שינויים)
sudo updatedb
```

> **`find` vs `locate`:** `locate` מהיר פי 100 אבל מחפש באינדקס ישן. `find` איטי יותר אבל סורק בזמן אמת. לעבודה שוטפת - `locate`. לסקריפטים שדורשים דיוק - `find`.

---

### `rsync` - Sync Files and Directories

כלי סנכרון חכם שמעתיק רק את מה שהשתנה (Delta Sync). הכלי המועדף להעברת קבצים, גיבויים וסנכרון בין שרתים.

**דגלים עיקריים:**

|Flag|Description|
|---|---|
|`-a`|Archive - שומר הרשאות, בעלות, Symlinks, הכל|
|`-v`|Verbose|
|`-z`|דוחס בזמן ההעברה (חוסך Bandwidth)|
|`--delete`|מוחק ביעד קבצים שלא קיימים במקור|
|`--dry-run`|Simulation - מראה מה יקרה בלי לבצע|
|`--progress`|מציג התקדמות|
|`--exclude`|מדלג על תבנית מסוימת|

**דוגמאות:**

```bash
# סנכרון מקומי בין שתי תיקיות
rsync -avz src/ backup/

# סנכרון לשרת מרוחק (SSH)
rsync -avz --progress local_dir/ user@server:/remote/dir/

# גיבוי עם מחיקת קבצים ישנים ביעד
rsync -avz --delete /data/ /backup/data/

# Dry run - ראה מה יקרה בלי לבצע
rsync -avz --dry-run src/ dest/

# סנכרון בלי node_modules ו-.git
rsync -avz --exclude='node_modules' --exclude='.git' project/ backup/
```

> **למה `rsync` ולא `cp`?** כי `rsync` מעביר רק את מה שהשתנה. אם יש לך 10GB ושורה אחת השתנתה - `rsync` יעביר רק את השורה. `cp` יעתיק הכל מחדש.

---

## 3 - Text Processing - Essential

ב-Linux הכל הוא טקסט - Logs, Config files, Output של פקודות. הפקודות הבאות הן ארגז הכלים לעבודה עם טקסט.

---

### `grep` - Search Text

מחפש טקסט בתוך קבצים או ב-Output של פקודות. אחד הכלים החזקים ביותר ב-Linux.

**דגלים עיקריים:**

|Flag|Description|
|---|---|
|`-i`|Ignore case|
|`-v`|Invert - מציג שורות שלא מתאימות|
|`-r`|Recursive - מחפש בכל התיקיות|
|`-n`|מציג מספרי שורות|
|`-c`|ספירה - כמה שורות מתאימות|
|`-l`|מציג רק שמות קבצים (לא את השורות)|
|`-w`|Word match - התאמה למילה שלמה בלבד|
|`-A N`|מציג N שורות אחרי ההתאמה (After)|
|`-B N`|מציג N שורות לפני ההתאמה (Before)|
|`-E`|Extended Regex (שקול ל-`egrep`)|

**דוגמאות:**

```bash
# חיפוש בסיסי
grep "error" /var/log/syslog

# חיפוש ללא רגישות לאותיות, עם מספרי שורות
grep -in "warning" app.log

# חיפוש רקורסיבי בכל קבצי Python
grep -rn "import os" --include="*.py" .

# מציג 3 שורות לפני ואחרי כל התאמה (הקשר)
grep -B3 -A3 "CRITICAL" /var/log/syslog

# ספירת כמה פעמים מופיע "404" בלוג
grep -c "404" access.log

# חיפוש הפוך - כל השורות ללא "DEBUG"
grep -v "DEBUG" app.log

# Regex - חיפוש כתובות IP
grep -E "\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\b" access.log

# שילוב עם Pipe - סינון פלט של פקודות אחרות
ps aux | grep nginx
systemctl list-units | grep -i failed
```

> **טיפ DevOps:** `grep -r "TODO\|FIXME\|HACK" src/` - סריקה מהירה של קוד לתגיות שנשארו.

---

### `head` / `tail` - View Start / End of File

`head` מציג את תחילת הקובץ, `tail` מציג את הסוף. שימושי לקבצי Log ענקיים שאי אפשר (ולא צריך) לפתוח שלמים.

**דגלים:**

|Flag|Description|
|---|---|
|`-n N`|מציג N שורות (ברירת מחדל: 10)|
|`-f`|Follow - `tail` ממשיך להציג שורות חדשות בזמן אמת (Live)|
|`-F`|כמו `-f` אבל עוקב גם אם הקובץ נמחק ונוצר מחדש (Log Rotation)|

**דוגמאות:**

```bash
# 20 השורות הראשונות
head -n 20 config.yaml

# 50 השורות האחרונות
tail -n 50 error.log

# מעקב בזמן אמת אחרי Log (הכי שימושי!)
tail -f /var/log/nginx/access.log

# שילוב - שורות 20 עד 30 בקובץ
head -n 30 file.txt | tail -n 10

# מעקב אחרי Log עם סינון
tail -f app.log | grep --line-buffered "ERROR"
```

> **טיפ:** `tail -f` הוא אחד הכלים הכי חשובים ל-DevOps - מאפשר לראות Logs בזמן אמת כשמדבגים בעיות.

---

### `sort` - Sort Lines

ממיין שורות בקובץ או ב-Output. ברירת מחדל: מיון אלפביתי.

**דגלים עיקריים:**

|Flag|Description|
|---|---|
|`-n`|מיון מספרי (1, 2, 10 ולא 1, 10, 2)|
|`-r`|סדר הפוך (מהגדול לקטן)|
|`-u`|Unique - מסיר כפילויות|
|`-k N`|ממיין לפי עמודה N|
|`-t`|מגדיר Delimiter (ברירת מחדל: רווח)|
|`-h`|מיון Human readable (1K, 2M, 3G)|

**דוגמאות:**

```bash
# מיון אלפביתי
sort names.txt

# מיון מספרי הפוך (הגדול קודם)
sort -nr scores.txt

# מיון לפי עמודה שנייה, מספרית
sort -t',' -k2 -n data.csv

# מיון ייחודי (ללא כפילויות)
sort -u emails.txt

# שילוב - מי הכי גדול?
du -sh /var/* | sort -hr | head -5
```

---

### `uniq` - Filter Duplicates

מסנן שורות כפולות רצופות. **חשוב:** עובד רק על שורות רצופות - לכן כמעט תמיד משלבים עם `sort` לפניו.

**דגלים:**

|Flag|Description|
|---|---|
|`-c`|Count - מציג כמה פעמים כל שורה חזרה|
|`-d`|Duplicates only - רק שורות שחזרו|
|`-u`|Unique only - רק שורות שלא חזרו|
|`-i`|Ignore case|

**דוגמאות:**

```bash
# ספירת כמות הופעות של כל שורה (Pattern קלאסי!)
sort access.log | uniq -c | sort -nr | head -10

# מציאת כתובות IP הכי פעילות
awk '{print $1}' access.log | sort | uniq -c | sort -nr | head -10

# רק שורות שמופיעות יותר מפעם אחת
sort data.txt | uniq -d
```

> **Pattern קלאסי:** `sort | uniq -c | sort -nr` - ספירת תדירות. משתמשים בזה כל הזמן בניתוח Logs.

---

### `wc` - Word/Line Count

סופר שורות, מילים ותווים בקובץ.

**דגלים:**

|Flag|Description|
|---|---|
|`-l`|Lines (שורות)|
|`-w`|Words (מילים)|
|`-c`|Characters/Bytes (תווים)|
|`-m`|Characters (תווים, multi-byte aware)|

**דוגמאות:**

```bash
# כמה שורות בקובץ?
wc -l script.sh

# כמה שורות שגיאה יש?
grep "ERROR" app.log | wc -l

# כמה קבצי Python בפרויקט?
find . -name "*.py" | wc -l

# סטטיסטיקה מלאה
wc README.md
# Output: 150  890  5432 README.md (lines, words, bytes)
```

---

### `diff` - Compare Files

משווה בין שני קבצים ומציג את ההבדלים.

**דגלים עיקריים:**

|Flag|Description|
|---|---|
|`-u`|Unified format - פורמט הכי קריא (כמו Git diff)|
|`-y`|Side by side - השוואה צד ליד צד|
|`--color`|צביעה (ירוק/אדום)|
|`-r`|Recursive - משווה תיקיות שלמות|
|`-q`|Quick - רק אומר אם שונה או לא|

**דוגמאות:**

```bash
# השוואה בפורמט unified (הכי נפוץ)
diff -u original.conf modified.conf

# השוואת תיקיות
diff -r dir1/ dir2/

# השוואה ויזואלית צד ליד צד
diff -y --color file1.txt file2.txt

# רק בדיקה אם קבצים שונים (בלי להציג מה)
diff -q config.yaml config.yaml.bak
```

---

## 4 - Text Processing - Advanced

כלים חזקים יותר למניפולציה ועיבוד טקסט - שימושיים במיוחד לסקריפטים ולעיבוד Logs.

---

### `sed` - Stream Editor

עורך טקסט שעובד על זרם (Stream) - מאפשר חיפוש והחלפה, מחיקת שורות, הוספה ועוד, בלי לפתוח את הקובץ בעורך.

**דגלים עיקריים:**

|Flag|Description|
|---|---|
|`-i`|In-place - עורך את הקובץ עצמו (לא רק מדפיס)|
|`-i.bak`|In-place עם גיבוי אוטומטי|
|`-n`|Silent - מדפיס רק מה שמתבקש|
|`-E`|Extended Regex|

**פקודות sed נפוצות:**

|Pattern|Description|
|---|---|
|`s/old/new/g`|החלפה (g = כל ההופעות בשורה)|
|`Nd`|מחיקת שורה N|
|`/pattern/d`|מחיקת שורות שמכילות Pattern|
|`Np`|הדפסת שורה N (עם `-n`)|
|`/pattern/a\text`|הוספת שורה אחרי Pattern|

**דוגמאות:**

```bash
# החלפת מילה בקובץ (כל ההופעות)
sed -i 's/old_domain/new_domain/g' config.yaml

# החלפה עם גיבוי אוטומטי
sed -i.bak 's/debug=true/debug=false/g' app.conf

# מחיקת שורות ריקות
sed -i '/^$/d' file.txt

# מחיקת שורות שמכילות comment (#)
sed '/^#/d' config.conf

# הדפסת שורות 10 עד 20 בלבד
sed -n '10,20p' longfile.txt

# הוספת prefix לכל שורה
sed 's/^/PREFIX: /' data.txt

# החלפת Delimiter (שימושי לנתיבים)
sed 's|/old/path|/new/path|g' script.sh
```

> **טיפ:** כשעובדים עם נתיבים (שמכילים `/`), אפשר להשתמש ב-Delimiter אחר כמו `|` או `#` כדי לא לברוח מכל Slash.

---

### `awk` - Data Processing

שפת עיבוד טקסט שלמה (Turing-complete). חזקה מאוד לעבודה עם נתונים בעמודות - Logs, CSV, פלטי פקודות.

**דגלים ומבנה:**

|Element|Description|
|---|---|
|`-F`|מגדיר Delimiter|
|`$1, $2...`|עמודה 1, 2…|
|`$0`|השורה כולה|
|`$NF`|העמודה האחרונה|
|`NR`|מספר השורה הנוכחית|
|`BEGIN{}`|קוד שרץ לפני עיבוד|
|`END{}`|קוד שרץ אחרי עיבוד|

**דוגמאות:**

```bash
# הדפסת עמודה ראשונה (שם משתמש מ-passwd)
awk -F: '{print $1}' /etc/passwd

# הדפסת עמודות ספציפיות עם פורמט
awk '{print $1, $9}' access.log

# סינון - רק שורות עם ערך מעל 100 בעמודה 3
awk '$3 > 100 {print $0}' data.txt

# סיכום עמודה מספרית
awk '{sum += $5} END {print "Total:", sum}' sales.csv

# ספירת שורות לפי קטגוריה
awk '{count[$1]++} END {for (k in count) print k, count[k]}' access.log

# שילוב עם Delimiter אחר (CSV)
awk -F',' '{print $2, $4}' report.csv

# הדפסת שורות 5 עד 10
awk 'NR>=5 && NR<=10' file.txt
```

> **`grep` vs `sed` vs `awk`:**
> 
> - **grep** - חיפוש שורות שמכילות Pattern
> - **sed** - חיפוש והחלפה / עריכת שורות
> - **awk** - עיבוד מבוסס עמודות / חישובים

---

### `tee` - Split Output

“מפצל” את הפלט - מציג אותו על המסך וגם כותב אותו לקובץ בו-זמנית.

**דגלים:**

|Flag|Description|
|---|---|
|`-a`|Append - מוסיף לקובץ קיים (במקום לדרוס)|

```bash
# הצגה על מסך + שמירה לקובץ
ls -la | tee file_list.txt

# הוספה לקובץ (לא דריסה)
echo "Build complete" | tee -a build.log

# כתיבה למספר קבצים בו-זמנית
echo "config=prod" | tee file1.conf file2.conf

# שרשור - tee באמצע Pipeline
cat data.csv | tee raw_backup.csv | sort | uniq -c > analysis.txt
```

---

### `xargs` - Pipe to Command

לוקח Output מפקודה אחת ומעביר אותו כ-Arguments לפקודה אחרת. פותר את הבעיה שלא כל פקודה יודעת לקרוא מ-stdin.

**דגלים עיקריים:**

|Flag|Description|
|---|---|
|`-I {}`|Placeholder - מגדיר איפה הקלט יוכנס|
|`-n N`|מעביר N ארגומנטים בכל פעם|
|`-P N`|Parallel - מריץ N תהליכים במקביל|
|`-0`|Null-delimited (עובד עם `find -print0`)|

**דוגמאות:**

```bash
# מחיקת כל קבצי ה-log
find . -name "*.log" | xargs rm -v

# שימוש עם Placeholder (שימושי כשצריך למקם את הקלט באמצע)
find . -name "*.txt" | xargs -I {} cp {} /backup/

# הרצה מקבילית (4 תהליכים)
find . -name "*.jpg" | xargs -P 4 -I {} convert {} -resize 50% resized/{}

# בטוח עם שמות קבצים שמכילים רווחים
find . -name "*.log" -print0 | xargs -0 rm -v

# grep בכל קבצי Python
find . -name "*.py" | xargs grep "import requests"
```

> **טיפ:** תמיד השתמש ב-`-print0` ו-`-0` כשעובד עם שמות קבצים - זה מונע בעיות עם רווחים ותווים מיוחדים.

---

### `cut` - Column Extractor

מחלץ עמודות ספציפיות מטקסט מובנה (CSV, TSV, וכו’).

**דגלים:**

|Flag|Description|
|---|---|
|`-d`|Delimiter (ברירת מחדל: Tab)|
|`-f N`|שדה (עמודה) N|
|`-f N-M`|שדות N עד M|
|`-c N-M`|תווים N עד M|

```bash
# עמודה 1 מ-CSV
cut -d',' -f1 users.csv

# עמודות 1 ו-3
cut -d',' -f1,3 data.csv

# שם משתמש ו-Shell מ-passwd
cut -d':' -f1,7 /etc/passwd

# 10 תווים ראשונים מכל שורה
cut -c1-10 file.txt
```

---

### `tr` - Character Translator

מתרגם, מוחק, או דוחס תווים. עובד על תווים בודדים (לא מילים).

**דגלים:**

|Flag|Description|
|---|---|
|`-d`|Delete - מוחק תווים|
|`-s`|Squeeze - דוחס תווים חוזרים|
|`-c`|Complement - פועל על כל תו שלא ברשימה|

```bash
# המרה לאותיות גדולות
echo "hello world" | tr 'a-z' 'A-Z'
# Output: HELLO WORLD

# מחיקת כל הספרות
echo "abc123def456" | tr -d '0-9'
# Output: abcdef

# דחיסת רווחים מרובים לרווח אחד
echo "too    many   spaces" | tr -s ' '
# Output: too many spaces

# החלפת Newlines ברווחים (הפיכת שורות לשורה אחת)
cat file.txt | tr '\n' ' '

# המרת Windows line endings ל-Unix
tr -d '\r' < windows_file.txt > unix_file.txt
```

---

## 5 - Redirection, Pipes, and Streams

ב-Linux לכל תהליך יש שלושה ערוצים: **stdin** (קלט, 0), **stdout** (פלט רגיל, 1), **stderr** (שגיאות, 2). ההפניות (Redirections) והצינורות (Pipes) מאפשרים לחבר ולנתב את הערוצים האלה.

---

### `|` (Pipe) - Connect Commands

מעביר את ה-stdout של פקודה אחת כ-stdin לפקודה הבאה. זה הלב של פילוסופיית Unix - “Do one thing well” ושרשר.

```bash
# סינון פלט
ps aux | grep nginx

# שרשור של מספר פקודות
cat access.log | awk '{print $1}' | sort | uniq -c | sort -nr | head -10

# ספירה
ls /etc/ | wc -l
```

---

### `>` - Overwrite File

מנתב stdout לקובץ. **דורס** את התוכן הקיים!

```bash
# שמירת פלט לקובץ (דריסה)
ls -la > file_list.txt

# יצירת קובץ עם תוכן
echo "Hello World" > greeting.txt
```

---

### `>>` - Append to File

מנתב stdout לסוף הקובץ. לא דורס - **מוסיף**.

```bash
# הוספת שורה לסוף קובץ
echo "Build finished at $(date)" >> build.log

# הוספת כל השגיאות ללוג מצטבר
grep "ERROR" app.log >> all_errors.log
```

---

### `2>` - Redirect Errors

מנתב stderr (שגיאות בלבד) לקובץ. stdout ממשיך למסך כרגיל.

```bash
# שמירת שגיאות לקובץ
find / -name "secret.txt" 2> errors.log

# מיון - פלט רגיל למסך, שגיאות לקובץ
./build.sh 2> build_errors.log
```

---

### `&>` - Redirect All

מנתב גם stdout וגם stderr לאותו מקום.

```bash
# הכל לקובץ
./deploy.sh &> deploy_full.log

# הכל ל-/dev/null (השתקה מוחלטת)
./noisy_script.sh &> /dev/null
```

---

### `<` - Input Redirection

קורא stdin מקובץ במקום מהמקלדת.

```bash
# ספירת שורות מקובץ
wc -l < data.csv

# מיון קלט מקובץ
sort < unsorted.txt > sorted.txt

# שליחת תוכן קובץ לפקודה
mysql database < backup.sql
```

---

## 6 - Redirection - Advanced / DevOps Level

טכניקות מתקדמות לניהול זרמים - חיוניות לסקריפטים, CI/CD, ו-Automation.

---

### `2>&1` - Merge Errors into Stdout

שולח את stderr לאותו מקום שבו stdout הולך. סדר חשוב!

```bash
# שגיאות ופלט רגיל - הכל לקובץ
./build.sh > output.log 2>&1

# שימושי ב-Cron jobs - לתפוס הכל
0 3 * * * /scripts/backup.sh > /var/log/backup.log 2>&1
```

> **שימו לב לסדר:** `> file 2>&1` עובד. `2>&1 > file` לא עושה מה שחושבים - כי ה-stderr כבר “ננעל” למסך לפני שה-stdout הופנה.

---

### `/dev/null` - The Black Hole

“קובץ” מיוחד שבולע הכל ולא שומר כלום. מושלם להשתקת פלט לא רצוי.

```bash
# השתקת שגיאות Permission denied
find / -name "*.conf" 2>/dev/null

# השתקה מוחלטת
./chatty_script.sh > /dev/null 2>&1

# בדיקה אם פקודה הצליחה (ללא פלט)
grep -q "pattern" file.txt 2>/dev/null && echo "Found" || echo "Not found"
```

---

### `<< EOF` - Here Document

מאפשר להעביר בלוק טקסט מרובה שורות לפקודה, ישירות מתוך הסקריפט.

```bash
# יצירת קובץ קונפיגורציה בפקודה אחת
cat << EOF > /etc/app.conf
server_name=production
port=8080
debug=false
log_level=info
EOF

# שימוש בתוך סקריפט
mysql -u root << EOF
CREATE DATABASE app_db;
GRANT ALL ON app_db.* TO 'appuser'@'localhost';
EOF
```

---

### `<(command)` - Process Substitution

משתמש בפלט של פקודה כאילו היה קובץ. מאפשר להשוות או לעבד פלטים של שתי פקודות.

```bash
# השוואת תוכן שתי תיקיות
diff <(ls dir1/) <(ls dir2/)

# השוואת חבילות מותקנות בין שני שרתים
diff <(ssh server1 'dpkg -l') <(ssh server2 'dpkg -l')

# מיזוג שני קבצים ממוינים
paste <(sort file1.txt) <(sort file2.txt)
```

---

### `|&` - Pipe All (stdout + stderr)

מעביר גם stdout וגם stderr דרך ה-Pipe לפקודה הבאה.

```bash
# תפיסת שגיאות Build גם הן
./build.sh |& grep -i "error"

# לוג מלא עם סינון
./deploy.sh |& tee full_deploy.log | grep "FAIL"
```

---

### `tee` - Split Stream

בהקשר של Streams הוא משמש ל"פיצול" - הפלט ממשיך ב-Pipeline וגם נשמר לקובץ.

```bash
# ראה פלט בזמן אמת + שמור לקובץ
./deploy.sh 2>&1 | tee deploy.log

# שמירת שלבי ביניים ב-Pipeline
cat data.csv | tee raw.csv | sort | tee sorted.csv | uniq -c > final.txt
```

---

## 7 - Links - Symbolic and Hard

ב-Linux יש שני סוגי קישורים (Links). ההבדל ביניהם הוא יסודי ונוגע לאיך שמערכת הקבצים עובדת.

**Soft Link (Symbolic)** - קיצור דרך. מצביע על **נתיב** הקובץ. אם הקובץ המקורי נמחק, ה-Link נשבר.

**Hard Link** - שם נוסף לאותו **Inode** (הנתונים הפיזיים בדיסק). גם אם מוחקים את “המקור”, הנתונים נשארים כל עוד יש לפחות Hard Link אחד שמצביע אליהם.

**טבלת השוואה:**

|Property|Soft Link|Hard Link|
|---|---|---|
|מצביע על|נתיב (Path)|Inode (נתונים)|
|חוצה Filesystems?|כן|לא|
|עובד על תיקיות?|כן|לא (בדר"כ)|
|נשבר אם מקור נמחק?|כן (Dangling Link)|לא - הנתונים נשארים|
|Inode|Inode משלו|אותו Inode כמו המקור|
|זיהוי ב-`ls -l`|מתחיל ב-`l`, מראה `->`|נראה כמו קובץ רגיל|

---

### `ln -s` - Create Soft Link

```bash
# יצירת Soft Link
ln -s /etc/nginx/nginx.conf ~/nginx-conf

# יצירת Soft Link לתיקייה
ln -s /var/log/nginx/ ~/logs

# דריסת Link קיים
ln -sf /new/target ~/existing-link
```

---

### `ln` - Create Hard Link

```bash
# יצירת Hard Link
ln data.db data_backup.db

# אימות - שניהם מצביעים לאותו Inode
ls -i data.db data_backup.db
# Output: 131073 data.db    131073 data_backup.db (אותו מספר!)
```

---

### `readlink` - Follow Link Path

מציג לאן Link מצביע.

```bash
# הצגת היעד המיידי
readlink ~/nginx-conf
# Output: /etc/nginx/nginx.conf

# Canonicalize - מציג את הנתיב האמיתי המלא (עוקב אחרי שרשרת Links)
readlink -f ~/nginx-conf
```

---

### `unlink` - Remove Link

מסיר Link (בלי למחוק את הקובץ שאליו הוא מצביע).

```bash
unlink ~/nginx-conf
```

> **למה `unlink` ולא `rm`?** שניהם עובדים, אבל `unlink` מקבל רק ארגומנט אחד ולא תומך ב-`-r` - כלומר הוא בטוח יותר. אי אפשר בטעות לעשות `unlink -rf /`.

---

## 8 - Links - Advanced

---

### `ls -i` - Show Inode Number

כל קובץ ב-Linux מקושר ל-Inode - מספר ייחודי שמזהה את הנתונים הפיזיים בדיסק.

```bash
ls -i file.txt
# Output: 131073 file.txt
```

---

### `find -samefile` - Find All Hard Links

מוצא את כל ה-Hard Links שמצביעים לאותו Inode.

```bash
# מצא את כל השמות של אותו קובץ
find / -samefile file.txt 2>/dev/null
```

---

### `df -i` - Inode Disk Usage

בודק את ניצול ה-Inodes בדיסק. דיסק יכול “להתמלא” גם אם יש מקום פנוי - אם נגמרו Inodes.

```bash
df -hi
```

---

### `namei` - Trace Link Path

עוקב אחרי שרשרת Links ומציג כל שלב בנתיב, כולל הרשאות.

```bash
namei -l /mnt/link
```

---

## 9 - Permissions and Ownership

מערכת ההרשאות של Linux מבוססת על שלוש רמות: **Owner** (בעלים), **Group** (קבוצה), **Others** (כולם). לכל רמה יש שלוש הרשאות: **Read** (r=4), **Write** (w=2), **Execute** (x=1).

**טבלת הרשאות מספרית:**

|Octal|Binary|Permission|
|---|---|---|
|0|000|`---` (כלום)|
|1|001|`--x` (הרצה)|
|2|010|`-w-` (כתיבה)|
|4|100|`r--` (קריאה)|
|5|101|`r-x` (קריאה + הרצה)|
|6|110|`rw-` (קריאה + כתיבה)|
|7|111|`rwx` (הכל)|

**הרשאות נפוצות:**

|Octal|Meaning|Use Case|
|---|---|---|
|`755`|rwxr-xr-x|סקריפטים, תיקיות|
|`644`|rw-r–r–|קבצים רגילים, Config|
|`600`|rw-------|קבצים רגישים (SSH keys)|
|`700`|rwx------|תיקיות פרטיות|
|`777`|rwxrwxrwx|**לעולם לא בפרודקשן!**|

---

### `chmod` - Change Permissions

משנה הרשאות של קובץ או תיקייה.

**שתי צורות:**

|Mode|Description|
|---|---|
|Numeric|`chmod 755 file` - מספרים|
|Symbolic|`chmod u+x file` - אותיות (u=owner, g=group, o=others, a=all)|

**דוגמאות:**

```bash
# הפיכת סקריפט להרצה
chmod +x script.sh

# הרשאה מספרית
chmod 755 script.sh    # Owner: rwx, Group: r-x, Others: r-x
chmod 644 config.yaml  # Owner: rw-, Group: r--, Others: r--
chmod 600 id_rsa       # Owner: rw-, אף אחד אחר

# Symbolic mode
chmod u+x script.sh       # הוספת הרצה ל-Owner
chmod g-w shared.txt       # הסרת כתיבה מ-Group
chmod o-rwx private.key    # הסרת הכל מ-Others

# רקורסיבי - כל התיקייה
chmod -R 755 /var/www/html/
```

---

### `chown` - Change Owner/Group

משנה בעלות על קובץ - Owner ו/או Group.

```bash
# שינוי Owner
chown david script.sh

# שינוי Owner ו-Group
chown david:developers project/

# רקורסיבי - כל התיקייה
chown -R www-data:www-data /var/www/

# שינוי Group בלבד
chown :nginx /etc/nginx/conf.d/
```

---

### `chgrp` - Change Group

משנה רק את ה-Group (קיצור ל-`chown :group`).

```bash
chgrp -R developers /src
```

---

### `umask` - Default Permission Mask

מגדיר את ה-Mask שמופחת מהרשאות ברירת המחדל בעת יצירת קבצים חדשים. ברירת מחדל לקבצים: 666, לתיקיות: 777. ה-umask מופחת מהם.

```bash
# בדיקת umask נוכחי
umask
# Output: 0022

# עם umask 022:
# קבצים חדשים: 666 - 022 = 644 (rw-r--r--)
# תיקיות חדשות: 777 - 022 = 755 (rwxr-xr-x)

# שינוי umask (מגביל יותר)
umask 077
# קבצים חדשים: 666 - 077 = 600 (rw-------)
# תיקיות חדשות: 777 - 077 = 700 (rwx------)
```

---

## 10 - Permissions - Advanced

---

### `chmod +s` - SUID / SGID

ביטים מיוחדים שמשנים את אופן ההרצה של קבצים.

**SUID** (Set User ID) - הקובץ רץ עם ההרשאות של ה-Owner שלו (לא של מי שהריץ).

**SGID** (Set Group ID) - על קובץ: רץ עם הרשאות ה-Group. על תיקייה: קבצים חדשים יורשים את ה-Group של התיקייה.

```bash
# SUID - קובץ ירוץ כ-Owner שלו
chmod u+s /usr/local/bin/special_tool
# ls יראה: -rwsr-xr-x

# SGID על תיקייה - קבצים חדשים יורשים את ה-Group
chmod g+s /shared/projects/
# ls יראה: drwxrwsr-x

# מספרי: SUID=4, SGID=2 (ספרה רביעית מהשמאל)
chmod 4755 special_tool  # SUID
chmod 2755 shared_dir/   # SGID
```

> **אזהרה:** SUID על קובץ שבבעלות root = הרצה כ-root! שימוש לא זהיר = פרצת אבטחה חמורה. `find / -perm -4000` מוצא את כל קבצי SUID במערכת.

---

### `chmod +t` - Sticky Bit

על תיקייה: רק ה-Owner של קובץ (או root) יכול למחוק אותו, גם אם לאחרים יש הרשאת כתיבה לתיקייה. דוגמה קלאסית: `/tmp`.

```bash
chmod +t /uploads
# ls יראה: drwxrwxrwt (שימו לב ל-t בסוף)

# מספרי: Sticky=1
chmod 1777 /tmp
```

---

### `chattr` / `lsattr` - File Attributes

מאפיינים ברמת Filesystem שמוסיפים שכבת הגנה מעבר להרשאות רגילות.

```bash
# הפיכת קובץ ל-Immutable (אפילו root לא יכול לשנות/למחוק!)
sudo chattr +i /etc/resolv.conf

# Append Only (אפשר רק להוסיף, לא לשנות/למחוק)
sudo chattr +a /var/log/audit.log

# הצגת Attributes
lsattr /etc/resolv.conf
# Output: ----i--------e-- /etc/resolv.conf

# הסרת Immutable
sudo chattr -i /etc/resolv.conf
```

> **שימוש ב-DevOps:** `chattr +i` מצוין להגנה על קבצי קונפיגורציה קריטיים מפני שינויים בטעות.

---

## 11 - Users and Groups

ניהול משתמשים וקבוצות הוא בסיס של אבטחת Linux. כל משתמש שייך לקבוצה ראשית (Primary Group) ויכול להשתייך לקבוצות נוספות (Secondary Groups).

---

### `useradd` - Create User

```bash
# יצירת משתמש עם Home Directory ו-Shell
useradd -m -s /bin/bash david

# עם קבוצה ראשית ספציפית
useradd -m -s /bin/bash -g developers alice

# עם קבוצות משניות
useradd -m -s /bin/bash -G docker,sudo bob
```

|Flag|Description|
|---|---|
|`-m`|יוצר Home Directory|
|`-s`|מגדיר Shell (ברירת מחדל: `/bin/sh`)|
|`-g`|Primary Group|
|`-G`|Secondary Groups (מופרד בפסיקים)|
|`-d`|נתיב Home Directory מותאם|
|`-e`|תאריך תפוגה לחשבון|

---

### `usermod` - Modify User

```bash
# הוספת משתמש לקבוצה (חובה -a ביחד עם -G!)
usermod -aG docker david

# נעילת משתמש
usermod -L baduser

# שחרור נעילה
usermod -U baduser

# שינוי Shell
usermod -s /bin/zsh david

# שינוי Home Directory
usermod -d /new/home -m david
```

> **אזהרה קריטית:** `usermod -G docker david` (בלי `-a`) **ימחק** את כל הקבוצות המשניות ויגדיר רק docker! תמיד השתמש ב-`-aG` (append + Groups).

---

### `userdel` - Delete User

```bash
# מחיקת משתמש (שומר Home Directory)
userdel olduser

# מחיקת משתמש כולל Home Directory וקבצים
userdel -r olduser
```

---

### `passwd` - Change Password

```bash
# שינוי סיסמה (של עצמך)
passwd

# שינוי סיסמה למשתמש אחר (root)
sudo passwd alice

# נעילת חשבון
passwd -l baduser

# כפיית שינוי סיסמה בכניסה הבאה
passwd -e alice
```

---

### `whoami` / `id` / `groups`

```bash
# מי אני?
whoami
# Output: david

# מידע מלא - UID, GID, קבוצות
id
# Output: uid=1000(david) gid=1000(david) groups=1000(david),27(sudo),999(docker)

# רק UID
id -u

# רק קבוצות
groups david
# Output: david : david sudo docker developers
```

---

## 12 - Users and Groups - Advanced

---

### `visudo` - Edit Sudoers Safely

עורך את קובץ `/etc/sudoers` עם בדיקת Syntax - מונע נעילת עצמך מחוץ ל-sudo.

```bash
# עריכה בטוחה
sudo visudo

# בדיקת Syntax בלבד
sudo visudo -c
```

**דוגמת שורה ב-sudoers:**

```
david ALL=(ALL:ALL) ALL
%developers ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart nginx
```

> **לעולם אל תערוך `/etc/sudoers` ישירות עם nano/vim!** תמיד `visudo` - כי Syntax שגוי יכול לנעול אותך לחלוטין מ-sudo.

---

### `sudo -l` - Check Sudo Permissions

```bash
# מה מותר לי לעשות עם sudo?
sudo -l
```

---

### `chage` - Password Aging

ניהול מדיניות סיסמאות - תפוגה, מינימום ימים בין שינויים, וכו’.

```bash
# הצגת מדיניות סיסמה למשתמש
chage -l david

# הגדרת תפוגה כל 90 יום
chage -M 90 david

# כפיית שינוי סיסמה מיידי
chage -d 0 alice
```

---

### `logname` - Original Login User

מציג את המשתמש המקורי שהתחבר (גם אחרי `su` או `sudo`).

```bash
logname
# Output: david (גם אם עכשיו אתה root אחרי sudo su)
```

---

### `lastlog` - User Login Audit

מציג מתי כל משתמש התחבר לאחרונה.

```bash
# כל המשתמשים
lastlog

# משתמש ספציפי
lastlog -u nginx
```

---

### `getent` - Query System Databases

שולף מידע מבסיסי נתונים של המערכת (passwd, group, hosts, services).

```bash
# מידע על משתמש
getent passwd root
# Output: root:x:0:0:root:/root:/bin/bash

# כל חברי קבוצה
getent group docker
# Output: docker:x:999:david,alice

# בדיקת hostname resolution
getent hosts google.com
```

---

## 13 - Access Control Lists (ACL)

ACL (Access Control Lists) מרחיבים את מערכת ההרשאות הרגילה ומאפשרים הגדרת הרשאות ספציפיות למשתמשים ולקבוצות מעבר ל-Owner/Group/Others. לדוגמה: לתת ל-alice הרשאת קריאה בלבד לקובץ שבבעלות bob, בלי לשנות את ה-Group.

---

### `getfacl` - View File ACLs

```bash
getfacl config.yaml
```

**פלט לדוגמה:**

```
# file: config.yaml
# owner: david
# group: dev
user::rw-
user:alice:r--
group::r--
mask::r--
other::---
```

---

### `setfacl -m` - Add/Modify ACL

```bash
# הוספת הרשאת קריאה+כתיבה למשתמש ספציפי
setfacl -m u:bob:rw config.yaml

# הוספת הרשאה לקבוצה
setfacl -m g:testers:r config.yaml

# הרשאה רקורסיבית על תיקייה
setfacl -Rm u:alice:rx /shared/
```

---

### `setfacl -x` - Remove Specific ACL

```bash
# הסרת ACL של משתמש ספציפי
setfacl -x u:bob config.yaml
```

---

### `setfacl -b` - Remove All ACLs

```bash
# ניקוי כל ה-ACLs מקובץ (חזרה להרשאות רגילות)
setfacl -b file.txt
```

---

### `setfacl -d` - Set Default ACLs

Default ACLs נקבעים על תיקייה ומשפיעים על כל קובץ חדש שנוצר בתוכה (ירושה).

```bash
# כל קובץ חדש ב-shared/ ייתן ל-dev קריאה אוטומטית
setfacl -d -m g:dev:r /shared/
```

---

## 14 - ACL - Advanced

---

### `setfacl -k` - Remove Default ACL

```bash
# ביטול ירושת הרשאות בתיקייה
setfacl -k /shared/
```

---

### `setfacl -m m::` - Masking

ה-Mask קובע את ההרשאה המקסימלית האפקטיבית לכל ה-ACL Entries (חוץ מ-Owner ו-Others). גם אם נתת למשתמש `rwx`, אם ה-Mask הוא `r-x` - הוא יקבל בפועל רק `r-x`.

```bash
# הגבלת Mask - אף ACL לא יקבל יותר מ-r-x
setfacl -m m::rx file.txt
```

---

### Backup & Restore ACLs

```bash
# גיבוי כל ה-ACLs של תיקייה
getfacl -R /data > permissions_backup.acl

# שחזור
setfacl --restore=permissions_backup.acl
```

---

## 15 - Package Management - APT (Debian)

APT (Advanced Package Tool) הוא מנהל החבילות של Debian/Ubuntu. מטפל בהורדה, התקנה, עדכון ומחיקה של חבילות תוכנה.

---

### `apt update` - Refresh Package Lists

מסנכרן את רשימת החבילות המקומית עם ה-Repositories. **לא מתקין כלום** - רק מעדכן את הרשימה.

```bash
sudo apt update
```

> **חובה להריץ לפני `install` או `upgrade`** - אחרת עלולים להתקין גרסאות ישנות.

---

### `apt install` - Install Package

```bash
# התקנה בסיסית
sudo apt install -y vim

# התקנה ללא חבילות מומלצות (חוסך מקום)
sudo apt install --no-install-recommends nginx

# התקנת מספר חבילות
sudo apt install -y git curl wget htop
```

---

### `apt remove` - Remove Package

```bash
# הסרת חבילה (שומר קבצי Config)
sudo apt remove nginx

# הסרה מלאה כולל Config
sudo apt remove --purge nginx

# הסרת חבילות יתומות (Dependencies שלא צריך יותר)
sudo apt autoremove
```

---

### `apt upgrade` - Update All Packages

```bash
# עדכון כל החבילות
sudo apt upgrade -y

# עדכון "אגרסיבי" - מוחק חבילות ישנות אם צריך
sudo apt full-upgrade -y
```

---

## 16 - Package Management - DNF (RHEL)

DNF הוא מנהל החבילות של RHEL/Fedora/CentOS (מחליף את yum).

```bash
# התקנה
sudo dnf install -y git

# חיפוש חבילה
dnf search nodejs

# עדכון כל החבילות
sudo dnf upgrade -y

# הסרה
sudo dnf remove package_name

# מידע על חבילה
dnf info nginx
```

---

## 17 - Package Management - Advanced

---

### `dpkg` - Low-Level Debian Package Manager

dpkg הוא השכבה הנמוכה של apt - עובד עם קבצי `.deb` ישירות.

```bash
# התקנת קובץ .deb מקומי
sudo dpkg -i package.deb

# רשימת כל החבילות המותקנות
dpkg -l

# מי סיפק את הקובץ הזה?
dpkg -S /usr/bin/bash
# Output: bash: /usr/bin/bash

# תוכן חבילה
dpkg -L nginx
```

---

### `rpm -qf` - RHEL File Owner Query

```bash
# מי סיפק את הקובץ? (RHEL/Fedora)
rpm -qf /etc/hosts
```

---

### `apt-cache` - Deep Metadata Search

```bash
# איזו גרסה זמינה?
apt-cache policy nginx

# מה ה-Dependencies?
apt-cache depends nginx

# חיפוש מתקדם
apt-cache search "web server"
```

---

### `apt-mark` - Pin Package Version

מונע עדכון אוטומטי של חבילה ספציפית (שימושי כשגרסה מסוימת עובדת ולא רוצים לשבור).

```bash
# נעילת גרסה
sudo apt-mark hold nginx

# שחרור נעילה
sudo apt-mark unhold nginx

# הצגת חבילות נעולות
apt-mark showhold
```

---

### `apt list` - List Packages

```bash
# חבילות מותקנות
apt list --installed

# חבילות עם עדכון זמין
apt list --upgradable
```

---

## 18 - Package Management - Snap

Snap הוא מערכת חבילות של Canonical (Ubuntu). החבילות רצות ב-Sandbox מבודד ומכילות את כל ה-Dependencies שלהן.

---

### `snap install` - Install Snap

```bash
# התקנה רגילה (Sandboxed)
sudo snap install htop

# התקנה עם גישה מלאה למערכת (classic = ללא Sandbox)
sudo snap install code --classic
```

---

### `snap list` - Show Installed Snaps

```bash
snap list
```

---

### `snap remove` - Delete Snap

```bash
# הסרה (שומר Snapshots)
sudo snap remove go

# הסרה מלאה כולל נתונים
sudo snap remove --purge go
```

---

### `snap refresh` - Update Snaps

```bash
# עדכון כל ה-Snaps
sudo snap refresh

# עדכון Snap ספציפי
sudo snap refresh firefox
```

---

### `snap find` - Search Snap Store

```bash
snap find certbot
```

---

## 19 - Snap - Advanced

---

### `snap revert` - Rollback Version

חוזר לגרסה הקודמת של Snap (Rollback מובנה!).

```bash
sudo snap revert lxd
```

---

### `snap info` - Detailed Metadata

```bash
snap info docker
# מראה: publisher, channels (stable/beta/edge), description, installed size
```

---

### `snap run --shell` - Debug Inside Container

פותח Shell בתוך ה-Sandbox של ה-Snap - שימושי לדיבוג.

```bash
snap run --shell htop
```

---

### `snap changes` - Operation History

```bash
snap changes
# מראה היסטוריית פעולות: install, remove, refresh
```

---

### `snap switch` - Change Channel

```bash
# מעבר לערוץ Beta
sudo snap switch --channel=beta firefox

# מעבר ל-Edge (הכי חדש, הכי פחות יציב)
sudo snap switch --channel=edge firefox
```

---

## 20 - Processes and Systemd

ניהול תהליכים ושירותים - הליבה של ניהול שרתי Linux.

---

### `ps` - Process Snapshot

מציג “צילום” של תהליכים רצים ברגע נתון.

**דגלים נפוצים:**

|Flag|Description|
|---|---|
|`aux`|כל התהליכים של כל המשתמשים|
|`-ef`|פורמט סטנדרטי (POSIX) עם כל הפרטים|
|`--forest`|מציג עץ היררכי של תהליכי אב-בן|

```bash
# כל התהליכים
ps aux

# חיפוש תהליך ספציפי
ps aux | grep nginx

# עץ תהליכים
ps aux --forest

# תהליכים של משתמש ספציפי
ps -u david
```

**הסבר עמודות `ps aux`:**

|Column|Description|
|---|---|
|USER|משתמש שמפעיל את התהליך|
|PID|Process ID|
|%CPU|שימוש ב-CPU|
|%MEM|שימוש ב-RAM|
|VSZ|Virtual Memory Size|
|RSS|Resident Set Size (RAM פיזי)|
|STAT|סטטוס (S=sleep, R=running, Z=zombie)|
|START|זמן התחלה|
|COMMAND|הפקודה שהריצה את התהליך|

---

### `top` / `htop` - Real-Time Monitor

`top` מגיע מובנה. `htop` נראה יותר טוב וקל יותר לשימוש (צריך להתקין).

**מקשים ב-htop:**

|Key|Action|
|---|---|
|`M`|מיון לפי RAM|
|`P`|מיון לפי CPU|
|`T`|מיון לפי זמן|
|`F5`|תצוגת עץ|
|`F9`|שליחת Signal (Kill)|
|`q`|יציאה|
|`/`|חיפוש|

```bash
htop
```

---

### `kill` - Stop Process

שולח Signal לתהליך. ברירת מחדל: SIGTERM (בקשה עדינה לסגירה).

**Signals חשובים:**

|Signal|Number|Description|
|---|---|---|
|SIGTERM|15|בקשה עדינה לסגירה (ברירת מחדל)|
|SIGKILL|9|הריגה מיידית (לא ניתן לתפוס/להתעלם)|
|SIGHUP|1|Reload config (הרבה Daemons תומכים)|
|SIGSTOP|19|הקפאה (Pause)|
|SIGCONT|18|המשך אחרי Pause|

```bash
# סגירה עדינה
kill 1234
kill -15 1234

# הריגה מיידית (כשעדין לא עובד)
kill -9 1234

# רשימת כל ה-Signals
kill -l
```

---

### `systemctl` - Service Manager

הכלי המרכזי לניהול שירותים (Services) ב-Linux מודרני (Systemd).

**פעולות עיקריות:**

|Action|Description|
|---|---|
|`start`|הפעלת שירות|
|`stop`|עצירת שירות|
|`restart`|עצירה + הפעלה מחדש|
|`reload`|טעינת Config מחדש (בלי עצירה)|
|`enable`|הפעלה אוטומטית ב-Boot|
|`disable`|ביטול הפעלה אוטומטית|
|`status`|סטטוס השירות|
|`is-active`|האם רץ? (שימושי בסקריפטים)|
|`is-enabled`|האם מופעל ב-Boot?|
|`list-units`|רשימת כל ה-Units|

```bash
# סטטוס שירות
systemctl status nginx

# הפעלה + הפעלה אוטומטית
sudo systemctl start nginx
sudo systemctl enable nginx

# שני הפקודות ביחד
sudo systemctl enable --now nginx

# עצירה
sudo systemctl stop nginx

# רשימת שירותים כושלים
systemctl list-units --state=failed
```

---

### `journalctl` - View Service Logs

מציג Logs של Systemd - תחליף מודרני ל-syslog.

**דגלים עיקריים:**

|Flag|Description|
|---|---|
|`-u`|Unit ספציפי (שירות)|
|`-f`|Follow (Live)|
|`-n N`|N שורות אחרונות|
|`--since`|מתאריך|
|`-p`|Priority (err, warning, info…)|
|`-b`|רק מהBoot- האחרון|

```bash
# Logs של שירות ספציפי
journalctl -u nginx

# Live follow
journalctl -u nginx -f

# 50 שורות אחרונות
journalctl -u ssh -n 50

# רק שגיאות מהשעה האחרונה
journalctl -p err --since "1 hour ago"

# Logs מהBoot הנוכחי
journalctl -b

# Logs בין תאריכים
journalctl --since "2026-03-09" --until "2026-03-10"
```

---

## 21 - Processes - Advanced

---

### `lsof` - List Open Files

מציג קבצים פתוחים ואת התהליכים שמשתמשים בהם. ב-Linux “הכל הוא קובץ” - כולל Network Sockets.

```bash
# מי מאזין על Port 80?
lsof -i :80

# כל הקבצים הפתוחים של תהליך
lsof -p 1234

# מי משתמש בקובץ ספציפי?
lsof /var/log/syslog

# כל חיבורי הרשת
lsof -i -P -n
```

---

### `strace` - Trace System Calls

מאפשר לראות את כל ה-System Calls שתהליך מבצע - כלי Debug חזק כשמשהו “נתקע” ולא ברור למה.

```bash
# מעקב אחרי תהליך קיים
strace -p 1234

# הרצה עם מעקב
strace ls -la

# רק File-related calls
strace -e trace=file ls
```

---

### `nice` / `renice` - Process Priority

שולט בעדיפות תהליכים. ערכים: -20 (עדיפות גבוהה) עד 19 (עדיפות נמוכה). ברירת מחדל: 0.

```bash
# הרצת פקודה עם עדיפות נמוכה (לא תפגע בביצועים)
nice -n 10 ./heavy_backup.sh

# שינוי עדיפות של תהליך רץ
renice 10 -p 1234

# עדיפות גבוהה (דורש root)
sudo nice -n -10 ./critical_task.sh
```

---

### `nohup` - Keep Running After Logout

מונע מתהליך להיסגר כשמתנתקים מה-Terminal. הפלט נשמר ב-`nohup.out`.

```bash
# הרצה ברקע שתמשיך גם אחרי Logout
nohup ./long_process.sh &

# עם הפניית פלט
nohup ./app.sh > app.log 2>&1 &
```

---

### `systemctl daemon-reload` - Reload Systemd Config

חובה להריץ אחרי שינוי/יצירה של קבצי `.service`.

```bash
sudo systemctl daemon-reload
```

---

### `killall` - Kill by Name

כמו `kill` אבל לפי שם התהליך (לא PID).

```bash
# הריגת כל תהליכי Python
killall python3

# אינטראקטיבי (שואל על כל אחד)
killall -i python3

# רק תהליכים של משתמש ספציפי
killall -u david python3
```

---

## 22 - Bash Scripting - Fundamentals

Bash Scripting מאפשר אוטומציה של משימות חוזרות. כל פקודה שעובדת ב-Terminal עובדת גם בסקריפט.

---

### `#!/bin/bash` - Shebang

השורה הראשונה בכל סקריפט - מגדירה איזה Interpreter ירוץ. בלעדיה, המערכת לא יודעת מה לעשות עם הקובץ.

```bash
#!/bin/bash
echo "Hello from Bash!"
```

> **Shebangs נפוצים:**
> 
> - `#!/bin/bash` - Bash (הנפוץ ביותר)
> - `#!/bin/sh` - POSIX Shell (נייד יותר)
> - `#!/usr/bin/env python3` - Python

---

### Variables - משתנים

```bash
# השמה (ללא רווחים סביב =)
NAME="David"
COUNT=10
FILE_PATH="/var/log/app.log"

# שימוש (עם $)
echo "Hello $NAME"
echo "Count is: ${COUNT}"

# Output של פקודה לתוך משתנה
CURRENT_DATE=$(date +%Y-%m-%d)
FILE_COUNT=$(ls | wc -l)
```

> **חשוב:** אין רווחים סביב `=`. `NAME = "David"` ייכשל!

---

### `read` - Input from User

```bash
# קלט בסיסי
read -p "Enter your name: " USERNAME
echo "Hello $USERNAME"

# קלט סיסמה (לא מציג מה מקלידים)
read -sp "Password: " PASS
echo ""

# קלט עם ברירת מחדל
read -p "Port [8080]: " PORT
PORT=${PORT:-8080}
```

---

### `if` - Conditionals

```bash
# בדיקת קובץ
if [ -f "/etc/nginx/nginx.conf" ]; then
    echo "Nginx config exists"
elif [ -d "/etc/nginx/" ]; then
    echo "Nginx dir exists but no config"
else
    echo "Nginx not installed"
fi
```

**אופרטורים נפוצים:**

|Operator|Description|
|---|---|
|`-f file`|קובץ קיים?|
|`-d dir`|תיקייה קיימת?|
|`-z "$var"`|משתנה ריק?|
|`-n "$var"`|משתנה לא ריק?|
|`-eq, -ne`|שווה / לא שווה (מספרים)|
|`-gt, -lt`|גדול / קטן (מספרים)|
|`=, !=`|שווה / לא שווה (מחרוזות)|

---

### `for` / `while` - Loops

```bash
# For loop - רשימה
for file in *.txt; do
    echo "Processing: $file"
done

# For loop - טווח
for i in {1..5}; do
    echo "Iteration $i"
done

# For loop - C-style
for ((i=0; i<10; i++)); do
    echo "Count: $i"
done

# While loop
COUNT=0
while [ $COUNT -lt 5 ]; do
    echo "Count: $COUNT"
    ((COUNT++))
done

# While read - קריאת שורות מקובץ
while IFS= read -r line; do
    echo "Line: $line"
done < input.txt
```

---

### `exit` - Status Code

כל פקודה ב-Linux מחזירה Exit Code: 0 = הצלחה, כל דבר אחר = כישלון.

```bash
#!/bin/bash

if [ ! -f "$1" ]; then
    echo "Error: File not found"
    exit 1
fi

echo "File exists!"
exit 0
```

---

## 23 - Bash Scripting - Advanced Fundamentals

---

### `$0, $1, $2...` - Script Arguments

```bash
#!/bin/bash
echo "Script name: $0"
echo "First arg: $1"
echo "Second arg: $2"
echo "All args: $@"
echo "Number of args: $#"
```

**הרצה:** `./script.sh hello world`

**פלט:**

```
Script name: ./script.sh
First arg: hello
Second arg: world
All args: hello world
Number of args: 2
```

---

### `$?` - Previous Exit Status

```bash
grep "error" log.txt
if [ $? -eq 0 ]; then
    echo "Errors found!"
else
    echo "No errors"
fi

# קיצור (One-liner)
grep -q "error" log.txt && echo "Found" || echo "Not found"
```

---

### `set -e` - Error Handling

```bash
#!/bin/bash
set -e    # עצור מיד אם פקודה נכשלת
set -x    # Debug - מדפיס כל פקודה לפני הרצה
set -u    # שגיאה על משתנה לא מוגדר
set -o pipefail  # Pipe נכשל אם אחד מרכיביו נכשל

# או בשורה אחת (Best Practice לכל סקריפט DevOps):
set -euxo pipefail
```

---

### `export` - Environment Variables

משתף משתנה עם תהליכי בן (Child Processes).

```bash
# משתנה רגיל - נראה רק בסקריפט הנוכחי
PORT=8080

# export - נראה גם בתהליכים שהסקריפט מפעיל
export PORT=8080
export DATABASE_URL="postgresql://localhost/app"

# בדיקה
env | grep PORT
```

---

### `alias` - Custom Shortcuts

```bash
# יצירת קיצורים
alias gs="git status"
alias ll="ls -alh"
alias dc="docker compose"

# שמירה קבועה - הוסף ל-~/.bashrc
echo 'alias gs="git status"' >> ~/.bashrc
source ~/.bashrc
```

---

### `source` / `.` - Load File

מריץ סקריפט **בתוך ה-Shell הנוכחי** (לא ב-Child Process). שינויים שהסקריפט עושה (למשל export) משפיעים על ה-Shell שלך.

```bash
# טעינת הגדרות
source ~/.bashrc
. ~/.bashrc  # אותו דבר

# טעינת משתני סביבה
source .env
```

> **הבדל קריטי:** `./script.sh` רץ בChild Process - משתנים לא “חוזרים” אליך. `source script.sh` רץ בShell הנוכחי - שינויים נשמרים.

---

## 24 - Bash Scripting - Intermediate

---

### `[[ ... ]]` - Advanced Test

גרסה משופרת של `[ ]` - תומכת ב-Regex, `&&`, `||`, וגם לא דורשת Quoting של משתנים.

```bash
# Regex matching
if [[ "$VERSION" =~ ^[0-9]+\.[0-9]+ ]]; then
    echo "Valid version format"
fi

# לוגיקה משולבת
if [[ -f "$FILE" && -r "$FILE" ]]; then
    echo "File exists and is readable"
fi

# Pattern matching (Glob)
if [[ "$BRANCH" == feature/* ]]; then
    echo "Feature branch detected"
fi
```

---

### `case` - Pattern Matching

אלטרנטיבה נקייה לשרשרת `if/elif` - מושלם לטיפול ב-Arguments.

```bash
case "$1" in
    start)
        echo "Starting service..."
        ;;
    stop)
        echo "Stopping service..."
        ;;
    restart)
        echo "Restarting..."
        ;;
    status)
        echo "Checking status..."
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac
```

---

### `function` - Reusable Blocks

```bash
# הגדרת פונקציה
deploy_app() {
    local env=$1
    local version=$2

    echo "Deploying v$version to $env..."
    # ... logic ...
    return 0
}

# שימוש
deploy_app "production" "2.1.0"
```

---

### `local` - Local Variables

משתנים שנראים רק בתוך הפונקציה - מונע “זיהום” של ה-Scope החיצוני.

```bash
my_function() {
    local temp_file="/tmp/work_$$"
    local result=0
    # temp_file ו-result לא נראים מחוץ לפונקציה
}
```

---

### `printf` - Formatted Print

בקרה מדויקת על הפלט - יותר אמין מ-`echo` לפורמטים מורכבים.

```bash
printf "Name: %-20s Age: %d\n" "David" 30
# Output: Name: David                Age: 30

printf "Value: %05d\n" 42
# Output: Value: 00042

printf "%.2f%%\n" 99.5
# Output: 99.50%
```

---

### `getopts` - CLI Flag Parser

מעבד Flags בסגנון `-h`, `-p 8080` בסקריפטים.

```bash
#!/bin/bash

while getopts "h:p:v" opt; do
    case $opt in
        h) HOST="$OPTARG" ;;
        p) PORT="$OPTARG" ;;
        v) VERBOSE=true ;;
        *) echo "Usage: $0 [-h host] [-p port] [-v]"; exit 1 ;;
    esac
done

HOST=${HOST:-localhost}
PORT=${PORT:-8080}
echo "Connecting to $HOST:$PORT"
```

**הרצה:** `./script.sh -h myserver -p 3000 -v`

---

## 25 - Bash Scripting - Advanced / DevOps Best Practices

---

### `trap` - Signals and Cleanup

מגדיר קוד שירוץ כש-Signal מתקבל (למשל EXIT, INT, TERM). מושלם לניקוי קבצים זמניים.

```bash
#!/bin/bash

TEMP_DIR=$(mktemp -d)

cleanup() {
    echo "Cleaning up $TEMP_DIR..."
    rm -rf "$TEMP_DIR"
}

# ירוץ תמיד - גם ביציאה רגילה, גם ב-Ctrl+C, גם בשגיאה
trap cleanup EXIT

# ... work in TEMP_DIR ...
echo "Working in $TEMP_DIR"
```

---

### `set -u` - Strict Variables

יוצר שגיאה אם משתמשים במשתנה לא מוגדר (במקום להתייחס אליו כמחרוזת ריקה).

```bash
set -u
echo "$UNDEFINED_VAR"
# Error: UNDEFINED_VAR: unbound variable
```

---

### `set -o pipefail` - Pipe Error Handling

ברירת מחדל: Pipeline מחזיר את ה-Exit Code של הפקודה **האחרונה**. עם `pipefail` - הוא מחזיר את ה-Exit Code של הפקודה **הראשונה שנכשלה**.

```bash
set -o pipefail

# בלי pipefail: תחזיר 0 (wc הצליח)
# עם pipefail: תחזיר 1 (grep נכשל)
grep "missing" file.txt | wc -l
```

---

### `${VAR:-default}` - Default Values

מחזיר ערך ברירת מחדל אם המשתנה ריק או לא מוגדר.

```bash
HOST=${1:-localhost}
PORT=${2:-8080}
ENV=${ENV:-development}

echo "Starting on $HOST:$PORT ($ENV)"
```

**וריאציות:**

|Syntax|Description|
|---|---|
|`${V:-default}`|default אם ריק/לא מוגדר|
|`${V:=default}`|default + מגדיר את המשתנה|
|`${V:+alternate}`|alternate אם המשתנה **כן** מוגדר|
|`${V:?error msg}`|שגיאה אם ריק/לא מוגדר|

---

### `${VAR##pattern}` - String Manipulation

```bash
FILEPATH="/home/david/project/app.tar.gz"

# הסרת הכל עד / האחרון (basename)
echo "${FILEPATH##*/}"
# Output: app.tar.gz

# הסרת הכל אחרי . הראשון (extension מלא)
echo "${FILEPATH%%.*}"
# Output: /home/david/project/app

# הסרת הכל אחרי . האחרון (extension אחרון)
FILENAME="app.tar.gz"
echo "${FILENAME##*.}"
# Output: gz

# החלפה
VERSION="v1.2.3"
echo "${VERSION#v}"
# Output: 1.2.3
```

**סיכום Pattern Stripping:**

|Syntax|Description|
|---|---|
|`${V#pattern}`|הסרת Prefix קצר ביותר|
|`${V##pattern}`|הסרת Prefix ארוך ביותר|
|`${V%pattern}`|הסרת Suffix קצר ביותר|
|`${V%%pattern}`|הסרת Suffix ארוך ביותר|

---

### `exec` - Process Replacement

מחליף את ה-Shell הנוכחי בתהליך אחר (ה-Shell נעלם, התהליך החדש יורש את ה-PID).

```bash
# שימוש נפוץ ב-Docker Entrypoint scripts:
#!/bin/bash
# setup...
export DB_URL="..."

# מחליף את הshell באפליקציה (כך שהאפליקציה היא PID 1)
exec python app.py
```

> **למה `exec` ב-Docker?** כי Docker שולח Signals (SIGTERM) ל-PID 1. בלי `exec`, PID 1 הוא ה-Shell script ולא האפליקציה - והאפליקציה לא מקבלת את ה-Signal ולא נסגרת כמו שצריך.

---

> **End of Document**
> 
> מסמך זה מכסה את כל הפקודות שנלמדו בקורס. העתק-הדבק לאובסידיאן ושמור כ-`Linux-Commands-Field-Guide.md`.  
> מומלץ לקשר מתוך קבצי Lab ספציפיים עם `[[Linux-Commands-Field-Guide#command-name]]`.

---

זהו - כל 25 הסעיפים, מההתחלה ועד הסוף. 