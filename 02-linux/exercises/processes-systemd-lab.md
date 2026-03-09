# Processes & systemd Lab - Service Self-Healing

> Lab from IITC DevOps course. Completed 2026-03-10.
> Topic: systemd service management, process lifecycle, self-healing mechanism

## Commands Used

| Command | Syntax | Purpose |
|---------|--------|---------|
| `systemctl list-units --type=service` | `systemctl list-units --type=service` | List all loaded services and their state |
| `systemctl status` | `systemctl status <service>` | Show service status, PID, memory, recent logs |
| `ps -p <PID> -f` | `ps -p 6012 -f` | Inspect a specific process with full details |
| `ps -e --forest` | `ps -e --forest` | Show all processes in a tree (parent/child) |
| `kill -9` | `sudo kill -9 <PID>` | Force-kill a process (SIGKILL) |
| `nmcli device status` | `nmcli device status` | Check network interface status |

## Step-by-Step Walkthrough

### Step 1: List All Services

```bash
systemctl list-units --type=service
```

Shows all loaded service units — their LOAD, ACTIVE, SUB status and description. Used to identify which services are running on the system.

### Step 2: Check NetworkManager Status

```bash
systemctl status NetworkManager
```

Output showed:
- **Active**: active (running)
- **Main PID**: 6012 (NetworkManager)
- Memory usage, CGroup info, and recent journal entries

### Step 3: Inspect the Process

```bash
ps -p 6012 -f
```

| UID | PID | PPID | CMD |
|-----|-----|------|-----|
| root | 6012 | 1 | /usr/sbin/NetworkManager --no-daemon |

Key observations:
- **PPID = 1** — parent is systemd (PID 1), confirming this is a systemd-managed service
- **TTY = ?** — no terminal attached, this is a daemon process
- Runs as **root** — system-level service

### Step 4: View Process Tree

```bash
ps -e --forest
```

Showed the full parent/child hierarchy. NetworkManager (PID 6012) appeared as a direct child of systemd (PID 1).

### Step 5: Kill the Process

```bash
sudo kill -9 6012
```

SIGKILL sent — process terminated immediately. Network connectivity lost momentarily.

### Step 6: Verify Self-Healing

```bash
systemctl status NetworkManager
```

Output showed:
- **Active**: active (running) — service is back!
- **Main PID**: 7356 (NetworkManager) — **new PID**, confirming the old process died and a new one was spawned
- systemd detected the process death and restarted it automatically

### Step 7: Verify Network Recovery

```bash
nmcli device status
```

Network interfaces back online — connectivity restored after systemd restarted the service.

## Key Observations

| Before Kill | After Kill |
|------------|------------|
| PID 6012 | PID 7356 |
| active (running) | active (running) |
| Network up | Network up (after brief drop) |

The **PID changed** (6012 → 7356) but the **service remained active**. This proves systemd created a brand new process to replace the killed one.

## Process vs Service

| Aspect | Process | Service |
|--------|---------|---------|
| What is it | A running instance in memory | A policy/declaration managed by systemd |
| Identity | PID (changes every time) | Unit name (permanent) |
| Survives kill? | No — it's dead | Yes — systemd restarts it |
| Survives reboot? | No | Yes (if enabled) |
| Managed by | The kernel | systemd |

## kill vs systemctl stop

| Aspect | `sudo kill -9 <PID>` | `systemctl stop <service>` |
|--------|----------------------|---------------------------|
| Who handles it | Kernel kills the process directly | systemd stops the service gracefully |
| systemd aware? | No — bypasses systemd | Yes — systemd updates service state |
| Self-healing? | Yes — systemd sees unexpected death, restarts | No — systemd knows it was intentional |
| Use case | Emergency / testing | Normal operations |

## Iron Rules Earned

- **"Service = policy, Process = current state"** — the service defines what should happen, the process is what's happening now
- **"systemd enforces desired state — kill the process, the service survives"** — self-healing in action
- **"Always check status before restart"** — `systemctl status` first, understand before acting
- **"sudo kill bypasses systemd — use systemctl stop for controlled shutdown"** — kill is a bypass, systemctl is the proper channel
