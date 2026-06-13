# Kubernetes e2e Lab Part 1 - Movie Recommendation API

## Part 1 - Application Review

- Port: 3000
- Default endpoint: /
- Health endpoint: /health
- Runtime files: app.js, package.json, package-lock.json
- Start command: npm start

## Docker Images

- v1: idf775/movie-api:v1 pushed
- v2: idf775/movie-api:v2 pushed

## Kubernetes Resources

- Deployment: movie-api-deployment created with 2 replicas
- Service: movie-api-service NodePort created

## Operations

- Scaling: scaled movie-api-deployment from 2 to 5 replicas
- Self-Healing: deleted one pod manually, ReplicaSet restored back to 5 pods
- Rolling Update: upgraded deployment from v1 to v2, service stayed available
- Rollback: rolled back from v2 to v1, service stayed available

## Part 12 - Code Update v2

- Updated movie list
- Changed response structure
- Added version v2 in response and health endpoint

## Reflection Questions

1. What is the role of a Deployment?
A Deployment manages application rollout, replicas, updates, and rollback. It keeps the desired state of the application running.

2. What is the difference between a Deployment and a ReplicaSet?
A ReplicaSet makes sure the required number of Pods is running. A Deployment manages ReplicaSets and adds rollout, update, and rollback control.

3. Why is a Service required even when Pods exist?
Pods get temporary IP addresses and can be replaced. A Service gives one stable access point and routes traffic to the matching Pods.

4. What is the advantage of Rolling Update?
Rolling Update upgrades the application gradually without stopping the service. Old Pods are replaced by new Pods step by step.

5. What is the advantage of Rollback?
Rollback allows returning quickly to a previous working version if a new release has problems.

6. How does Kubernetes perform Self-Healing?
Kubernetes compares the desired state to the actual state. When a Pod is deleted or fails, the ReplicaSet creates a replacement Pod.

7. What is the role of Labels and Selectors?
Labels identify resources. Selectors use those labels to connect resources, for example a Service selecting the correct Pods.

8. Why is it better to work with YAML Manifests instead of Imperative commands?
YAML files keep the configuration saved, repeatable, reviewable, and easier to use again. Imperative commands are faster but easier to forget or lose.
