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

| Flag | Name | Description |
|------|------|-------------|
| `-l` | Long format | תצוגה מפורטת - הרשאות, בעלים, גודל, תאריך שינוי |
| `-a` | All | מציג גם קבצים מוסתרים (שמתחילים בנקודה `.`) |
| `-h` | Human readable | גדלים קריאים (KB, MB, GB) במקום בתים |
| `-R` | Recursive | מציג גם את תוכן תתי-תיקיות |
| `-t` | Time sort | ממיין לפי זמן שינוי (החדש ביותר קודם) |
| `-S` | Size sort | ממיין לפי גודל (הגדול ביותר קודם) |
| `-r` | Reverse | הופך את סדר המיון |

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

| Shortcut | Description |
|----------|-------------|
| `..` | תיקייה אחת למעלה (parent) |
| `~` | תיקיית הבית של המשתמש הנוכחי (`/home/username`) |
| `-` | חזרה לתיקייה הקודמת (כמו "Back") |
| `/` | שורש מערכת הקבצים (root) |

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

> **טיפ:** <u>**`cd -`**</u> מאוד שימושי כשעובדים בין שתי תיקיות - הוא עושה "קפיצה" הלוך וחזור.

---

### `pwd` - Print Working Directory

מדפיסה את הנתיב המלא (Absolute Path) של התיקייה שאתה נמצא בה כרגע. שימושי כשאתה "אבוד" במערכת הקבצים.

```bash
pwd
# Output: /home/david/projects/devops-field-guide
```

> אין דגלים מיוחדים. פשוט מציג איפה אתה.

---

### `mkdir` - Make Directory

יוצרת תיקייה חדשה. אחת הפקודות הבסיסיות ביותר.

**דגלים עיקריים:**

| Flag | Description |
|------|-------------|
| `-p` | יוצר את כל שרשרת התיקיות (Parents) - אם תיקיית אב לא קיימת, היא תיווצר אוטומטית |
| `-v` | Verbose - מדפיס הודעה על כל תיקייה שנוצרת |

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

| Flag | Description |
|------|-------------|
| `-p` | מוחק את כל שרשרת תיקיות האב הריקות |
| `-v` | Verbose - מדפיס מה נמחק |

```bash
# מחיקת תיקייה ריקה
rmdir old_temp

# מחיקת שרשרת תיקיות ריקות
rmdir -p old/archive/2024
```

> **בפרקטיקה:** משתמשים יותר ב-<u>**`rm -r`**</u> כי `rmdir` עובד רק על תיקיות ריקות. אבל `rmdir` בטוח יותר - הוא לא ימחק בטעות תיקייה עם תוכן.

---

### `cp` - Copy Files and Directories

מעתיקה קבצים ותיקיות. יוצרת עותק חדש ועצמאי (הקובץ המקורי לא מושפע).

**דגלים עיקריים:**

| Flag | Description |
|------|-------------|
| `-r` | Recursive - חובה כשמעתיקים תיקיות (מעתיק את כל התוכן) |
| `-v` | Verbose - מציג כל קובץ שמועתק |
| `-i` | Interactive - שואל לפני דריסת קובץ קיים |
| `-n` | No clobber - לא דורס קובץ קיים בשום מקרה |
| `-p` | Preserve - שומר על הרשאות, בעלות ותאריכים |
| `-a` | Archive - שווה ל-`-rpL` - שומר הכל כולל Symlinks |

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

> **חשוב:** שכחת `-r` בהעתקת תיקייה היא טעות נפוצה - תקבל שגיאה "omitting directory".

---

### `mv` - Move / Rename

מעבירה קובץ למיקום אחר, או משנה את שמו. שלא כמו `cp`, הקובץ המקורי נעלם.

**דגלים עיקריים:**

| Flag | Description |
|------|-------------|
| `-i` | Interactive - שואל לפני דריסת קובץ קיים |
| `-n` | No clobber - לא דורס בשום מקרה |
| `-v` | Verbose - מציג מה הועבר |

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

