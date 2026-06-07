# Exploring systemd Logs with journalctl — Self-Learn Lab

> Self-learn lab. Completed 2026-03-09.
> Score: 100/100

## Lab Overview

Hands-on investigation of systemd logs using journalctl — viewing, filtering by service/time/priority, real-time monitoring, boot log separation, and combining multiple filters for targeted troubleshooting.

## Commands Learned

| Command | What It Does | Example |
|---------|-------------|---------|
| `journalctl` | Show all systemd logs | `journalctl` |
| `journalctl -n N` | Show last N log messages | `journalctl -n 20` |
| `journalctl -f` | Follow logs in real-time (like tail -f) | `journalctl -f` |
| `journalctl -u service` | Filter by specific service | `journalctl -u ssh` |
| `journalctl -u service -f` | Follow specific service in real-time | `journalctl -u ssh -f` |
| `journalctl --since` | Filter by start time | `journalctl --since "1 hour ago"` |
| `journalctl --since today` | Logs from today only | `journalctl --since today` |
| `journalctl --since "10 minutes ago"` | Recent window | `journalctl --since "10 minutes ago"` |
| `journalctl -b` | Logs from current boot | `journalctl -b` |
| `journalctl -b -1` | Logs from previous boot | `journalctl -b -1` |
| `journalctl -b -2` | Logs from two boots ago | `journalctl -b -2` |
| `journalctl -p LEVEL` | Filter by priority (and above) | `journalctl -p err` |
| `journalctl -u service -p LEVEL` | Combined: service + priority | `journalctl -u ssh -p err` |
| `journalctl -u service --since` | Combined: service + time | `journalctl -u ssh --since "1 hour ago"` |
| `journalctl -o short-iso` | ISO timestamp format | `journalctl -o short-iso` |
| `journalctl -xe` | Recent events with explanations | `journalctl -xe` |

---

## Part 1: View All Logs

```bash
journalctl
```

Massive output — hundreds of lines from all services. Not meant to be read top-to-bottom. This is the **base** that you narrow down with filters.

**Key observation:** journalctl without filters is like opening all security cameras at once. It's useful to know it exists, but you always want to filter.

---

## Part 2: Last N Messages

```bash
journalctl -n 20
```

Shows only the 20 most recent log entries. Quick way to see "what just happened."

---

## Part 3: Real-Time Follow

```bash
journalctl -f
```

Streams new log entries as they happen, like `tail -f`. Press Ctrl+C to exit. Useful for watching what happens when you trigger actions in another terminal.

---

## Part 4: Filter by Service

```bash
journalctl -u ssh
```

Shows only logs related to the SSH service. Clean, focused output showing start/stop events, authentication attempts, and session activity.

---

## Part 5: Service + Real-Time

```bash
journalctl -u ssh -f
```

Combines service filter with real-time follow. Watch SSH events as they happen — login attempts, session opens/closes.

**Key observation:** Each SSH restart generates a new PID. Observed: 5998 → 6335 → 6730 → 6762. The PID changes confirm that `systemctl restart` kills the old process and starts a new one.

---

## Part 6: Trigger and Observe

```bash
# Terminal 1: watch logs
journalctl -u ssh -f

# Terminal 2: trigger events
sudo systemctl stop ssh
sudo systemctl start ssh
sudo systemctl restart ssh
```

Observed in logs:
- **stop** → `Received signal 15` (SIGTERM) → `Server listening on :: port 22` stops
- **start** → New PID, `Server listening on 0.0.0.0 port 22` and `:: port 22`
- **restart** → SIGTERM + new start in sequence

**Key observation — socket activation:** When stopping ssh.service, a warning appeared: `Warning: Stopping ssh.service, but it can still be activated by: ssh.socket`. The socket stays active and can re-activate the service on incoming connections. This is systemd's socket activation mechanism.

---

## Part 7: Time-Based Filtering

