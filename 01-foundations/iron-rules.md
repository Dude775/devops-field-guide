# Iron Rules - Week 1

Principles collected from the Foundations module. These are non-negotiable truths.

---

**"An application is not code."**
It is a solution living inside an organization - code + infrastructure + processes + people + decisions.

**"Tech decisions are also organizational decisions."**
Every architecture choice affects teams, budgets, timelines, and capabilities.

**"If it works, don't touch it."**
Stability has value. Change for the sake of change introduces risk.

**"Any system too open will be breached."**
Security is not a feature - it is a constraint that must be enforced at every layer.

**"What you don't need, don't use."**
Complexity is cost. Every unused dependency, feature, or service is a liability.

**"Always think worst case."**
Design for failure. Plan for the spike. Assume the breach. Hope is not a strategy.

**"A requirement not defined correctly doesn't disappear - it comes back as bugs."**
Ambiguity in requirements multiplies into chaos downstream.

**"Bug in code = incident. Bug in data = crisis."**
You can patch code. You cannot un-leak data.

**"Code that works in dev is not necessarily production-ready."**
The gap between development and production is where DevOps lives.

---

## From Idea to Production

**"Without a real person with a real problem, what you build has no meaning."**
- Technology for its own sake is a hobby. Solutions start with empathy.

**"You don't build an application - you build a solution for someone."**
- This reframes every technical decision from tool-first to user-first.

**"The moment it goes public, it's no longer code - it's a service."**
- Services carry obligations: uptime, performance, data integrity, security.

**"The more something succeeds, the more complex it becomes."**
- Scale isn't a reward. It's a new engineering domain.

**"DevOps was born the moment a small idea became a living system."**
- Not a career trend. An inevitable response to production reality.

## Client-Server Model

**"The client always initiates. The server only responds."**
- This asymmetry drives every architecture decision from load balancing to WebSocket design.

**"Working locally is not working."**
- A localhost demo proves nothing about production readiness.

**"Servers are professional kitchens - they need professional management."**
- No monitoring, no configuration management, no automation = no production.
