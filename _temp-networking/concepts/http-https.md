# HTTP / HTTPS

## What is HTTP?

HyperText Transfer Protocol - the application-layer protocol that defines how a
client (browser) communicates with a server. It is **stateless** - every request
is independent; the server remembers nothing between requests. This is why cookies
and sessions exist.

## Request Structure

Every HTTP request has:
- **Method**: GET (fetch), POST (send), PUT (update), DELETE (remove)
- **Headers**: metadata - browser type, preferred format, auth tokens
- **Body**: actual content (only in POST/PUT)

## Response Structure

Every HTTP response has:
- **Status Code**: what happened
- **Headers**: content type, caching rules, etc.
- **Body**: the actual content (HTML, JSON, etc.)

## Status Codes

| Range | Meaning | Examples |
|-------|---------|---------|
| 2xx | Success | 200 OK, 201 Created |
| 3xx | Redirect | 301 Moved Permanently |
| 4xx | Client error | 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found |
| 5xx | Server error | 500 Internal Server Error, 503 Service Unavailable |

## HTTPS = HTTP + TLS

HTTPS is not a different protocol - it is HTTP with an encryption layer (TLS) on top.

### How TLS Works (simplified)

1. Client says: "I want to connect securely"
2. Server sends its certificate (proof of identity)
3. Both sides agree on an encryption algorithm
4. Keys are exchanged
5. All subsequent communication is encrypted

### HTTP vs HTTPS

| Feature | HTTP | HTTPS |
|---------|------|-------|
| Default Port | 80 | 443 |
| Encryption | None - plain text | TLS encrypted |
| Security | Vulnerable to MITM | Protected |
| Browser indicator | "Not Secure" | Padlock icon |
| Performance | Slightly lighter | Slightly heavier (but modern TLS is fast) |

## Key Concepts to Remember

- HTTP is **stateless** - cookies/sessions are workarounds
- HTTPS = HTTP + TLS (formerly SSL - same concept, newer name)
- Status codes: 2xx success, 4xx client fault, 5xx server fault
- GET = read, POST = write, PUT = update, DELETE = remove