```bash
journalctl --since "1 hour ago"
journalctl --since today
journalctl --since "10 minutes ago"
journalctl --since "2026-03-09 22:00" --until "2026-03-09 23:00"
```

Time filters accept natural language ("1 hour ago", "today") and absolute timestamps.

**Key observation:** Without timestamp context, you only have half the information. Knowing WHEN something happened is essential to understanding WHY.

---

## Part 8: Boot Logs

```bash
journalctl -b        # current boot
journalctl -b -1     # previous boot
journalctl -b -2     # two boots ago
```

The journal separates logs by boot with `-- Boot <id> --` markers. Each boot is an isolated timeline.

**Observation from VM:** 3 boots stored from the same day:
- Boot -2: 09:42 (morning class)
- Boot -1: 14:46 (afternoon)
- Boot 0: 22:23 (evening self-study)

---

## Part 9: Priority Filtering

```bash
journalctl -p err
journalctl -p warning
```

Priority levels hierarchy (highest to lowest):

| Level | Number | Meaning |
|-------|--------|---------|
| `emerg` | 0 | System is unusable |
| `alert` | 1 | Immediate action required |
| `crit` | 2 | Critical conditions |
| `err` | 3 | Error conditions |
| `warning` | 4 | Warning conditions |
| `notice` | 5 | Normal but significant |
| `info` | 6 | Informational |
| `debug` | 7 | Debug-level messages |

**Key observation:** `-p err` shows errors AND everything above (crit, alert, emerg). The flag includes the selected level and all more severe levels.

**Observation from VM:** `vmwgfx` DRM errors appeared in the error log. These are normal for a VirtualBox VM running a GUI — the virtual graphics driver doesn't fully support DRM. Not critical, not actionable.

---

## Part 10: Combined Filters

```bash
journalctl -u ssh -p err
journalctl -u ssh --since "1 hour ago"
journalctl -u ssh -p warning --since today
```

Filters stack — each additional flag narrows the results further. This is the real power of journalctl: start broad, narrow until you find what you need.

---

## Part 11: Output Formatting

```bash
journalctl -o short-iso
```

Changes timestamp format to ISO 8601 (`2026-03-09T22:45:12+0200`). Useful for correlation with external logs and for unambiguous timestamps.

---

## Part 12: Recent Events with Explanations

```bash
journalctl -xe
```

Shows the most recent journal entries with extra explanation text where available. The `-x` flag adds catalog explanations to known message types. Useful as a first diagnostic step.

---

## Troubleshooting Flow

The correct order for investigating service issues:

```
1. systemctl status <service>    → Is it running? What's the PID?
2. journalctl -u <service> -n 50 → What happened recently?
3. journalctl -u <service> -p err → Any errors?
4. Take action based on evidence  → restart, fix config, etc.
```

**Never restart blindly.** Always check status and logs first. A restart might hide the evidence you need.

---

## journalctl Flags Reference

| Flag | What It Filters | Stacks With |
|------|----------------|-------------|
| `-n N` | Last N entries | Everything |
| `-f` | Real-time follow | `-u` |
| `-u service` | Specific service | `-f`, `-p`, `--since`, `-b` |
| `-b` / `-b -1` | Boot boundary | `-u`, `-p` |
| `-p LEVEL` | Priority and above | `-u`, `-b`, `--since` |
| `--since` / `--until` | Time window | `-u`, `-p` |
| `-o FORMAT` | Output format | Everything |
| `-xe` | Recent + explanations | Standalone |

---

## Iron Rules

1. **"Logs before action — never restart blindly"** — check `systemctl status` and `journalctl -u` before any restart
2. **"`journalctl -p` shows selected level AND above"** — `-p err` includes err + crit + alert + emerg
3. **"No timestamp context = half the information"** — always know WHEN before asking WHY
4. **"Error line is often the result, not the cause"** — look 1-2 lines above the error for the real trigger
5. **"Socket activation can re-start a stopped service"** — stopping a service doesn't always mean it stays stopped
