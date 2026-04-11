# TCP/IP and Socket Connections

## The TCP/IP Model

TCP/IP is the foundational framework that defines how data travels across the internet.
It has 4 layers (simpler than the 7-layer OSI model):

| Layer | Name | What it does | Examples |
|-------|------|-------------|---------|
| 4 | Application | User-facing protocols | HTTP, DNS, SSH, FTP |
| 3 | Transport | End-to-end communication | TCP, UDP |
| 2 | Internet | Addressing and routing | IP |
| 1 | Network Access | Physical transmission | Ethernet, WiFi |

Each layer handles its own responsibility and passes data to the layer above/below.
Your FastAPI app lives at Layer 4. It doesn't know or care about Layers 1-2.

## TCP vs UDP

| Feature | TCP | UDP |
|---------|-----|-----|
| Full name | Transmission Control Protocol | User Datagram Protocol |
| Reliability | Guaranteed delivery | Best-effort, no guarantee |
| Order | Packets arrive in order | Order not guaranteed |
| Speed | Slower (overhead for reliability) | Faster (no overhead) |
| Connection | Connection-oriented (handshake) | Connectionless |
| Use cases | HTTP, SSH, email, file transfer | Live video, DNS, gaming, VoIP |

Rule of thumb: if losing data is unacceptable → TCP. If speed matters more → UDP.

## The TCP 3-Way Handshake

Before any data is sent over TCP, a connection must be established.
This takes exactly 3 messages:

```
Client                          Server
 |                               |
 |-------- SYN ----------------->|   "I want to connect, my seq=X"
 |                               |
 |<------- SYN-ACK --------------|   "OK, I got X, my seq=Y, ack=X+1"
 |                               |
 |-------- ACK ----------------->|   "Got it, ack=Y+1, let's go"
 |                               |
 |====== Data Transfer ==========|
```

- **SYN** (Synchronize): client initiates
- **SYN-ACK**: server acknowledges and responds
- **ACK** (Acknowledge): client confirms - connection open

Only after all 3 steps does actual data begin flowing.

## What is a Socket?

A Socket is the software abstraction that represents one endpoint of a network connection.

```
Socket = IP Address + Port + Protocol
```

Examples:
- Server socket: `0.0.0.0:8000 (TCP)` - your FastAPI app listening for connections
- Client socket: `192.168.1.5:52341 (TCP)` - your browser's temporary connection port

When you run `uvicorn main:app --host 0.0.0.0 --port 8000`, you are:
1. Creating a socket
2. Binding it to port 8000
3. Telling the OS: "give me everything arriving on port 8000"

## Full Flow: Browser to Server

```
1. DNS lookup: google.com → 142.250.74.46
2. TCP Handshake: SYN → SYN-ACK → ACK (port 443)
3. TLS Handshake: agree on encryption keys
4. HTTP GET / sent (encrypted)
5. HTTP 200 OK response received (encrypted)
6. Browser renders HTML
```

## Key Concepts

- TCP/IP = 4-layer model. Your app lives at Application layer.
- TCP = reliable, ordered, connection-oriented (3-way handshake)
- UDP = fast, unreliable, connectionless
- Socket = IP + Port + Protocol
- 3-Way Handshake = SYN, SYN-ACK, ACK - happens before every TCP connection
