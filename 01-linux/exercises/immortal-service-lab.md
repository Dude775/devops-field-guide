# The Immortal Linux Service Lab - Bash Edition

> IITC DevOps course (lirone fitoussi). Completed 2026-03-11.
> Topic: Running a Bash script as a self-healing systemd service.

## Lab Overview

Same systemd pattern as the Node.js lab — but this time with a pure Bash script. The script runs an infinite loop, logging a heartbeat every second. The goal: kill it repeatedly and watch systemd bring it back every time.

**The script:** `~/immortal.sh` — a `while true` loop that writes a timestamp to `/tmp/immortal.log`
**The service:** `immortal.service` — same `Restart=always` + `RestartSec=3` pattern

---

## The Bash Script

```bash
#!/bin/bash
while true; do
    echo "$(date): I am immortal!" >> /tmp/immortal.log
    sleep 1
done
```

**Line-by-line:**

| Line | Meaning |
|------|---------|
| `#!/bin/bash` | Shebang — tells the OS which interpreter to use. **Required for systemd** — it doesn't assume any shell |
| `while true; do` | Infinite loop — keeps running until killed |
| `echo "$(date): ..."` | Write timestamp + message. `$(date)` runs `date` and inserts its output |
| `>> /tmp/immortal.log` | Append to log file (creates it if it doesn't exist) |
| `sleep 1` | Wait 1 second between writes — prevents CPU spinning at 100% |
| `done` | End of while block |

---

## Commands Reference

| Command | What It Does | Example |
|---------|-------------|---------|
| `nano ~/immortal.sh` | Create/edit the script file | `nano ~/immortal.sh` |
| `chmod +x ~/immortal.sh` | Make script executable | `chmod +x ~/immortal.sh` |
| `~/immortal.sh &` | Run script in background, get PID | `~/immortal.sh &` → `[1] 5821` |
| `pgrep -f immortal` | Find PID by full command-line pattern | `pgrep -f immortal` |
| `pgrep node` | Find PID by process name (binary) | `pgrep node` |
| `kill -9 <PID>` | Force-kill process (SIGKILL) | `kill -9 5821` |
| `ls -l /tmp/immortal.log` | Check log file ownership and permissions | `ls -l /tmp/immortal.log` |
| `rm /tmp/immortal.log` | Delete log before starting service mode | `rm /tmp/immortal.log` |
| `tail -f /tmp/immortal.log` | Follow log in real-time | `tail -f /tmp/immortal.log` |
| `sudo nano /etc/systemd/system/immortal.service` | Create unit file | `sudo nano /etc/systemd/system/immortal.service` |
| `sudo systemctl daemon-reload` | Reload systemd after unit file change | `sudo systemctl daemon-reload` |
| `sudo systemctl start immortal` | Start the service | `sudo systemctl start immortal` |
| `sudo systemctl status immortal` | Check service status and recent logs | `systemctl status immortal` |

---

## The Unit File

```ini
[Unit]
Description=The Immortal Bash Service
After=network.target

[Service]
ExecStart=/home/david/immortal.sh
WorkingDirectory=/home/david
StandardOutput=append:/tmp/immortal.log
StandardError=append:/tmp/immortal.log
Restart=always
RestartSec=3
User=david

[Install]
WantedBy=multi-user.target
```

**Key differences from node-demo.service:**

| Field | node-demo | immortal |
|-------|-----------|----------|
| `ExecStart` | `/usr/bin/node /home/david/app.js` | `/home/david/immortal.sh` |
| `After` | `network-online.target` | `network.target` |
| `Description` | Node.js Demo Application | The Immortal Bash Service |

Everything else — `Restart=always`, `RestartSec=3`, `User=`, `WantedBy` — is identical. **systemd doesn't care what language the service is written in.** Same unit file pattern works for Node.js, Python, Bash, Go, or any executable.

---

## The Permission Trap

Before creating the service, you ran the script manually as your user (`david`). The log file was created with your ownership:

```bash
ls -l /tmp/immortal.log
# -rw-r--r-- 1 david david 2048 Mar 11 10:30 /tmp/immortal.log
```

When systemd runs the service with `User=david`, it also writes as `david` — so in this lab it works fine.

**The trap occurs when:**
- You ran the script manually as `root` (e.g., with `sudo ./immortal.sh &`)
- The log file is now owned by `root:root`
- The service runs with `User=david`
- `david` can't append to a root-owned file → service fails with permission error

**Fix:** Always `rm /tmp/immortal.log` before starting the service, or check ownership with `ls -l` first.

```bash
ls -l /tmp/immortal.log           # check who owns it
rm /tmp/immortal.log              # clean slate
sudo systemctl start immortal     # service creates it fresh as User=david
```

---

## Self-Healing Timeline

```
systemctl start immortal
    └── PID: 5821 — running, writing to log

kill -9 5821
    └── Process terminated (SIGKILL)
    └── systemd detects exit immediately

[RestartSec=3 — 3 second pause]

    └── PID: 5834 — new process, running again
    └── Log continues with no gap in timestamps
```

```bash
# Demo
pgrep -f immortal       # 5821
kill -9 5821
sleep 4
pgrep -f immortal       # 5834  ← new PID, service is back
systemctl status immortal
# Active: active (running) — Restart=1
```

---

## pgrep -f vs pgrep

| Command | Searches | Use for | Example |
|---------|----------|---------|---------|
| `pgrep node` | Process name only | Binaries/executables | `pgrep node` → finds `/usr/bin/node` |
| `pgrep -f immortal` | Full command line | Scripts, processes with args | `pgrep -f immortal` → finds `/home/david/immortal.sh` |

**Why the difference?** When you run `node app.js`, the process name is `node`. When you run `./immortal.sh`, the process name is `bash` — because bash is the interpreter. `pgrep bash` would match every bash shell on the system. `pgrep -f immortal` matches the full command line, which uniquely identifies your script.

---

## This Lab vs Node.js Lab

| Aspect | immortal (Bash) | node-demo (Node.js) |
|--------|-----------------|---------------------|
| Script/binary | `~/immortal.sh` | `app.js` via `/usr/bin/node` |
| Language | Bash | JavaScript |
| Find PID | `pgrep -f immortal` | `pgrep node` |
| Permission risk | Log owned by wrong user | Same risk |
| Unit file pattern | Identical | Identical |
| Self-healing | Restart=always | Restart=always |
| systemd behavior | Exactly the same | Exactly the same |

**The lesson:** systemd doesn't know or care what language your service runs in. The unit file pattern is universal.

---

## Key Takeaways

1. **The shebang (`#!/bin/bash`) is mandatory** — without it, systemd doesn't know how to execute the script and the service fails silently.
2. **`chmod +x` before running any script** — an unexecutable script produces "Permission denied", not a helpful error about missing shebang.
3. **`pgrep -f` for scripts, `pgrep` for binaries** — scripts run inside an interpreter (bash), so their process name is the interpreter, not the script name.
4. **Check log file ownership before creating a service** — if you ran the script manually as root first, the log is root-owned and the service user can't write to it.
5. **The systemd unit file pattern is language-agnostic** — Bash, Node.js, Python, Go: same sections, same keys, same self-healing behavior.

---

## Iron Rules

- **"chmod +x before running any script"** — always, without exception
- **"pgrep -f for scripts, pgrep for binaries"** — scripts run inside an interpreter, so their process name is `bash`, not your script name
- **"Check file ownership (`ls -l`) before converting a manual process to a service"** — ownership mismatch is a silent killer
- **"Shebang (`#!/bin/bash`) is mandatory for systemd"** — systemd doesn't assume a shell; it executes the file directly
