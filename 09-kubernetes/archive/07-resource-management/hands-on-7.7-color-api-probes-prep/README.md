# Hands-On 7.7 — Color API Probes Prep

## Goal

Prepare the Color API image for Startup, Liveness, and Readiness Probes by adding controllable env vars and dedicated HTTP endpoints.

## Source

Copied the base color-api source into `app/` and extended it.

## Changes Made

### New Env Vars

| Variable | Default | Effect |
|---|---|---|
| `DELAY_STARTUP` | false | Blocks the event loop for 60 seconds on startup |
| `FAIL_LIVENESS` | false | Makes `/live` return HTTP 503 |
| `FAIL_READINESS` | false | Makes `/ready` return HTTP 503 on ~50% of requests |

### New Endpoints

| Endpoint | Behavior |
|---|---|
| `/live` | Returns 200 OK, or 503 if `FAIL_LIVENESS=true` |
| `/ready` | Returns 200 OK, or 503 (random 50%) if `FAIL_READINESS=true` |

Existing endpoints `/` and `/api` remain backward compatible.

### Version

Updated `package.json` version: `1.2.0`

## Build and Push

```bash
docker build -t color-api:1.2.0 .
docker tag color-api:1.2.0 idf775/color-api:1.2.0
docker push idf775/color-api:1.2.0
```

Remote image verified on Docker Hub: `idf775/color-api:1.2.0`

## Endpoint Tests (local container)

- `/api` → `COLOR: blue, HOSTNAME: <container-id>`
- `/ready` → `200 OK`
- `/live` → `200 OK`

Container logs confirmed all env vars defaulted to false:

```
Delay startup: false
Fail liveness: false
Fail readiness: false
```

## Files

```
app/
  Dockerfile
  package.json
  src/
    index.js
outputs/
  01-source-path.txt
  02-source-files.txt
  03-node-docker-files.txt
  04-js-entrypoint-hints.txt
  05-copied-app-files.txt
  06-index-before.txt
  07-package-json-before.txt
  08-dockerfile-before.txt
  09-index-after.txt
  10-package-json-after.txt
  11-probes-code-proof.txt
  12-docker-build.txt
  13-docker-run.txt
  14-endpoints-test.txt
  15-container-logs.txt
  16-docker-push.txt
  17-remove-test-container.txt
  18-local-images.txt
  19-final-files-created.txt
  20-remote-image-verified.txt
  21-lab-conclusion.txt
  22-final-files-created.txt
```

## Conclusion

`idf775/color-api:1.2.0` is ready for probe testing. Three env vars control probe behavior without rebuilding the image.