> **שימו לב:** ב-Linux אין פקודת "rename" נפרדת - `mv` עושה את שני הדברים. אם היעד הוא אותה תיקייה עם שם שונה - זה rename. אם היעד הוא תיקייה אחרת - זה move.

---

### `rm` - Remove Files and Directories

מוחקת קבצים ותיקיות. **אין פה Recycle Bin** - מה שנמחק, נמחק לצמיתות.

**דגלים עיקריים:**

| Flag | Description |
|------|-------------|
| `-r` | Recursive - מוחק תיקייה וכל תוכנה |
| `-f` | Force - לא שואל שאלות, לא מציג שגיאות |
| `-i` | Interactive - שואל על כל קובץ לפני מחיקה |
| `-v` | Verbose - מציג מה נמחק |

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

> **אזהרה קריטית:** <u>**`rm -rf /`**</u> ימחק את כל המערכת. תמיד בדוק פעמיים את הנתיב לפני שמריץ `rm -rf`. אין Undo.

---

### `touch` - Create or Update File

יוצרת קובץ ריק חדש, או מעדכנת את ה-Timestamp של קובץ קיים (בלי לשנות את תוכנו).

**דגלים:**

| Flag | Description |
|------|-------------|
| `-a` | מעדכן רק את Access Time |
| `-m` | מעדכן רק את Modification Time |
| `-t` | מגדיר תאריך ספציפי (פורמט: `YYYYMMDDhhmm`) |

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

| Flag | Description |
|------|-------------|
| `-s` | Symbolic (Soft) Link - יוצר קיצור דרך |
| `-f` | Force - דורס Link קיים |

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

| Flag | Description |
|------|-------------|
| `-L [n]` | מגביל עומק הצגה ל-n רמות |
| `-d` | מציג תיקיות בלבד (ללא קבצים) |
| `-a` | מציג גם קבצים מוסתרים |
| `-I [pattern]` | מתעלם מתבנית (למשל `node_modules`) |

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

| Flag | Description |
|------|-------------|
| `-name "pattern"` | חיפוש לפי שם (case sensitive) |
| `-iname "pattern"` | חיפוש לפי שם (case insensitive) |
| `-type f` | קבצים בלבד |
| `-type d` | תיקיות בלבד |
| `-mtime -N` | שונו בN- הימים האחרונים |
| `-mtime +N` | שונו לפני יותר מ-N ימים |
| `-size +100M` | גדולים מ-100MB |
| `-perm 755` | בעלי הרשאות ספציפיות |
| `-exec CMD {} \;` | מריץ פקודה על כל תוצאה |
| `-maxdepth N` | מגביל עומק חיפוש |
| `-empty` | קבצים או תיקיות ריקות |

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

> **טיפ DevOps:** <u>**`find / -perm -4000`**</u> מוצא את כל הקבצים עם SUID bit - חשוב לסריקות אבטחה.

---

### `du` - Disk Usage (Folders)

מציגה כמה מקום תופסת תיקייה (ותתי-תיקיות). שימושי לאיתור "בלעני מקום".

**דגלים עיקריים:**

| Flag | Description |
|------|-------------|
| `-h` | Human readable (KB/MB/GB) |
| `-s` | Summary - רק סיכום כולל (לא תתי-תיקיות) |
| `-d N` | עומק מקסימלי N |
| `--max-depth=1` | מציג רק רמה אחת |

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

| Flag | Description |
|------|-------------|
| `-h` | Human readable |
| `-T` | מציג את סוג ה-Filesystem (ext4, xfs, tmpfs...) |
| `-i` | מציג Inodes במקום בלוקים |

**דוגמאות:**

```bash
# סטטוס כל הדיסקים בפורמט קריא
df -hT

# בדיקת Inode usage (חשוב! דיסק יכול להיתקע גם אם יש מקום פנוי)
df -hi

# רק Filesystem ספציפי
df -h /dev/sda1
```

