# SDLC - Software Development Life Cycle

## TL;DR

The SDLC is the full journey from "we need something" to "it is running in production and we are maintaining it forever." Requirements come first, and getting them wrong poisons everything downstream.

## Full Picture

### 1. Requirements - The Most Critical Phase

If you don't understand things at the start, you enter a loop. A requirement not defined correctly does not disappear - it comes back as bugs, rework, and missed deadlines.

**The Bus Analogy**: If you board the wrong bus, every stop takes you further from your destination. Catching the mistake early is cheap. Catching it after 30 stops is expensive. Catching it in production is a disaster.

**The Clothing Site Example**: A client wants a carousel on their e-commerce site. "Add a carousel" is not a requirement. How many items? Auto-scroll or manual? Mobile behavior? Loading strategy? Click action? Every undefined detail becomes a future argument or bug.

Requirements gathering is typically done by Product teams using tools like Jira. The goal is precision - ambiguity at this stage multiplies into chaos later.

### 2. Design - Architecture, Not UX

This is not about how the app looks. It is about how it is built. Technology choices, database selection, API structure, scaling strategy.

Key considerations:
- Scaling for 10 users vs 10,000 users requires fundamentally different architecture
- Documentation is "very very very important" - decisions made now will be questioned later
- Don't be optimistic - always think worst case
- Auto-scaling: systems should handle load spikes without manual intervention

### 3. Development - Code + Environment

Developers write code, integrate libraries, and work in local environments. This phase is where the actual building happens, but it is only one piece of the cycle.

### 4. Testing - Per Requirements

Testing validates against the original requirements. If the requirements were wrong, the tests pass but the product fails. Types include unit tests, integration tests, and regression testing.

### 5. Operate/Maintain - The Infinity Stage

This stage never ends. Once an application is in production, it must be monitored, maintained, patched, and optimized continuously.

Performance matters at the margins: 7 seconds vs 6 seconds load time can determine whether users stay or leave. Monitoring catches degradation before users report it.

## Why It Matters for DevOps

DevOps touches every phase of the SDLC except writing the business requirements. CI/CD automates the path from development through testing to production. Infrastructure as Code handles the design implementation. Monitoring covers the operate/maintain phase. Understanding the full cycle prevents tunnel vision.

## Key Takeaways

- Requirements errors are the most expensive errors - they compound through every phase
- Design means architecture and worst-case planning, not visual design
- Testing is only as good as the requirements it validates against
- Operation is the longest phase - most of an application's life is spent here
- DevOps spans from development through operation

## Real-World Example

A team skips detailed requirements for a notification system. "Send notifications to users" is the spec. Six months later: no one defined which events trigger notifications, how often, through which channels, or what the opt-out flow looks like. The feature ships, users are spammed, complaint tickets flood support, and the team spends three months rebuilding what should have been defined in week one.
