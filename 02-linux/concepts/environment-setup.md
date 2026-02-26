# Environment Setup - Ubuntu Server on VirtualBox

## TL;DR

The first step in learning Linux for DevOps is setting up a real server environment - no GUI, no safety net. Ubuntu 24.04 Server on VirtualBox provides an isolated lab that mirrors how production servers actually run.

## Full Picture

### The VM Setup

- **OS**: Ubuntu 24.04 Server (LTS)
- **Hypervisor**: VirtualBox
- **Resources**: 4GB RAM, 6 CPU cores, 25GB disk
- **Network**: NAT adapter (VM gets internet through host)

### Why Server, Not Desktop

Desktop Ubuntu comes with a GUI - a graphical environment that production servers never have. Server installs are headless: just a terminal. This is intentional. In production, every installed package is an attack surface, and a GUI wastes resources on a machine no one sits in front of. Learning on a server from day one builds the right muscle memory.

### The First Wall: Nothing Is Pre-Installed

The first surprise: `curl` wasn't available. On a minimal server install, you get almost nothing beyond the base system. Every tool needs to be explicitly installed. This is a feature, not a bug - production servers should only have what they need.

```bash
sudo apt install curl -y
```

### Key Concepts Encountered

**`sudo` - Super User DO**

Runs a command with root (administrator) privileges. Regular users can't install software or modify system files without it. When `sudo` asks for a password, the characters don't appear as you type - this is normal Linux security behavior, not a broken terminal.

**`apt` - Advanced Package Tool**

The package manager for Ubuntu/Debian systems. It downloads, installs, and manages software from official repositories.

```bash
sudo apt update          # Refresh package list
sudo apt install curl -y # Install curl, auto-confirm
```

**The `-y` flag**

Automatically answers "yes" to confirmation prompts. Without it, `apt` asks before installing. Note: there must be a space before `-y` - it's a separate argument, not part of the package name.

## Why It Matters for DevOps

Every server you provision in production starts exactly like this - a minimal OS that you build up with only the packages needed. Understanding package management and privilege escalation (`sudo`) is fundamental to server administration, Dockerfiles, and infrastructure automation.

## Key Takeaways

- Server installs are minimal by design - install only what you need
- `sudo` elevates privileges; password input is invisible (not broken)
- `apt` is the package manager for Debian/Ubuntu systems
- The `-y` flag auto-confirms installations (useful in scripts and automation)

## Real-World Example

When writing a Dockerfile, the first lines after choosing a base image are almost always `apt update && apt install -y <packages>`. The same pattern learned here on a VM is the same pattern used in every container build.
