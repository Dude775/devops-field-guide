# Module 02: Linux - Command Line Mastery

> **Status**: In Progress
> **Prerequisites**: [Module 01 - Foundations](../01-foundations)

## Overview

Hands-on from day one - setting up a real Linux server environment and learning commands by doing. Linux is the operating system that runs most production servers, containers, and cloud instances. This module covers the command line, filesystem hierarchy, permissions, process management, and shell scripting - the daily toolkit of every DevOps engineer.

## Learning Objectives

- [x] Set up Ubuntu Server on VirtualBox as a headless lab environment
- [x] Install packages with apt and understand sudo privilege escalation
- [x] Configure SSH remote access with port forwarding
- [x] Use core commands: navigation, file operations, text processing
- [x] Understand pipes, redirection, heredocs, and command chaining
- [x] Write a bash for loop for bulk file operations
- [ ] Users, groups, and permission models
- [ ] Process management and system monitoring
- [ ] Shell scripting fundamentals

## Contents

### Concepts
- [Environment Setup](concepts/environment-setup.md) - Ubuntu 24.04 Server on VirtualBox, apt, sudo
- [SSH Remote Access](concepts/ssh-remote-access.md) - SSH setup, port forwarding, remote management

### Commands
- [Core Commands Reference](commands/core-commands.md) - All commands learned, categorized
- [curl | tar Pipe Pattern](commands/curl-tar-pipe.md) - The download-extract-navigate one-liner
- [Heredoc and Redirection](commands/heredoc-and-redirection.md) - Output redirection, pipes, heredocs
- [Linux Commands Field Guide](commands/linux-commands-field-guide.md) - Complete reference: files, text processing, permissions, users, packages, processes, bash scripting

### Exercises
- [Log File Generator](exercises/log-file-generator.md) - Bash for loop for bulk file creation
- [File Management Lab](exercises/file-management-lab.md) - mkdir, touch, cp, mv, rm (Lab 2, 100/100)
- [Links & Pipes Labs](exercises/links-and-pipes-lab.md) — Hard links, soft links, pipes, redirection, sort, wc (Labs 6-7, 100/100)
- [STDOUT/STDERR Practice Lab](exercises/stdout-stderr-lab.md) — Output redirection, STDOUT, STDERR, 2>&1 (100/100)
- [journalctl Lab](exercises/journalctl-lab.md) — Log investigation, filtering, real-time monitoring, boot logs, priority levels (100/100)
- [Processes & systemd](exercises/processes-and-systemd.md) — Processes, PIDs, Signals, Services, systemd, systemctl, journalctl
- [Users Getting Started Lab](exercises/users-getting-started-lab.md) — User management, adduser vs useradd, su, /etc/passwd (Lab 2.4, 100/100)
- [Processes & systemd Lab](exercises/processes-systemd-lab.md) — Service self-healing: systemctl, ps, kill, systemd auto-recovery
- [Weekend Labs](exercises/weekend-labs.md) - Reading Files, Search Basics, Scavenger Hunt (Labs 3-5, 80/100)
- [Shared Server Scenario Lab](exercises/shared-server-scenario-lab.md) - Full server setup: users, groups, permissions, log analysis, admin access, debugging (Bonus Lab)
- [systemd Node.js Service Lab](exercises/systemd-node-service-lab.md) - Process vs service, unit file structure, self-healing, boot flow, troubleshooting
- [Immortal Bash Service Lab](exercises/immortal-service-lab.md) - Bash script as systemd service, chmod +x, pgrep -f, file ownership trap

### Journal
- [Week 02 Notes](journal/week-02-notes.md) - Setup reflections, CLI discoveries, DevOps connections

## Key Takeaways

- **Reading files**: `cat` for short, `less` for long, `head`/`tail` for a peek, `tail -f` for live monitoring
- **File management**: `rm` is a one-way ticket, `mkdir -p` for scripts, `cp` creates snapshots not links, `mv` does both move and rename
- **Searching**: `grep` for content inside files, `find` for locating files by name - never confuse the two
- **Efficiency matters**: `head -n 5 file` is better than `cat file | head -n 5` at scale
- **Permission denied is a feature**: Linux protects sensitive files by design
- **Everything is a file**: configs, logs, user data, service mappings - all plain text, all searchable

_Updated as the module progresses._
