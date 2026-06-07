# Bash Scripting Fundamentals

> Class session: 2026-03-12. IITC DevOps course.
> Topic: Introduction to Bash scripting - variables, user input, conditional logic.

---

## The Paradigm Shift: CLI User → Ops Engineer

Until now, you typed commands manually. That's the CLI user mindset.

The Ops Engineer mindset is different: **if you do something more than once, automate it**.

> "A script is a sequence of commands someone would do manually - packaged in a file."

A script is not magic. It's exactly what you'd type in the terminal, written down so the computer can repeat it for you.

---

## What Makes a Text File a Script

Two things:

1. **Shebang** on line 1: `#!/bin/bash` - tells the OS which interpreter to use
2. **Execute permission**: `chmod +x script.sh` - makes it runnable

```bash
#!/bin/bash
echo "Hello, World!"
```

```bash
chmod +x hello.sh
./hello.sh
```

The `.sh` extension is **convention only** - Linux doesn't care about extensions. What matters is the shebang and the execute bit.

---

## Variables

```bash
NAME="David"          # assign (no spaces around =)
echo $NAME            # reference with $
echo "Hello, $NAME"   # double quotes expand variables
echo 'Hello, $NAME'   # single quotes protect - prints literally
```

**Rules:**
- No spaces around `=` in assignment - Bash is unforgiving. `NAME = "David"` fails.
- `UPPER_CASE` is the convention for variables (though not enforced)
- Reference with `$NAME` or `${NAME}` (braces needed for disambiguation)
- Double quotes: variables are expanded inside
- Single quotes: everything is literal, no expansion

---

## Command Substitution

Capture the output of a command and store it in a variable:

```bash
CURRENT_USER=$(whoami)
TODAY=$(date +"%Y-%m-%d")
echo "Running as $CURRENT_USER on $TODAY"
```

The `$( )` syntax runs the command inside and replaces itself with the output.

---

## Arithmetic

```bash
A=5
B=3
RESULT=$(( A + B ))
echo "Result: $RESULT"    # 8
```

Use `$(( ))` for arithmetic. Regular `$( )` is for commands.

---

## User Input

```bash
read NAME                    # waits for input, stores in NAME
read -p "Enter name: " NAME  # inline prompt (no newline before input)
read -s PASSWORD             # silent input (for passwords - nothing echoed)
```

---

## Conditional Logic

```bash
if [ condition ]; then
    # runs if condition is true
elif [ other_condition ]; then
    # runs if other_condition is true
else
    # runs if nothing matched
fi
```

**`fi` = `if` backwards.** Bash closes blocks with the reverse: `if`/`fi`, `case`/`esac`, `do`/`done`.

### Numeric Comparison Operators

| Operator | Meaning | Note |
|----------|---------|------|
| `-eq` | equal to | Can't use `==` for numbers in `[ ]` |
| `-ne` | not equal to | |
| `-gt` | greater than | Can't use `>` - it's a redirect |
| `-lt` | less than | Can't use `<` - it's a redirect |
| `-ge` | greater than or equal | |
| `-le` | less than or equal | |

Why `-gt` instead of `>`? Because `>` already means output redirection in Bash. The language reuses those symbols so `-gt` avoids the conflict.

### File Test Operators

| Operator | Meaning |
|----------|---------|
| `-f file` | File exists (and is a regular file) |
| `-d dir` | Directory exists |
| `-e path` | Path exists (file or directory) |

### Example

```bash
read -p "Enter your age: " AGE

if [ $AGE -ge 18 ]; then
    echo "Adult"
elif [ $AGE -ge 13 ]; then
    echo "Teenager"
else
    echo "Child"
fi
```

---

## Special Variables

| Variable | Contains |
|----------|---------|
| `$0` | Name of the script itself |
| `$1`, `$2`... | Command-line arguments |
| `$?` | Exit code of the last command (0 = success) |
| `$$` | PID of the current script |

---

## Scripts Run in the Caller's Directory

If your script is at `/home/david/scripts/backup.sh` and you run it from `/tmp`:

```bash
cd /tmp
./home/david/scripts/backup.sh
```

The script's working directory is `/tmp` - **where you are, not where the script is**.

