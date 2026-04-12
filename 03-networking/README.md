# Module 03: Networking - How Systems Talk

**Status**: In Progress
**Prerequisites**: Module 01 - Foundations, Module 02 - Linux

## Overview

Every DevOps tool communicates over a network. This module covers the invisible layer
that connects everything - from HTTP requests to DNS resolution to load balancing.

## Contents

| File | Topic | Status |
|------|-------|--------|
| concepts/http-https.md | HTTP vs HTTPS, TLS, Status Codes | Done |
| concepts/ports.md | Ports, Well-Known ports, Socket | Done |
| concepts/dns.md | DNS Resolution, Records, Caching | Done |
| concepts/load-balancing.md | LB algorithms, types, health checks | Done |
| concepts/tcp-ip.md | TCP/IP model, 3-Way Handshake, UDP vs TCP | Done |
| resources.md | All course-provided links (videos + articles) | Done |
| postman-labs.md | Postman API Labs - JSONPlaceholder + PokeAPI | Done |

## Iron Rules from This Module

- "DNS is the phonebook of the internet - without it, you know IPs, not names."
- "HTTP is stateless. Every request starts from zero."
- "IP gets you to the device. Port gets you to the application."
- "TCP is reliable. UDP is fast. Choose accordingly."
- "A Load Balancer eliminates the Single Point of Failure."
- "Read the docs before touching Postman."
- "URLs inside a response are not decoration - they are the API's navigation."
- "Unnamed endpoints only accept ID, never a name."
- "Pagination exists everywhere - never pull 1300 records at once."
- "POST returns 201. GET returns 200. The code tells you what happened."
- "PUT replaces. PATCH patches. They are not interchangeable."
