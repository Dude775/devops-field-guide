# Shared Server Scenario Lab - Bonus Lab

> Bonus Lab from IITC DevOps course (lirone fitoussi). GitHub release v1.1-scenario. Completed 2026-03-10.
> Score: Bonus (100 points when becomes mandatory)

## Lab Overview

A real-world simulation: three team members share a development server. The mission — set it up correctly from scratch. Users need to be created, a team group configured, the project directory secured, logs analyzed, and a mysterious permission bug debugged.

**The team:**
- `dev1`, `dev2` — developers, need full access to `/opt/project`
- `ops1` — operations, needs admin (sudo) access, not a developer

**The server:** `/opt/project` with 6 subdirectories: `backups/`, `config/`, `docs/`, `logs/`, `scripts/`, `src/`

---

## Level 1 - Building the Team

### Exercise 1: Creating Users

Create the three team members using `adduser` (interactive, sets up home directory and password automatically).

```bash
sudo adduser dev1
sudo adduser dev2
sudo adduser ops1
```

Each user gets a UID assigned sequentially. Verify:

```bash
id dev1
# uid=1001(dev1) gid=1001(dev1) groups=1001(dev1)

id dev2
# uid=1002(dev2) gid=1002(dev2) groups=1002(dev2)

id ops1
# uid=1003(ops1) gid=1003(ops1) groups=1003(ops1)
```

> **Why `adduser` and not `useradd`?** `adduser` is the Ubuntu-friendly wrapper — it creates the home directory, copies `.bashrc`/`.profile` from `/etc/skel`, and prompts for a password. `useradd` is bare-bones and leaves you with a broken user. For real people: always `adduser`.

---

### Exercise 2: Group Setup

Create a shared group for the development team and add `dev1` and `dev2`. `ops1` is excluded — they're operations, not a developer.

```bash
sudo groupadd devteam

sudo usermod -aG devteam dev1
sudo usermod -aG devteam dev2
# ops1 intentionally NOT added
```

Verify group membership:

```bash
groups dev1
# dev1 : dev1 devteam

groups dev2
# dev2 : dev2 devteam

groups ops1
# ops1 : ops1    ← no devteam
```

> **`-aG` means Append to Group** — the `-a` flag is critical. Without it, `usermod -G devteam dev1` would *replace* all existing groups with just `devteam`. Always use `-aG` to add without removing.

---

### Exercise 3: Project Exploration

Explore what's already on the server before touching anything.

```bash
ls -lR /opt/project
```

**What you see:**
- 6 subdirectories: `backups/`, `config/`, `docs/`, `logs/`, `scripts/`, `src/`
- All owned by `root:root`
- Permissions: `drwxr-xr-x` (755) — everyone can read and enter, only root can write

The developers can browse but can't create or modify anything yet. This is the problem to fix in Level 2.

---

## Level 2 - Securing the Server

### Exercise 1: Ownership & Permissions

Transfer group ownership to `devteam` and lock out everyone else.

```bash
# Transfer group ownership (keep root as owner)
sudo chown -R root:devteam /opt/project

# Set permissions: owner=rwx, group=rwx, others=---
sudo chmod -R 770 /opt/project
```

**Verify — switch to dev1 and test:**

```bash
su - dev1
whoami         # dev1
cd /opt/project
touch test.txt  # succeeds — dev1 has group write access
ls -l          # test.txt visible
exit
```

**Verify the permissions are correct:**

```bash
ls -la /opt/project
# drwxrwx---  root devteam ...  backups
# drwxrwx---  root devteam ...  config
# drwxrwx---  root devteam ...  docs
# ...
```

> **Why `chown root:devteam` and not `chown devteam:devteam`?** We're separating ownership from group access. Root remains the owner (admin control), but `devteam` gets group-level read/write/execute. This is the professional pattern — `770` means "trust the team, block the world."

---

### Exercise 2: Log Analysis

The file `/opt/project/logs/app.log` contains server logs. Analyze them for errors and suspicious activity.

**Count errors and warnings:**

```bash
grep -c ERROR /opt/project/logs/app.log
# 8

grep -c WARN /opt/project/logs/app.log
# 13
```

**Find suspicious activity — case-insensitive search:**

```bash
grep -i "failed" /opt/project/logs/app.log
grep -i "unauthorized" /opt/project/logs/app.log
grep "203.0.113.42" /opt/project/logs/app.log
```

**What was found:** Three failed login attempts from `203.0.113.42` — an external IP, not an internal address. This is a brute-force pattern.

```bash
grep -c "203.0.113.42" /opt/project/logs/app.log
# 3
```

> **Three failed logins from an external IP is not a coincidence — it's an attack.** The `203.0.113.0/24` range is RFC 5737 documentation space, but in a real scenario this would warrant immediate investigation: IP block, fail2ban rule, or security team alert.

---

### Exercise 3: Redirection & File Search

Create a server report and find all log files.

**The redirection problem:** `/opt/project` is owned by `root`. Even if you're in `sudo`, the shell redirect (`>`) runs as your user — so `sudo echo "text" > /opt/project/report.txt` fails with permission denied.

**The fix — use `tee`:**

```bash
# Create the report (overwrite)
echo "=== Server Report ===" | sudo tee /opt/project/server_report.txt

# Append additional sections
echo "Date: $(date)" | sudo tee -a /opt/project/server_report.txt
echo "Users: dev1, dev2, ops1" | sudo tee -a /opt/project/server_report.txt
echo "Errors found: 8" | sudo tee -a /opt/project/server_report.txt
echo "Suspicious IP: 203.0.113.42 (3 failed attempts)" | sudo tee -a /opt/project/server_report.txt
```