This catches many beginners. If your script references relative paths, they resolve from where you ran the script, not from the script's location.

---

## Iron Rules

- **"Script = commands someone would do manually, packaged in a file"**
- **"No spaces around `=` in variable assignment - Bash is unforgiving"**
- **"Double quotes expand, single quotes protect"**
- **"`>` redirects exist so Bash uses `-gt` for greater-than"**
- **"Shebang + `chmod +x` = the two things that make text executable"**
- **"A script runs where YOU are, not where IT is"**

---

## Exercises

### Exercise 1 — hello.sh

**Practices:** echo, shebang, execute permission

```bash
#!/bin/bash
echo "Hello, World!"
echo "Welcome to Bash scripting."
```

**Expected output:**
```
Hello, World!
Welcome to Bash scripting.
```

---

### Exercise 2 — whoami.sh

**Practices:** command substitution with `$(whoami)`

```bash
#!/bin/bash
USER=$(whoami)
echo "You are logged in as: $USER"
```

**Expected output:**
```
You are logged in as: david
```

---

### Exercise 3 — datetime.sh

**Practices:** command substitution with `$(date)`

```bash
#!/bin/bash
NOW=$(date)
echo "Current date and time: $NOW"
```

**Expected output:**
```
Current date and time: Thu Mar 12 19:45:02 UTC 2026
```

---

### Exercise 4 — sysinfo.sh

**Practices:** hostname, variables, multiple command substitutions

```bash
#!/bin/bash
USER=$(whoami)
HOST=$(hostname)
echo "User: $USER"
echo "Host: $HOST"
echo "Running as $USER on $HOST"
```

**Expected output:**
```
User: david
Host: ubuntu-lab
Running as david on ubuntu-lab
```

---

### Exercise 5 — mkdir.sh

**Practices:** `mkdir -p`, echo confirmation, variables

```bash
#!/bin/bash
DIR="my_project"
mkdir -p $DIR
echo "Directory created: $DIR"
```

**Expected output:**
```
Directory created: my_project
```

---

### Exercise 6 — createfile.sh

**Practices:** `echo >` to create file, `cat` to verify

```bash
#!/bin/bash
FILENAME="notes.txt"
echo "This is my first script-generated file." > $FILENAME
echo "File created: $FILENAME"
cat $FILENAME
```

**Expected output:**
```
File created: notes.txt
This is my first script-generated file.
```

---

### Exercise 7 — listfiles.sh

**Practices:** `ls -lh`, calling a command from a script

```bash
#!/bin/bash
echo "Files in current directory:"
ls -lh
```

**Expected output:**
```
Files in current directory:
total 32K
-rwxr-xr-x 1 david david  85 Mar 12 19:30 hello.sh
-rwxr-xr-x 1 david david  90 Mar 12 19:31 whoami.sh
...
```

---

### Exercise 8 — diskspace.sh

**Practices:** `df -h`, system info commands

```bash
#!/bin/bash
echo "Disk usage:"
df -h
```

**Expected output:**
```
Disk usage:
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        20G  3.5G   16G  18% /
tmpfs           997M     0  997M   0% /dev/shm
```

---

### Exercise 9 — countfiles.sh

**Practices:** `ls | wc -l`, pipes, command substitution

```bash
#!/bin/bash
COUNT=$(ls | wc -l)
echo "Number of items in current directory: $COUNT"
```

**Expected output:**
```
Number of items in current directory: 9
```

---

### Exercise 10 — filesize.sh

**Practices:** `du -sh`, `cut -f1`, chained commands

```bash
#!/bin/bash
FILE="notes.txt"
SIZE=$(du -sh $FILE | cut -f1)
echo "Size of $FILE: $SIZE"
```

**Expected output:**
```
Size of notes.txt: 4.0K
```

---

### Exercise 11 — appendfile.sh

**Practices:** `>>` append vs `>` overwrite

```bash
#!/bin/bash
LOG="log.txt"
echo "First line" > $LOG
echo "Second line" >> $LOG
echo "Third line" >> $LOG
echo "Contents of $LOG:"
cat $LOG
```

**Expected output:**
```
Contents of log.txt:
First line
Second line
Third line
```

