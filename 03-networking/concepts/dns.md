# DNS - Domain Name System

## What is DNS?

DNS is the "phonebook of the internet."
Humans remember `google.com`. Computers communicate via `142.250.74.46`.
DNS translates between the two.

Without DNS, you would need to memorize IP addresses for every website you visit.

## The 4 Actors in DNS Resolution

| Actor | Role | Analogy |
|-------|------|---------|
| DNS Resolver | Receives your query, hunts for the answer | The librarian |
| Root Nameserver | Knows who handles each TLD (.com, .org) | Library index |
| TLD Nameserver | Knows who handles specific domains under .com | Shelf in the library |
| Authoritative Nameserver | Has the actual IP address for the domain | The specific book |

## The 8-Step DNS Lookup (uncached)

1. You type `example.com` in the browser
2. Browser checks its own DNS cache
3. OS checks its own DNS cache
4. Query goes to the **DNS Resolver** (usually your ISP or 8.8.8.8)
5. Resolver asks a **Root Nameserver**: "who handles .com?"
6. Root server returns the address of the **.com TLD server**
7. TLD server returns the address of `example.com`'s **Authoritative Nameserver**
8. Authoritative Nameserver returns the **IP address**
9. Browser opens a TCP connection to that IP and sends the HTTP request

In practice, most lookups skip steps 5-7 due to **caching**.

## DNS Caching and TTL

Every DNS record has a **TTL (Time To Live)** - how long it can be cached.

- Browser caches DNS (check in Chrome: `chrome://net-internals/#dns`)
- OS caches DNS
- Resolver caches DNS

When you change a server's IP, DNS propagation takes time = everyone's cache must expire.

## DNS Record Types

| Record | Purpose | Example |
|--------|---------|---------|
| A | Domain → IPv4 address | `google.com → 142.250.74.46` |
| AAAA | Domain → IPv6 address | IPv6 equivalent |
| CNAME | Domain → another Domain (alias) | `www.google.com → google.com` |
| MX | Mail server for the domain | Gmail routing |
| NS | Which nameservers are authoritative | Points to Cloudflare, etc. |
| TXT | Text data (used for verification, SPF) | Domain ownership proof |

## Key Concepts

- DNS Resolver = asks the questions on your behalf
- Authoritative Nameserver = the source of truth for a domain
- A Record = most common, domain to IP
- CNAME = alias, domain to domain (cannot be used on root domain)
- TTL determines how long until a DNS change propagates
