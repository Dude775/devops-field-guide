# DevOps Field Guide - From Theory to Production

A practitioner's field guide for the journey from fundamentals to production-grade DevOps engineering.

## What This Is

This repository operates on three levels:

1. **Field Guide** - Distilled concepts, patterns, and principles for each DevOps domain, written to be referenced in practice
2. **Learning Journal** - Honest reflections, surprises, and connections discovered along the way
3. **Live Projects** - A rolling project that evolves with each module, accumulating real infrastructure

## Course Roadmap

| # | Module | Focus | Status |
|---|--------|-------|--------|
| 00 | [Intro](00-intro/) | DevOps philosophy, SDLC, team dynamics | Done |
| 01 | [Linux](01-linux/) | Command line, filesystem, permissions, scripting | Done |
| 02 | [Python Basics](02-python-basics/) | Syntax, data structures, scripting | Done |
| 03 | [Git & GitHub](03-git/) | Version control, branching, collaboration | Done |
| 04 | [Advanced Python](04-advanced-python/) | OOP, Flask, APIs, automation | Done |
| 05 | [Networking](05-networking/) | TCP/IP, DNS, HTTP, firewalls | Done |
| 06 | [AWS](06-aws/) | Cloud fundamentals, core services | Done |
| 07 | [Docker](07-docker/) | Containers, images, Compose | Done |
| 08 | [CI/CD](08-ci-cd/) | Pipelines, automation, deployment strategies | Upcoming |
| 09 | [Kubernetes](09-kubernetes/) | Orchestration, pods, services | In Progress |
| 10 | [Helm](10-helm/) | Package management for Kubernetes | Upcoming |
| 11 | [AWS Advanced](11-aws-advanced/) | ECS, ECR, EKS | Upcoming |
| 12 | [Terraform](12-terraform/) | Infrastructure as Code | Upcoming |
| 13 | [Jenkins](13-jenkins/) | Build automation, pipeline orchestration | Upcoming |
| 14 | [Observability](14-observability/) | Grafana, monitoring, dashboards | Upcoming |
| 15 | [ArgoCD](15-argocd/) | GitOps, continuous delivery | Upcoming |

## Iron Rules

Principles collected throughout the course. These are non-negotiable truths earned through practice.

- "An application is not code." - it is a solution living inside an organization
- "Tech decisions are also organizational decisions."
- "If it works, don't touch it."
- "Any system too open will be breached."
- "What you don't need, don't use."
- "Always think worst case."
- "A requirement not defined correctly doesn't disappear - it comes back as bugs."
- "Bug in code = incident. Bug in data = crisis."
- "Code that works in dev is not necessarily production-ready."
- "insert_one() mutates your dict â€” handle `_id` before responding."
- "Credentials in code = credentials in git. Use .env from day one."
- "Circular imports? Extract shared resources to their own module."

*This list grows with each module.*

## About the Author

**David Rubin** - AI Solutions Specialist transitioning to DevOps Engineering.

Currently bridging the gap between business needs and technical implementation, now building depth in infrastructure, automation, and production systems.

- GitHub: [@Dude775](https://github.com/Dude775)
- Portfolio: [system-portfolio.vercel.app](https://system-portfolio.vercel.app)