---

### Exercise 12 — searchfile.sh

**Practices:** `grep -i`, searching inside files

```bash
#!/bin/bash
FILE="log.txt"
TERM="error"
echo "Searching for '$TERM' in $FILE:"
grep -i $TERM $FILE
```

**Expected output (if log.txt contains "ERROR"):**
```
Searching for 'error' in log.txt:
ERROR: something went wrong
```

---

### Exercise 13 — backupfile.sh

**Practices:** `date` formatting with `+"%Y-%m-%d"`, variable in filename

```bash
#!/bin/bash
SOURCE="notes.txt"
DATE=$(date +"%Y-%m-%d")
BACKUP="notes_backup_$DATE.txt"
cp $SOURCE $BACKUP
echo "Backed up $SOURCE to $BACKUP"
```

**Expected output:**
```
Backed up notes.txt to notes_backup_2026-03-12.txt
```

---

### Exercise 14 — logger.sh

**Practices:** combining `date` + `whoami` in formatted output, `>>` append

```bash
#!/bin/bash
LOG="activity.log"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
USER=$(whoami)
echo "[$TIMESTAMP] $USER ran this script" >> $LOG
echo "Log entry added to $LOG"
cat $LOG
```

**Expected output:**
```
Log entry added to activity.log
[2026-03-12 19:45:30] david ran this script
```

---

### Exercise 15 — scriptname.sh

**Practices:** special variable `$0`

```bash
#!/bin/bash
echo "This script is named: $0"
echo "Running from: $(pwd)"
```

**Expected output:**
```
This script is named: ./scriptname.sh
Running from: /home/david/scripts
```

---

### Exercise 16 — reverse.sh

**Practices:** `echo | rev`, pipes

```bash
#!/bin/bash
WORD="devops"
REVERSED=$(echo $WORD | rev)
echo "Original: $WORD"
echo "Reversed: $REVERSED"
```

**Expected output:**
```
Original: devops
Reversed: spoved
```

---

### Exercise 17 — replace.sh

**Practices:** `sed -i 's/old/new/g'` in-place substitution

```bash
#!/bin/bash
FILE="notes.txt"
echo "Before:"
cat $FILE
sed -i 's/first/updated/g' $FILE
echo "After (replaced 'first' with 'updated'):"
cat $FILE
```

**Expected output:**
```
Before:
This is my first script-generated file.
After (replaced 'first' with 'updated'):
This is my updated script-generated file.
```

---

### Exercise 18 — wordcount.sh

**Practices:** `wc -w`, input redirection `<`

```bash
#!/bin/bash
FILE="notes.txt"
WORDS=$(wc -w < $FILE)
echo "Word count in $FILE: $WORDS"
```

**Expected output:**
```
Word count in notes.txt: 8
```

---

### Exercise 19 — archive.sh

**Practices:** `tar -czf`, `du -sh`, creating compressed archives

```bash
#!/bin/bash
ARCHIVE="scripts_backup.tar.gz"
tar -czf $ARCHIVE *.sh
SIZE=$(du -sh $ARCHIVE | cut -f1)
echo "Archive created: $ARCHIVE ($SIZE)"
```

**Expected output:**
```
Archive created: scripts_backup.tar.gz (8.0K)
```

---

### Exercise 20 — summary.sh

**Practices:** combining all concepts - variables, command substitution, arithmetic, formatting

```bash
#!/bin/bash
USER=$(whoami)
HOST=$(hostname)
DATE=$(date +"%Y-%m-%d")
FILES=$(ls *.sh | wc -l)
DISK=$(df -h / | tail -1 | awk '{print $5}')

echo "==============================="
echo "  System Summary Report"
echo "==============================="
echo "User     : $USER"
echo "Host     : $HOST"
echo "Date     : $DATE"
echo "Scripts  : $FILES bash scripts in this folder"
echo "Disk use : $DISK used on /"
echo "==============================="
```

**Expected output:**
```
===============================
  System Summary Report
===============================
User     : david
Host     : ubuntu-lab
Date     : 2026-03-12
Scripts  : 20 bash scripts in this folder
Disk use : 18% used on /
===============================
```
