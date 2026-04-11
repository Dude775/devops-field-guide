# Ports

## What is a Port?

An IP address gets data to the right **device**.
A port number gets data to the right **application** on that device.

The full address for any network connection:

```
IP + Port + Protocol = Socket
```

Example: `192.168.1.10:8000 (TCP)` - your FastAPI app listening locally.

## Port Number Ranges

| Range | Name | Description |
|-------|------|-------------|
| 0 - 1023 | Well-Known / System Ports | Reserved for standard protocols |
| 1024 - 49151 | Registered Ports | Application-specific (DBs, custom services) |
| 49152 - 65535 | Dynamic / Private Ports | Temporary client-side ports per session |

Port numbers are 16-bit unsigned integers: values 0 to 65535.
Assigned and managed by IANA (Internet Assigned Numbers Authority).

## Common Ports to Know

| Port | Protocol | Description |
|------|----------|-------------|
| 20, 21 | FTP | File Transfer |
| 22 | SSH | Secure Shell - remote server access |
| 25 | SMTP | Email sending |
| 53 | DNS | Domain Name resolution |
| 67/68 | DHCP | Dynamic IP assignment |
| 80 | HTTP | Web traffic (unencrypted) |
| 110 | POP3 | Email receiving |
| 143 | IMAP | Email (modern) |
| 443 | HTTPS | Web traffic (encrypted) |
| 3306 | MySQL | Database |
| 5432 | PostgreSQL | Database |
| 6379 | Redis | Cache / message broker |
| 3389 | RDP | Remote Desktop |

## How the OS Routes Traffic

When data arrives at a device:
1. IP layer delivers packet to the correct device
2. Transport layer reads the port number
3. OS checks which process is listening on that port
4. Data is forwarded to that process

This is why you can run a web server (port 80), SSH daemon (port 22),
and PostgreSQL (port 5432) all on the same machine simultaneously.

## Firewall and Ports

Firewalls use port numbers to allow or block traffic.

- Opening port 22 = allowing SSH connections
- Closing port 3306 externally = protecting MySQL from internet access
- Security Groups in AWS are essentially firewall rules per port
