# Screenshots - Series 5: ReplicaSets and Deployments

Place screenshots from Labs 5.0-5.3 here.

| File name | What to capture |
|-----------|----------------|
| `00-rs-three-pods-running.png` | kubectl get pods -l app=nginx -o wide showing 3 Pods running |
| `01-rs-image-change-no-rollout.png` | jsonpath output showing old image still running after RS apply |
| `02-rs-adopts-solo-pod.png` | jsonpath ownerReferences output showing solo-nginx adopted by ReplicaSet |
| `03-deployment-created-rs.png` | kubectl get deploy and kubectl get rs showing Deployment created RS |
| `04-pod-template-hash-labels.png` | kubectl get pod -o yaml showing labels with pod-template-hash |
