# Linux Lab 2.4 - Getting Started with Users

> Lab 2.4 from IITC DevOps course. Completed 2026-03-08.
> Score: 100/100

## Lab Overview

Introduction to user management in Linux — understanding user identity, creating users with `adduser` vs `useradd`, switching between users, and reading `/etc/passwd`.

## Commands Learned

| Command | What It Does | Example |
|---------|-------------|---------|
| `whoami` | Display current user | `whoami` |
| `cat /etc/passwd` | Show all user records | `cat /etc/passwd` |
| `cat /etc/passwd \| grep <user>` | Find specific user record | `cat /etc/passwd \| grep david` |
| `sudo adduser <name>` | Create user (friendly, interactive) | `sudo adduser alice` |
| `sudo useradd <name>` | Create user (bare-bones) | `sudo useradd bob` |
| `su - <name>` | Switch to user with full login shell | `su - alice` |
| `exit` | Return to previous user | `exit` |
| `ls /home` | List home directories | `ls /home` |
| `ls -ld /home/<name>` | Check home directory ownership/permissions | `ls -ld /home/alice` |
| `sudo mkdir /home/<name>` | Manually create home directory | `sudo mkdir /home/bob` |
| `sudo chown <user>:<group> <path>` | Change file/directory ownership | `sudo chown bob:bob /home/bob` |
| `sudo passwd <name>` | Set/change user password | `sudo passwd bob` |
| `cut -d: -f1 /etc/passwd` | Extract usernames from passwd file | `cut -d: -f1 /etc/passwd` |

---

## /etc/passwd Format

Every user has a line in `/etc/passwd` with 7 colon-separated fields:

```
username:password:UID:GID:description:home:shell
```

| Field | Meaning | Example |
|-------|---------|---------|
| `username` | Login name | `david` |
| `password` | `x` means password stored in /etc/shadow | `x` |
| `UID` | User ID number | `1000` |
| `GID` | Primary group ID | `1000` |
| `description` | Full name or comment (GECOS field) | `David Rubin,,,` |
| `home` | Home directory path | `/home/david` |
| `shell` | Default login shell | `/bin/bash` |

### Service Accounts vs Real Users

| Type | UID Range | Shell | Home | Purpose |
|------|-----------|-------|------|---------|
| Root | 0 | `/bin/bash` | `/root` | Superuser |
| Service accounts | 1-999 | `/usr/sbin/nologin` | `/var/...` or `/nonexistent` | Run daemons (sshd, www-data, nobody) |
| Real users | 1000+ | `/bin/bash` | `/home/<name>` | Human users |

---

## adduser vs useradd

| Feature | adduser | useradd |
|---------|---------|---------|
| Creates home directory | Yes | No |
| Copies /etc/skel files | Yes | No |
| Prompts for password | Yes | No |
| Creates user group | Yes | Yes |
| Sets default shell | `/bin/bash` | `/bin/sh` |
| Copies .bashrc/.profile | Yes | No |
| Interactive | Yes (prompts for name, room, phone) | No |
| Use case | Creating real users | Scripts, service accounts |

### adduser in action

```bash
sudo adduser alice
```

Automatically:
1. Creates user record in `/etc/passwd`
2. Creates group `alice` in `/etc/group`
3. Creates `/home/alice`
4. Copies `.bashrc`, `.profile`, `.bash_logout` from `/etc/skel`
5. Prompts for password
6. Prompts for full name, room number, phone (optional)

Result — fully working user:

```bash
su - alice
whoami        # alice
pwd           # /home/alice
ls -la        # .bashrc, .profile, .bash_logout all present
```

### useradd in action

```bash
sudo useradd bob
```

Only:
1. Adds line to `/etc/passwd`
2. Creates group `bob`

Result — broken user:

```bash
su - bob      # Authentication failure (no password set)
ls /home/bob  # No such file or directory
```

### Fixing a useradd user manually

```bash
sudo mkdir /home/bob
sudo chown bob:bob /home/bob
sudo passwd bob
# Enter new password...

su - bob
whoami        # bob
pwd           # /home/bob
ls -la        # empty — no .bashrc, no .profile
```

The user works now but has no shell config files. The home directory is bare.

---

## su vs su - (The Hyphen Matters)

| Command | What Happens | Environment | Working Directory |
|---------|-------------|-------------|-------------------|
| `su alice` | Partial switch | Keeps original user's environment | Stays in current directory |
| `su - alice` | Full login shell | Loads alice's .bashrc, .profile, PATH | Changes to /home/alice |

**Always use `su -`** — bare `su` inherits the previous user's environment, which leads to confusing behavior (wrong PATH, wrong home, wrong prompt).

---

## Key Observations

- **Every action runs under a user identity** — UID determines what you can access
- **`/etc/passwd` is readable by everyone** — it's not a security risk because passwords are in `/etc/shadow`
- **Home directory in `/etc/passwd` doesn't mean it exists** — `useradd` proves this
- **`adduser` is a Debian/Ubuntu wrapper** — not available on all distros (RHEL/CentOS use `useradd` with flags)
- **`cut` is a text processing tool** — `-d:` sets delimiter, `-f1` selects field number
- **`chown user:group`** — sets both owner and group in one command

## Iron Rules

1. **Always use `su -` (with hyphen) for full login shell** — bare `su` inherits wrong environment
2. **`useradd` creates a record, not a working user** — prefer `adduser` for interactive use
3. **A user without a password cannot authenticate via `su`** — `useradd` doesn't set one
4. **Home directory defined in `/etc/passwd` does not mean it physically exists** — verify with `ls -ld`
5. **Service accounts use `/usr/sbin/nologin` on purpose** — they should never get an interactive shell
