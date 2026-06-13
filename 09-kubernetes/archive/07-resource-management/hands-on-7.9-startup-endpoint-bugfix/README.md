# Hands-On 7.9 — Startup Endpoint Bugfix

## Goal

Fix a logical bug in the Color API by separating the Startup endpoint from the Liveness endpoint.

## Problem

In version 1.2.0, both Startup Probe and Liveness Probe used `/live`. Setting `FAIL_LIVENESS=true` caused the Startup Probe to also fail — because they shared the same endpoint. This made it impossible to test Liveness failure independently.

## Fix

Added a dedicated `/up` endpoint that always returns 200 OK, regardless of any env vars.

### Endpoint Separation (1.2.1)

| Probe | Endpoint | Controlled By |
|---|---|---|
| Startup | `/up` | Always healthy |
| Liveness | `/live` | `FAIL_LIVENESS` |
| Readiness | `/ready` | `FAIL_READINESS` |

### New Endpoint Code

```js
app.get("/up", (req, res) => {
  res.send("Ok");
});
```

## Version

Updated `package.json` version: `1.2.1`

## Build and Push

```bash
docker build -t color-api:1.2.1 .
docker tag color-api:1.2.1 idf775/color-api:1.2.1
docker push idf775/color-api:1.2.1
```

Remote digest:
```
sha256:7a9a55758a928e09d5f55dbf07be3eb8291d5b66459f5ace8051190bf13007d8
```

Remote image verified on Docker Hub: `idf775/color-api:1.2.1`

## Files

```
app/
  Dockerfile
  package.json
  src/
    index.js
outputs/
  01-index-before-up-endpoint.txt
  02-package-before-bugfix.txt
  03-current-probe-endpoints.txt
  04-probe-endpoints-after-bugfix.txt
  05-package-after-bugfix.txt
  06-docker-build-121.txt
  07-docker-run-121.txt
  08-endpoints-test-121.txt
  09-container-logs-121.txt
  10-docker-push-121.txt
  11-remote-image-verified-121.txt
  12-remove-test-container.txt
  13-local-images.txt
  14-lab-conclusion.txt
  15-final-files-created.txt
```

## Conclusion

`idf775/color-api:1.2.1` separates Startup, Liveness, and Readiness probes onto independent endpoints, making each probe independently controllable.
