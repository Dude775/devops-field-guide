# Vibe Coding vs Agentic Engineering

## TL;DR

Vibe coding - telling AI what you want without understanding the domain - produces garbage. Agentic engineering - giving AI precise instructions from a place of understanding - produces level 10 results.

## Full Picture

### Vibe Coding
"Make me a website that does X." The AI generates something that looks right on the surface but is fundamentally broken underneath.

**The Sink Analogy**: You ask AI to install a sink. The pipe works - water flows. But everything around it is broken: no shut-off valve, wrong pipe diameter, no P-trap, water damage to the cabinet. It technically functions. It is not production-ready.

The output of vibe coding looks impressive in a demo and collapses in production. The person using it cannot evaluate the quality because they don't understand the domain well enough to know what "good" looks like.

### Agentic Engineering
The same AI tools, but wielded by someone who understands what they are building. Precise instructions. Clear constraints. Domain knowledge guiding every prompt.

"A regular person without AI = junior level. A programmer who understands + AI = an entire team."

The difference is not the tool. It is the operator.

### Security Risks
AI wants to please you. It will say "yes" and generate code that appears to work. It will not warn you about security implications unless you know to ask. This creates a dangerous pattern: people who don't understand security use AI to generate code that handles sensitive data, and the AI happily produces something that leaks information.

**The Base64 Example**: Someone uses AI to "encrypt" data. The AI suggests Base64 encoding. Base64 is not encryption - it is encoding, trivially reversible by anyone. But the person does not know the difference, the AI does not push back, and sensitive data gets "protected" by something that provides zero security.

### PRDs and Understanding
A Product Requirements Document (PRD) written by someone who does not understand the technical domain is "pure garbage." The document might have the right structure and the right buzzwords, but the requirements will be vague, contradictory, or technically impossible. AI can help write a PRD, but only if the human guiding it understands what they are specifying.

## Why It Matters for DevOps

DevOps engineers increasingly use AI to generate Terraform configs, Dockerfiles, CI/CD pipelines, and monitoring rules. The difference between a DevOps engineer who understands infrastructure using AI, and someone who does not understand infrastructure asking AI to generate configs, is the difference between a production-grade system and a ticking time bomb.

## Key Takeaways

- AI amplifies existing knowledge - it does not replace it
- Vibe coding produces demos. Agentic engineering produces production systems.
- AI will not push back on bad ideas - it wants to please you
- Security is the highest-risk area for AI-generated code
- Understanding the domain is the prerequisite for using AI effectively

## Real-World Example

Two people ask AI to write a Dockerfile. Person A says "make a Dockerfile for my Python app." They get a working Dockerfile that runs as root, includes the entire build toolchain in the final image, stores secrets in environment variables, and uses `latest` tags. Person B says "create a multi-stage Dockerfile for a Python 3.11 FastAPI app, non-root user, minimal final image, no build dependencies in production, pinned versions." They get a production-grade Dockerfile. Same tool. Different operator.