> **תרחיש DevOps:** שרת מדווח "No space left on device" אבל `df -h` מראה 40% פנוי? בדוק <u>**`df -i`**</u> - יתכן שנגמרו Inodes (קורה עם מיליוני קבצים קטנים).

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
> - **Access** - מתי הקובץ נקרא לאחרונה
> - **Modify** - מתי התוכן שונה לאחרונה
> - **Change** - מתי ה-Metadata (הרשאות, בעלות) שונו לאחרונה

---

### `locate` - Indexed File Search

חיפוש מהיר מאוד שעובד על בסיס נתונים מקומי (אינדקס). הרבה יותר מהיר מ-`find`, אבל לא תמיד מעודכן.

**דגלים:**

| Flag | Description |
|------|-------------|
| `-i` | Ignore case |
| `-c` | מחזיר רק ספירה (כמה תוצאות) |
| `-n N` | מגביל ל-N תוצאות ראשונות |

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

| Flag | Description |
|------|-------------|
| `-a` | Archive - שומר הרשאות, בעלות, Symlinks, הכל |
| `-v` | Verbose |
| `-z` | דוחס בזמן ההעברה (חוסך Bandwidth) |
| `--delete` | מוחק ביעד קבצים שלא קיימים במקור |
| `--dry-run` | Simulation - מראה מה יקרה בלי לבצע |
| `--progress` | מציג התקדמות |
| `--exclude` | מדלג על תבנית מסוימת |

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

| Flag | Description |
|------|-------------|
| `-i` | Ignore case |
| `-v` | Invert - מציג שורות שלא מתאימות |
| `-r` | Recursive - מחפש בכל התיקיות |
| `-n` | מציג מספרי שורות |
| `-c` | ספירה - כמה שורות מתאימות |
| `-l` | מציג רק שמות קבצים (לא את השורות) |
| `-w` | Word match - התאמה למילה שלמה בלבד |
| `-A N` | מציג N שורות אחרי ההתאמה (After) |
| `-B N` | מציג N שורות לפני ההתאמה (Before) |
| `-E` | Extended Regex (שקול ל-`egrep`) |

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

> **טיפ DevOps:** <u>**`grep -r "TODO\|FIXME\|HACK" src/`**</u> - סריקה מהירה של קוד לתגיות שנשארו.

---

### `head` / `tail` - View Start / End of File

`head` מציג את תחילת הקובץ, `tail` מציג את הסוף. שימושי לקבצי Log ענקיים שאי אפשר (ולא צריך) לפתוח שלמים.

**דגלים:**

| Flag | Description |
|------|-------------|
| `-n N` | מציג N שורות (ברירת מחדל: 10) |
| `-f` | Follow - `tail` ממשיך להציג שורות חדשות בזמן אמת (Live) |
| `-F` | כמו `-f` אבל עוקב גם אם הקובץ נמחק ונוצר מחדש (Log Rotation) |

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

> **טיפ:** <u>**`tail -f`**</u> הוא אחד הכלים הכי חשובים ל-DevOps - מאפשר לראות Logs בזמן אמת כשמדבגים בעיות.

---

### `sort` - Sort Lines

ממיין שורות בקובץ או ב-Output. ברירת מחדל: מיון אלפביתי.

**דגלים עיקריים:**

| Flag | Description |
|------|-------------|
| `-n` | מיון מספרי (1, 2, 10 ולא 1, 10, 2) |
| `-r` | סדר הפוך (מהגדול לקטן) |
| `-u` | Unique - מסיר כפילויות |
| `-k N` | ממיין לפי עמודה N |
| `-t` | מגדיר Delimiter (ברירת מחדל: רווח) |
| `-h` | מיון Human readable (1K, 2M, 3G) |

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

| Flag | Description |
|------|-------------|
| `-c` | Count - מציג כמה פעמים כל שורה חזרה |
| `-d` | Duplicates only - רק שורות שחזרו |
| `-u` | Unique only - רק שורות שלא חזרו |
| `-i` | Ignore case |

**דוגמאות:**

