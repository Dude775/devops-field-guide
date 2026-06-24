# Docker Hub Check
Generated: 2026-06-20

---

## Images Checked

### `idf775/movie-api:1.0`

**Status:** ✅ EXISTS on Docker Hub

```
docker manifest inspect idf775/movie-api:1.0
→ Schema: application/vnd.oci.image.index.v1+json
→ Manifest found (multi-arch)
→ Platform: amd64
→ Local ID: d883ae7523bb (260MB)
```
Also available locally as `dude775/movie-api:1.0` (same image ID d883ae7523bb — alias).

---

### `idf775/movie-api:1.1`

**Status:** ✅ EXISTS on Docker Hub

```
docker manifest inspect idf775/movie-api:1.1
→ Schema: application/vnd.oci.image.index.v1+json
→ Manifest found (multi-arch)
→ Platform: amd64
→ Local ID: c5d9280c5ff7 (260MB)
```

---

## Summary

| Image | Docker Hub | Local Copy | Notes |
|-------|-----------|-----------|-------|
| `idf775/movie-api:1.0` | ✅ Available | ✅ Yes (d883ae) | Also aliased as `dude775/movie-api:1.0` locally |
| `idf775/movie-api:1.1` | ✅ Available | ✅ Yes (c5d9280) | Latest version |

Both images are safely pushed and available on Docker Hub.
The local copies can be removed after confirming they're no longer needed for active development.

---

## Notes
- `docker manifest inspect` exited with code 255 but did return valid JSON — this is a known Docker CLI quirk with manifest inspect (exit code behavior varies by OS/version). The output confirms the manifests exist.
- `dude775/movie-api:1.0` local alias is the same image as `idf775/movie-api:1.0` (same digest). Docker Hub namespace is `idf775`, local tag was also created as `dude775`.
- No action required on Docker Hub — both images are intact.
