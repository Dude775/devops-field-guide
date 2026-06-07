# Production vs Development

## TL;DR

Production is where real users connect to servers with a real internet address. Development is your local machine. Code that works in dev is not necessarily production-ready.

## Full Picture

**Development** is your laptop. You write code, test it, break it, fix it. Nobody else sees it. If it crashes, you restart and move on.

**Production** is a server (or cluster of servers) with a public internet address where actual users connect. It is running 24/7. If it crashes, customers are affected, revenue is lost, and someone gets paged at 3 AM.

The critical transition moment: when an application goes to production for the first time, it stops being a project and becomes an organizational **Product**. That shift changes everything - suddenly there are SLAs, uptime requirements, security obligations, and real consequences for failure.

The fundamental problem: what works on your machine may not work in production. Different operating systems, different configurations, different network conditions, different scale. A developer says "it works on my machine" and the ops team says "well, it does not work on ours."

The solution to this gap is **Docker** (covered in Module 08) - packaging an application with its exact environment so it runs the same everywhere.

## Why It Matters for DevOps

The entire DevOps discipline exists in the space between development and production. Building the bridge - making code reliably travel from a developer's laptop to production servers - is the core job. Every tool in this course (Docker, CI/CD, Kubernetes, Terraform) addresses some aspect of this gap.

## Key Takeaways

- Development = local, safe, isolated. Production = public, critical, real.
- The transition to production transforms a project into a Product
- "Works on my machine" is not a deployment strategy
- Docker solves the environment consistency problem
- Production demands monitoring, security, and reliability that dev does not

## Real-World Example

A developer builds a feature using Python 3.12 on macOS. The production server runs Python 3.9 on Ubuntu. The feature uses a syntax feature introduced in 3.10. It passes all local tests. It crashes immediately in production. This exact scenario is why containers exist.
