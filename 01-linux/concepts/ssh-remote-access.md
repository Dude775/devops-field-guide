# SSH Remote Access

## TL;DR

SSH (Secure Shell) is how you access and manage remote servers. The VirtualBox console has no copy-paste, so SSH from Windows PowerShell is the practical way to work with the VM - and it's the same tool used to manage every production server.

## Full Picture

### The Problem

VirtualBox's built-in console window is limited: no copy-paste, no scroll buffer, no resize. Guest Additions (which enable clipboard sharing) require a GUI - useless on a headless server. Working directly in the console is painful for anything beyond basic commands.

### The Solution: SSH

SSH creates an encrypted terminal session from your host machine to the server. You get full copy-paste, scroll, and your familiar terminal environment.

### Finding the VM's IP Address

```bash
ip a
```

This shows all network interfaces:

- **`lo`** (loopback): `127.0.0.1` - the machine talking to itself
- **`enp0s3`** (NAT adapter): `10.0.2.15` - the VM's internal IP on the NAT network

The `10.0.2.15` address is VirtualBox's default NAT IP. It's not reachable from the host directly - NAT means the VM hides behind the host's network.

### Installing the SSH Server

OpenSSH server is not installed by default on Ubuntu Server (the client is, but not the server):

```bash
sudo apt install openssh-server -y
```

### Port Forwarding: Bridging Host to Guest

Since NAT isolates the VM, VirtualBox port forwarding maps a host port to the guest:

| Setting | Value |
|---------|-------|
| Host IP | 127.0.0.1 |
| Host Port | 2222 |
| Guest IP | 10.0.2.15 |
| Guest Port | 22 |

This means: traffic to `localhost:2222` on Windows gets forwarded to port `22` (SSH) on the VM.

### Connecting

From Windows PowerShell:

```powershell
ssh david@127.0.0.1 -p 2222
```

On first connection, SSH shows the server's fingerprint and asks to verify. This is a security feature - it confirms you're connecting to the right machine. Type `yes` to accept and save the fingerprint.

## Why It Matters for DevOps

SSH is the primary access method for:
- Production servers (AWS EC2, bare metal, any Linux host)
- CI/CD agents and build servers
- Container debugging (`docker exec` uses similar concepts)
- Git operations over SSH
- Ansible, which runs entirely over SSH

Mastering SSH now means you're already practicing how real infrastructure is managed.

## Key Takeaways

- `ip a` shows network interfaces and their IP addresses
- NAT gives the VM internet but isolates it from the host - port forwarding bridges this gap
- OpenSSH server must be installed explicitly on Ubuntu Server
- Port forwarding maps host `127.0.0.1:2222` to guest `10.0.2.15:22`
- First-time fingerprint verification is a security feature, not an error

## Real-World Example

When you launch an EC2 instance on AWS, the first thing you do is SSH into it: `ssh -i key.pem ubuntu@<public-ip>`. The exact same flow - connect, verify fingerprint, work remotely - is what was practiced here with VirtualBox.
