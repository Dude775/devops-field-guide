# Hands-On 6.0 — Color API Update and New Image for Services

> **Module**: 06 - Services Deep Dive
> **Audience**: Non-Developers (Docker + Node primer)
> **Status**: Done
> **Image published**: `idf775/color-api:1.1.0`

## Goal

Build a versioned Docker image for a simple Node/Express Color API and push it to Docker Hub. This image is the foundation used in later hands-on labs that wire up Kubernetes Services.

The lab also demonstrates the **hostname shift**: the `/api` endpoint returns the hostname of the process, which changes from the local machine name when running with `npm start` to the container ID prefix when running inside Docker — previewing what happens inside Kubernetes Pods.

## Source Notes

The original lab ZIP from the course had an incorrect structure:

| File in ZIP | Problem |
|-------------|---------|
| `app/Dockerfile` | Was a **traffic-generator** Dockerfile (alpine + curl + shell script) — wrong |
| `app/src/Dockerfile` | Duplicate traffic-generator Dockerfile placed inside `src/` — also wrong |

**How it was fixed:**

1. The correct Color API Dockerfile was provided separately as `Dockerfile.color-api`.
2. `app/Dockerfile` was replaced with the correct Color API content.
3. The wrong original was preserved as `Dockerfile.traffic-generator.bak` for reference.
4. `app/src/Dockerfile` is not copied here — it was an artifact of the broken ZIP.

## App Structure

```
app/
├── Dockerfile                      ← working Color API Dockerfile (node:22-alpine3.20)
├── Dockerfile.color-api            ← identical backup; original correct source
├── Dockerfile.traffic-generator.bak  ← evidence of the broken ZIP's original main Dockerfile
├── .dockerignore                   ← excludes node_modules
├── package.json
├── package-lock.json
└── src/
    └── index.js                    ← Express app: GET / and GET /api
```

## Commands Used

### Local test (no Docker)

```bash
npm ci
npm start
# -> Color API listening on port: 80

curl localhost
# <h1 style="color:blue;">Hello from Color API</h1> <h2>DDDD</h2>

curl localhost/api
# COLOR: blue, HOSTNAME: DDDD

curl "localhost/api?format=json"
# {"color":"blue","hostname":"DDDD"}
```

### Build Docker image

```bash
docker build -t idf775/color-api:1.1.0 .
```

### Run container

```bash
docker run -d --name hands-on-6-color-api -p 8080:80 idf775/color-api:1.1.0

docker ps
# CONTAINER ID: c1b79c850ae5  PORTS: 0.0.0.0:8080->80/tcp
```

### Verify hostname inside container

```bash
curl localhost:8080/api
# COLOR: blue, HOSTNAME: c1b79c850ae5
```

`c1b79c850ae5` matches the container ID prefix shown in `docker ps` — confirmed.

### Push to Docker Hub

```bash
docker push idf775/color-api:1.1.0
# digest: sha256:c447a0e4b12f3eb7bad18522ff7afe6954a86ffc37ca755fd14f135b5d5fa108

docker manifest inspect idf775/color-api:1.1.0
```

## Verification Results

| Check | Result |
|-------|--------|
| `npm ci` | OK — 103 packages installed |
| `GET /` | OK — returns colored HTML with hostname |
| `GET /api` | OK — returns `COLOR: blue, HOSTNAME: <host>` |
| `GET /api?format=json` | OK — returns JSON `{color, hostname}` |
| `docker build` | OK — `idf775/color-api:1.1.0` built |
| Container run | OK — `hands-on-6-color-api` on `localhost:8080` |
| Hostname in container | OK — `c1b79c850ae5` matched container ID prefix |
| Docker Hub push | OK — digest `sha256:c447a0e4b12f3eb7bad18522ff7afe6954a86ffc37ca755fd14f135b5d5fa108` |

## Key Takeaway

**Hostname = identity.** Running the same code in three contexts produces a different hostname each time:

| Context | Hostname |
|---------|---------|
| `npm start` (local machine) | `DDDD` (OS hostname) |
| `docker run` (container) | `c1b79c850ae5` (container ID prefix) |
| Kubernetes Pod | `color-api-deployment-abc12-xyz99` (Pod name) |

A **Kubernetes Service** sits in front of one or more Pods and provides a stable DNS name (`color-api-svc.default.svc.cluster.local`) regardless of which Pod ID answers the request. This is the mental model this lab is building toward.