> **Why `tee` and not `>`?** `sudo` only elevates the command itself — the shell redirect (`>`) still runs as your original user. `sudo tee` runs the write operation as root, so it succeeds. This is one of the most common sudo gotchas in real sysadmin work.

**Find all log files in the project:**

```bash
find /opt/project -name "*.log"
# /opt/project/logs/app.log
# /opt/project/logs/error.log
# /opt/project/logs/access.log
```

3 log files found.

---

## Level 3 - Operations & Debugging

### Exercise 1: Admin Access for ops1

`ops1` needs to run administrative commands. In Ubuntu, admin access is granted through the `sudo` group.

```bash
sudo usermod -aG sudo ops1
```

**Test — switch to ops1 and verify:**

```bash
su - ops1
sudo cat /etc/shadow
# [prompts for ops1 password, then shows shadow file]
# root:!:...:::::
# david:$6$...:::::
# dev1:$6$...:::::
```

`/etc/shadow` is readable only by root. `ops1` can now access it via sudo — confirming admin access works.

> **`/etc/shadow` vs `/etc/passwd`:** `/etc/passwd` is world-readable (everyone can list users). `/etc/shadow` contains the actual password hashes — readable by root only. When a user authenticates, the system compares against `/etc/shadow`.

---

### Exercise 2: Permission Mystery — Debug & Fix

**The symptom:** `dev2` suddenly can't write to `/opt/project`. `dev1` works fine.

**Systematic debugging:**

```bash
# Step 1: Check the directory permissions
ls -la /opt/project
# drwxrwx--- root devteam  ← correct, group has rwx

# Step 2: Check what groups dev2 is in
id dev2
# uid=1002(dev2) gid=1002(dev2) groups=1002(dev2),1005(it)
# ← devteam is MISSING

# Step 3: Compare with dev1 (who works)
id dev1
# uid=1001(dev1) gid=1001(dev1) groups=1001(dev1),1003(devteam)
# ← devteam is present

# Root cause found: dev2 was removed from devteam and placed in "it" group
```

**The fix:**

```bash
sudo usermod -aG devteam dev2
```

**Verify the fix:**

```bash
# Check groups updated
id dev2
# uid=1002(dev2) gid=1002(dev2) groups=1002(dev2),1003(devteam),1005(it)

# Test write access
su - dev2
touch /opt/project/dev2_test.txt   # succeeds
ls -l /opt/project/dev2_test.txt   # visible
exit
```

Fixed. `dev2` can write again.

> **Important:** Group changes take effect on next login. If `dev2` is already logged in, they need to log out and back in (or run `newgrp devteam`) for the change to apply to their current session.

---

## Commands Reference

| Command | Purpose | Example |
|---------|---------|---------|
| `sudo adduser <name>` | Create user (interactive, full setup) | `sudo adduser dev1` |
| `sudo groupadd <name>` | Create a new group | `sudo groupadd devteam` |
| `sudo usermod -aG <group> <user>` | Add user to group (append) | `sudo usermod -aG devteam dev1` |
| `id <user>` | Show UID, GID, and all groups | `id dev2` |
| `groups <user>` | Show groups a user belongs to | `groups ops1` |
| `su - <user>` | Switch to user with full login shell | `su - dev1` |
| `whoami` | Show current user | `whoami` |
| `exit` | Return to previous user | `exit` |
| `sudo chown -R owner:group path` | Recursive ownership change | `sudo chown -R root:devteam /opt/project` |
| `sudo chmod -R 770 path` | Recursive permission set (rwxrwx---) | `sudo chmod -R 770 /opt/project` |
| `ls -lR path` | Recursive long listing | `ls -lR /opt/project` |
| `grep -c PATTERN file` | Count matching lines | `grep -c ERROR app.log` |
| `grep -i PATTERN file` | Case-insensitive search | `grep -i "failed" app.log` |
| `grep "pattern" file` | Basic pattern search | `grep "203.0.113.42" app.log` |
| `find path -name "*.ext"` | Find files by extension | `find /opt/project -name "*.log"` |
| `echo "text" \| sudo tee file` | Write to root-owned file | `echo "report" \| sudo tee report.txt` |
| `echo "text" \| sudo tee -a file` | Append to root-owned file | `echo "line" \| sudo tee -a report.txt` |
| `touch file` | Verify write access (create empty file) | `touch /opt/project/test.txt` |
| `sudo cat /etc/shadow` | Read password hashes (root only) | `sudo cat /etc/shadow` |

---

## Key Takeaways

1. **`-aG` is not optional** — `usermod -G` without `-a` removes all existing groups. Always append.
2. **`chown owner:group` separates who owns from who can access** — `root:devteam` keeps admin control while enabling team collaboration.
3. **`sudo` doesn't elevate shell redirects** — `sudo echo > file` fails. Use `sudo tee` instead.
4. **Debug permissions systematically** — check directory perms first, then user groups, then compare a working user against the broken one.
5. **Group changes require re-login** — `usermod -aG` takes effect on the user's next login, not immediately in an active session.

---

## Iron Rules Earned

- **"770 means trust the team, block the world"** — group-only access is the right pattern for shared project directories
- **"sudo only elevates the command, not the redirect"** — use `tee` when writing to root-owned files with sudo
- **"Debug permissions systematically: directory perms → user groups → compare working vs broken"**
- **"Three failed logins from an external IP is not a coincidence — it's an attack"**
