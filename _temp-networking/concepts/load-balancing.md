# Load Balancing

## What is a Load Balancer?

A Load Balancer sits in front of multiple servers and distributes incoming
requests among them. It acts as a "traffic cop" - no single server gets overwhelmed.

## Why It Exists: Problems Without a Load Balancer

- **Single Point of Failure**: if the one server goes down, the whole service is down
- **Overloaded Server**: one server can only handle a limited number of requests
- **No Scalability**: adding more servers doesn't help if all traffic hits only one

## How It Works

1. All incoming requests go to the Load Balancer first
2. LB checks which servers are healthy (health checks)
3. LB picks a server based on the chosen algorithm
4. Request is forwarded; response returns through (or bypasses) the LB

## Distribution Algorithms

| Algorithm | Logic | Best For |
|-----------|-------|---------|
| Round Robin | Each request goes to the next server in rotation | Equal servers, stateless apps |
| Least Connections | Next request goes to the server with fewest active connections | Variable-length sessions |
| IP Hash | Same client IP always hits the same server | Session-heavy apps |
| Weighted | Servers get traffic proportional to their assigned weight | Mixed server capacities |

## LB by OSI Layer

| Layer | What it sees | Capability |
|-------|-------------|------------|
| Layer 4 (Transport) | IP + Port only | Fast, no content inspection |
| Layer 7 (Application) | HTTP headers, URL, cookies | Smart routing (e.g. /api → server A, /images → server B) |

Layer 7 is what Nginx does in reverse-proxy mode.

## Health Checks

Load Balancers continuously monitor backend servers:
- **Active (Heartbeat)**: LB sends periodic test pings to each server
- **Passive**: LB watches real traffic for errors/timeouts
- If a server fails → traffic is automatically rerouted to healthy servers
- When server recovers → it's automatically added back to the pool

## Software vs Hardware

| Type | Examples | Use Case |
|------|---------|---------|
| Software LB | Nginx, HAProxy, AWS ELB | Most modern applications |
| Hardware LB | F5 Networks appliances | Large enterprise data centers |
| Cloud LB | AWS ALB/NLB, GCP LB | Cloud-native workloads |

## Key Concepts

- LB eliminates Single Point of Failure
- Round Robin = simple rotation, Least Connections = smarter
- Layer 4 = fast + blind, Layer 7 = slower + smart
- Health checks are automatic - failed servers are removed from rotation