```bash
# ספירת כמות הופעות של כל שורה (Pattern קלאסי!)
sort access.log | uniq -c | sort -nr | head -10

# מציאת כתובות IP הכי פעילות
awk '{print $1}' access.log | sort | uniq -c | sort -nr | head -10

# רק שורות שמופיעות יותר מפעם אחת
sort data.txt | uniq -d
```

> **Pattern קלאסי:** <u>**`sort | uniq -c | sort -nr`**</u> - ספירת תדירות. משתמשים בזה כל הזמן בניתוח Logs.

---

### `wc` - Word/Line Count

סופר שורות, מילים ותווים בקובץ.

**דגלים:**

| Flag | Description |
|------|-------------|
| `-l` | Lines (שורות) |
| `-w` | Words (מילים) |
| `-c` | Characters/Bytes (תווים) |
| `-m` | Characters (תווים, multi-byte aware) |

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

| Flag | Description |
|------|-------------|
| `-u` | Unified format - פורמט הכי קריא (כמו Git diff) |
| `-y` | Side by side - השוואה צד ליד צד |
| `--color` | צביעה (ירוק/אדום) |
| `-r` | Recursive - משווה תיקיות שלמות |
| `-q` | Quick - רק אומר אם שונה או לא |

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

| Flag | Description |
|------|-------------|
| `-i` | In-place - עורך את הקובץ עצמו (לא רק מדפיס) |
| `-i.bak` | In-place עם גיבוי אוטומטי |
| `-n` | Silent - מדפיס רק מה שמתבקש |
| `-E` | Extended Regex |

**פקודות sed נפוצות:**

| Pattern | Description |
|---------|-------------|
| `s/old/new/g` | החלפה (g = כל ההופעות בשורה) |
| `Nd` | מחיקת שורה N |
| `/pattern/d` | מחיקת שורות שמכילות Pattern |
| `Np` | הדפסת שורה N (עם `-n`) |
| `/pattern/a\text` | הוספת שורה אחרי Pattern |

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

| Element | Description |
|---------|-------------|
| `-F` | מגדיר Delimiter |
| `$1, $2...` | עמודה 1, 2... |
| `$0` | השורה כולה |
| `$NF` | העמודה האחרונה |
| `NR` | מספר השורה הנוכחית |
| `BEGIN{}` | קוד שרץ לפני עיבוד |
| `END{}` | קוד שרץ אחרי עיבוד |

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
> - **grep** - חיפוש שורות שמכילות Pattern
> - **sed** - חיפוש והחלפה / עריכת שורות
> - **awk** - עיבוד מבוסס עמודות / חישובים

---

### `tee` - Split Output

"מפצל" את הפלט - מציג אותו על המסך וגם כותב אותו לקובץ בו-זמנית.

**דגלים:**

| Flag | Description |
|------|-------------|
| `-a` | Append - מוסיף לקובץ קיים (במקום לדרוס) |

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

| Flag | Description |
|------|-------------|
| `-I {}` | Placeholder - מגדיר איפה הקלט יוכנס |
| `-n N` | מעביר N ארגומנטים בכל פעם |
| `-P N` | Parallel - מריץ N תהליכים במקביל |
| `-0` | Null-delimited (עובד עם `find -print0`) |

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

מחלץ עמודות ספציפיות מטקסט מובנה (CSV, TSV, וכו').

**דגלים:**

| Flag | Description |
|------|-------------|
| `-d` | Delimiter (ברירת מחדל: Tab) |
| `-f N` | שדה (עמודה) N |
| `-f N-M` | שדות N עד M |
| `-c N-M` | תווים N עד M |

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

| Flag | Description |
|------|-------------|
| `-d` | Delete - מוחק תווים |
| `-s` | Squeeze - דוחס תווים חוזרים |
| `-c` | Complement - פועל על כל תו שלא ברשימה |

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

מעביר את ה-stdout של פקודה אחת כ-stdin לפקודה הבאה. זה הלב של פילוסופיית Unix - "Do one thing well" ושרשר.

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

> **⚠️ הערה:** הקובץ נקטע בסוף ההודעה. סעיפים 6–25 יתווספו בהמשך.
