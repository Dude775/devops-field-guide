# Week 02 - Linux Environment Setup & File Operations

> Reflections from labs and exercises.

## What was the first real "Linux moment"?

Running `grep -r SECRET .` and watching it recursively search through dozens of files across nested directories in milliseconds. On Windows this would be a multi-click, multi-window ordeal. On Linux it's one command. That's when the power of the CLI clicked.

## How did SSH change the workflow?

Eliminated the need to sit at the VM console. Port forwarding + SSH from Windows Terminal means the VM runs headless in the background while I work from my normal environment. The server doesn't need a monitor - just like production.

## What commands felt natural vs foreign?

**Natural**: `cd`, `ls`, `cat`, `echo` - the basics transfer well from PowerShell muscle memory.

**Foreign at first**: The pipe philosophy (`|`), heredocs (`<< 'EOF'`), and the difference between `&&` and `;`. PowerShell has pipes but they pass objects, not text streams. Linux pipes pass raw text - simpler but requires different thinking.

**Surprisingly powerful**: `find -exec` combining file search and action in one command. `grep -c` for counting without displaying. Brace expansion `{a,b,c}` for creating multiple directories at once.

## Connection to DevOps

Every DevOps tool runs on Linux. Docker containers are Linux. Kubernetes nodes are Linux. CI/CD runners are Linux. The commands from these labs - reading logs with `tail -f`, searching configs with `grep -r`, finding files with `find` - these aren't academic exercises. They're literally what you do daily when debugging a production incident at 2am.

The permission model (`/etc/shadow` being root-only) connects directly to security hardening and the principle of least privilege - a core DevOps/security concept.

## Surprises

- `cat file | head -n 5` reads the entire file, while `head -n 5 file` reads only 5 lines. At scale (GB-sized logs), this efficiency difference is critical.
- Hidden files (dot-files) are everywhere in Linux - `.bashrc`, `.gitignore`, `.env`. They're not truly hidden, just filtered from default `ls` output. `ls -a` shows everything.
- `grep` silently returns nothing when there's no match (exit code 1, no output). No error, no message. Silence means "not found."
- `/etc/services` is a plain text file mapping service names to ports. The entire networking layer's service discovery starts with a simple text file.
