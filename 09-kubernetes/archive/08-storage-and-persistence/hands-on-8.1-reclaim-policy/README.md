# Hands-On 8.1 — ReclaimPolicy

## Goal

Demonstrate how to retain a dynamically provisioned PersistentVolume after deleting its PVC, without modifying the existing StorageClass.

## Background

The default StorageClass in this cluster (`standard`) has `ReclaimPolicy: Delete`. This means when the PVC bound to a PV is deleted, Kubernetes automatically deletes the PV and its underlying storage.

To preserve data on a specific volume, the PV's reclaim policy can be patched directly after it is dynamically created — without touching the StorageClass.

## Commands Used

```bash
# Create namespace and PVC
kubectl apply -f pvc-standard.yaml

# Get the dynamically created PV name
kubectl get pv

# Patch the specific PV to Retain
kubectl patch pv pvc-74cf6da6-96f2-40cd-b3d5-e936ea106ee9 \
  -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}'

# Delete the PVC
kubectl delete pvc reclaim-demo-pvc -n storage-reclaim-lab
```

## Observed Behavior

| Step | State |
|------|-------|
| StorageClass `standard` initial policy | Delete |
| PVC `reclaim-demo-pvc` created | Bound |
| Dynamically created PV | `pvc-74cf6da6-96f2-40cd-b3d5-e936ea106ee9` |
| PV initial reclaim policy | Delete |
| After patch | Retain |
| After PVC deleted | PV moved to **Released** (not deleted) |
| StorageClass after lab | Delete (unchanged) |

## Key Concept

A dynamically provisioned PV inherits the ReclaimPolicy from its StorageClass at creation time. After the PV exists, its `persistentVolumeReclaimPolicy` field can be patched independently — it is decoupled from the StorageClass going forward.

## Discussion

**Why not modify an existing StorageClass in production?**

StorageClass changes only affect PVs created after the change. Existing PVs are unaffected. Modifying a shared StorageClass is a cluster-wide action that could surprise other teams and workloads relying on Delete behavior for cleanup. Patching the specific PV is safer and targeted.

**Difference between Delete and Retain:**

- `Delete` — when the PVC is deleted, Kubernetes deletes the PV and the underlying storage resource automatically.
- `Retain` — when the PVC is deleted, the PV moves to `Released` state. The data is preserved. Manual reclamation is required before the PV can be reused.

**When can a dynamically-created PV's reclaim policy be changed?**

At any time after the PV is created, using `kubectl patch`. The change takes effect on the next lifecycle event (PVC deletion). There is no need to recreate the PV.

**Pros and cons of Retain vs Delete:**

| | Retain | Delete |
|---|---|---|
| Data safety | High — data survives PVC deletion | Low — data deleted automatically |
| Cluster hygiene | Low — Released PVs accumulate and need manual cleanup | High — storage is reclaimed automatically |
| Operational overhead | Higher — manual review and rebind needed | Lower — fully automatic |
| Good for | Stateful data, databases, accidental deletion protection | Ephemeral or short-lived workloads, CI/CD |

## Cleanup

- PVC `reclaim-demo-pvc` was deleted with `kubectl delete pvc reclaim-demo-pvc -n storage-reclaim-lab`.
- PV `pvc-74cf6da6-96f2-40cd-b3d5-e936ea106ee9` intentionally remained in `Released` state as part of the lab demonstration. It was not manually deleted.

## Files

```
pvc-standard.yaml
outputs/
  01-storageclass-standard-before.txt
  02-pvc-created.txt
  03-pv-after-pvc-created.txt
  04-created-pv-name.txt
  05-pv-before-reclaim-patch.yaml
  06-pv-after-reclaim-patch.txt
  07-pv-after-pvc-delete.txt
  08-storageclass-standard-after.txt
  09-pvc-after-delete.txt
  10-pv-final-retained.yaml
  11-lab-conclusion.txt
```

## Conclusion

Patching `persistentVolumeReclaimPolicy` on an individual PV after dynamic provisioning is the correct way to preserve a specific volume without touching the shared StorageClass. The PV survived PVC deletion and moved to `Released` state, confirming the patch worked.
