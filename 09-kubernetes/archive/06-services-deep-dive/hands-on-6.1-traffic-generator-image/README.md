# Hands-On 6.1 - Traffic Generator Image

> **Series**: Kubernetes Learning Path — Module 06 - Services Deep Dive
> **Status**: done

---

## Purpose

Build a reusable traffic generator Docker image that sends HTTP requests to a target URL at a configurable interval. This image serves as the load-generation client for all upcoming Services Deep Dive demos (ClusterIP, NodePort, ExternalName).

---

## What Was Built

### `traffic-gen.sh`

- Written with `#!/bin/sh` — Alpine does not include bash by default
- Validates at least two arguments: `<target>` and `<interval>`
- Stores `TARGET=$1` and `INTERVAL=$2`
- Loops forever, printing a timestamp and the server response on each iteration
- Designed to be stopped with `Ctrl+C` or `timeout`

### `Dockerfile`

- Base image: `alpine:3.20`
- Installs `curl` via `apk add --no-cache curl`
- Copies `traffic-gen.sh` into `/app`
- Sets executable permission (`chmod +x`)
- Entrypoint: `["./traffic-gen.sh"]`

---

## Final Image

```
idf775/traffic-generator:1.0.0
```

### Docker Hub Digest

```
sha256:13a4f1fb7764515bd8e73ae5d9089c9528bc328d0fe53d1166a8496c522ba5b8
```

RepoDigest:

```
idf775/traffic-generator@sha256:13a4f1fb7764515bd8e73ae5d9089c9528bc328d0fe53d1166a8496c522ba5b8
```

---

## Local Script Test Summary

Color API container used for testing:

| Item | Value |
|------|-------|
| Container name | `hands-on-6-dev-color-api` |
| Image | `idf775/color-api:1.1.0` |
| Test endpoint | `http://localhost:8080/api` |
| API response | `color=blue hostname=d35333d1a137` |

Command:

```sh
timeout 4s ./traffic-gen.sh http://localhost:8080/api 0.5
```

Observed output:

```
Sending traffic to http://localhost:8080/api every 0.5 seconds...
[2026-06-13 19:39:24] color=blue hostname=d35333d1a137
[2026-06-13 19:39:25] color=blue hostname=d35333d1a137
[2026-06-13 19:39:26] color=blue hostname=d35333d1a137
[2026-06-13 19:39:27] color=blue hostname=d35333d1a137
[2026-06-13 19:39:27] color=blue hostname=d35333d1a137
[2026-06-13 19:39:28] color=blue hostname=d35333d1a137
```

---

## Container Test Summary

### Usage validation

```sh
docker run --rm idf775/traffic-generator:1.0.0
```

Output:

```
Usage: ./traffic-gen.sh <target> <interval>
```

### HTTP test against public URL

```sh
timeout 5s docker run --rm idf775/traffic-generator:1.0.0 https://example.com 1
```

Result: container printed timestamped HTML responses from `example.com`.

### Color API via `host.docker.internal`

```sh
timeout 5s docker run --rm idf775/traffic-generator:1.0.0 http://host.docker.internal:8080/api 0.5
```

Output:

```
Sending traffic to http://host.docker.internal:8080/api every 0.5 seconds...
[2026-06-13 16:48:20] color=blue hostname=d35333d1a137
[2026-06-13 16:48:21] color=blue hostname=d35333d1a137
[2026-06-13 16:48:21] color=blue hostname=d35333d1a137
[2026-06-13 16:48:22] color=blue hostname=d35333d1a137
[2026-06-13 16:48:22] color=blue hostname=d35333d1a137
[2026-06-13 16:48:23] color=blue hostname=d35333d1a137
[2026-06-13 16:48:23] color=blue hostname=d35333d1a137
[2026-06-13 16:48:24] color=blue hostname=d35333d1a137
```

---

## Files Created

```
hands-on-6.1-traffic-generator-image/
├── README.md
├── app/
│   ├── .gitignore
│   ├── Dockerfile
│   └── traffic-gen.sh
├── outputs/
│   ├── 00-local-script-test.txt
│   ├── 01-container-usage-test.txt
│   ├── 02-container-http-test.txt
│   ├── 03-color-api-through-host-docker-internal.txt
│   └── 04-docker-push-digest.txt
└── images/
    └── README.md
```

---

## Commands Used

```sh
# Build image
docker build -t idf775/traffic-generator:1.0.0 .

# Test usage validation
docker run --rm idf775/traffic-generator:1.0.0

# Test against public URL
timeout 5s docker run --rm idf775/traffic-generator:1.0.0 https://example.com 1

# Test against Color API via host bridge
timeout 5s docker run --rm idf775/traffic-generator:1.0.0 http://host.docker.internal:8080/api 0.5

# Push to Docker Hub
docker push idf775/traffic-generator:1.0.0

# Inspect digest
docker inspect --format='{{json .RepoDigests}}' idf775/traffic-generator:1.0.0
```

---

## Key Notes

- `#!/bin/sh` is required in Alpine — bash is not installed by default
- `host.docker.internal` resolves to the host machine from inside a Docker container on Docker Desktop (Mac/Windows)
- The script uses `sleep $INTERVAL` between requests so interval is approximate, not exact
- The image is minimal: Alpine + curl only — ~12MB total

---

## Next Use in Services Demos

This image will be used in:

- **Hands-On 6.2** — direct Pod-to-Pod traffic before introducing a Service
- **Hands-On 6.3** — traffic through a ClusterIP Service
- **Hands-On 6.4** — traffic through a NodePort Service
- **Hands-On 6.6** — ExternalName Service demonstration
