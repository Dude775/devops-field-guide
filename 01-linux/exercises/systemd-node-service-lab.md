# Node.js systemd Service Lab

> IITC DevOps course (lirone fitoussi). Completed 2026-03-11.
> Topic: Running a Node.js application as a managed Linux service.

## Lab Overview

The goal: take a Node.js app running as a plain background process and convert it into a proper systemd service — one that auto-starts on boot, restarts on failure, and runs as a non-root user.

**The core question:** What's the difference between running `node app.js &` and a real service?

---

## Process vs Service

| Aspect | Background Process (`&`) | systemd Service |
|--------|--------------------------|-----------------|
| Starts on boot | No | Yes (if enabled) |
| Survives terminal close | No | Yes |
| Restarts on crash | No | Yes (`Restart=always`) |
| Managed by | Nothing / you | systemd (PID 1) |
| Visible in `systemctl` | No | Yes |
| Logs collected by journald | No | Yes |
| Kill it with `kill -9` | Dead permanently | Restarted by systemd |

---

## Commands Reference

| Command | What It Does | Example |
|---------|-------------|---------|
| `node app.js &` | Run Node.js in background, get PID | `node app.js &` → `[1] 4821` |
| `ps aux \| grep node` | Find node processes with details | `ps aux \| grep node` |
| `pgrep node` | Get PIDs of processes named "node" | `pgrep node` |
| `kill -9 <PID>` | Force-kill a process | `kill -9 4821` |
| `tail -f /tmp/node-service.log` | Follow app log in real-time | `tail -f /tmp/node-service.log` |
| `sudo nano /etc/systemd/system/<name>.service` | Create/edit a unit file | `sudo nano /etc/systemd/system/node-demo.service` |
| `sudo systemctl daemon-reload` | Reload systemd after unit file change | `sudo systemctl daemon-reload` |
| `sudo systemctl start <name>` | Start a service | `sudo systemctl start node-demo` |
| `sudo systemctl stop <name>` | Stop a service | `sudo systemctl stop node-demo` |
| `sudo systemctl restart <name>` | Restart a service | `sudo systemctl restart node-demo` |
| `systemctl status <name>` | Show service status, PID, recent logs | `systemctl status node-demo` |
| `sudo systemctl enable <name>` | Auto-start on boot (creates symlink) | `sudo systemctl enable node-demo` |
| `systemctl is-enabled <name>` | Check if enabled for boot | `systemctl is-enabled node-demo` |
| `journalctl -u <name>` | All logs for a specific unit | `journalctl -u node-demo` |
| `journalctl -u <name> -f` | Follow logs for a unit in real-time | `journalctl -u node-demo -f` |

---

## The Unit File

Unit files live in `/etc/systemd/system/`. They use TOML/INI-style syntax — sections in `[brackets]`, key=value pairs.

```ini
[Unit]
Description=Node.js Demo Application
After=network-online.target

[Service]
ExecStart=/usr/bin/node /home/david/app.js
WorkingDirectory=/home/david
StandardOutput=append:/tmp/node-service.log
StandardError=append:/tmp/node-service.log
Restart=always
RestartSec=3
User=david

[Install]
WantedBy=multi-user.target
```

### [Unit] Section — Metadata & Dependencies

| Key | Value | Meaning |
|-----|-------|---------|
| `Description` | `Node.js Demo Application` | Human-readable name (shows in `systemctl status`) |
| `After` | `network-online.target` | Start only after network is up — ordering, not continuous monitoring |

> **`After=` is about ordering, not dependency.** It means "don't start me until that target is reached." If the network goes down later, systemd doesn't stop your service.

### [Service] Section — What to Run

| Key | Value | Meaning |
|-----|-------|---------|
| `ExecStart` | `/usr/bin/node /home/david/app.js` | The command to run — **must be absolute paths** |
| `WorkingDirectory` | `/home/david` | Where the process runs from |
| `StandardOutput` | `append:/tmp/node-service.log` | stdout goes to this log file |
| `StandardError` | `append:/tmp/node-service.log` | stderr goes to same log file |
| `Restart` | `always` | Restart whenever the process exits (crash, kill, anything) |
| `RestartSec` | `3` | Wait 3 seconds before restarting (backoff — prevents rapid crash loops) |
| `User` | `david` | Run as this user, not root |

### [Install] Section — Boot Behavior

| Key | Value | Meaning |
|-----|-------|---------|
| `WantedBy` | `multi-user.target` | Enable as part of normal multi-user boot (the standard target for servers) |

> **`systemctl enable` creates a symlink** in `/etc/systemd/system/multi-user.target.wants/` pointing to your unit file. That's how systemd knows to start it on boot. `systemctl disable` removes the symlink.

---

## Boot Flow

```
Boot
 └── systemd (PID 1)
      └── multi-user.target
           └── network-online.target (reached first — After= dependency)
                └── node-demo.service
                     └── ExecStart: /usr/bin/node /home/david/app.js
                          └── Restart=always (self-healing loop)
```

---

## Self-Healing Demo

After the service is running:

```bash
# Find the PID
pgrep node
# 5821

# Kill it with force
kill -9 5821

# Check status immediately
systemctl status node-demo
# ● node-demo.service - Node.js Demo Application
#    Active: activating (auto-restart) (Result: signal) ...
#    (3 seconds later...)
#    Active: active (running) since ...
#    Main PID: 5834  ← new PID, systemd restarted it
```

The process died — systemd noticed, waited 3 seconds (`RestartSec=3`), and brought it back automatically.

---

## Troubleshooting

### Error: status=217/USER

**Symptom:** `systemctl status node-demo` shows `code=exited, status=217/USER`

**Cause:** The `User=` field in the unit file contains a shell variable like `$USER` or a path with `~`. systemd doesn't have a shell — it cannot expand variables.

**Wrong:**
```ini
User=$USER          # ← systemd can't expand this
ExecStart=~/app.js  # ← systemd can't expand ~
```

**Right:**
```ini
User=david                          # literal username
ExecStart=/home/david/app.js        # full absolute path
```

---

### Forgot daemon-reload

**Symptom:** You edited the unit file but the service behaves as before, or systemctl shows the old configuration.

**Cause:** systemd caches unit files in memory. After any edit, you must reload:

```bash
sudo systemctl daemon-reload
sudo systemctl restart node-demo
```

**Rule:** Edit unit file → `daemon-reload` → `restart`. Always in this order.

---

## Key Takeaways

1. **A background process (`&`) is not a service** — it dies with the terminal, doesn't restart on crash, and doesn't start on boot.
2. **systemd is PID 1** — it's the first process the kernel starts, and it manages everything else. It has no shell, no PATH, no `~`.
3. **`After=` is ordering, not dependency monitoring** — it controls startup sequence only, not runtime behavior.
4. **`Restart=always` + `RestartSec=3` = self-healing** — the 3-second delay prevents rapid crash loops from hammering the system.
5. **`systemctl enable` = symlink** — it doesn't start the service now; it registers it for boot. Use `start` to run immediately.

---

## Iron Rules

- **"systemd has no shell — always use absolute paths"** — no `~`, no `$HOME`, no `$USER` in unit files
- **"Never use environment variables in unit files"** — they are not expanded; use literal values only
- **"daemon-reload after every unit file change"** — systemd won't pick up edits until you tell it to
- **"Least privilege: never run app services as root"** — use `User=` to run as a dedicated low-privilege user (DevSecOps principle)
