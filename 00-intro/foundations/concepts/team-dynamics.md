# Team Dynamics

## TL;DR

Software organizations are built from teams with fundamentally different incentives. Understanding these conflicts is not optional - it is how you navigate the real world of shipping software.

## Full Picture

### Product Team
**The Restaurant Menu Analogy**: Product decides what is on the menu. They don't cook, but without them there is no menu and no customers.

Product managers are like event managers who sell tickets to a show that hasn't been built yet. They use tools like Jira to define features, prioritize work, and communicate with stakeholders. Their core pressure: a feature not reaching customers has almost zero value. Ship fast, ship often.

### Development Team
Developers write the code. The uncomfortable truth: "90% of my time is fixing bugs." Developers want to write clean code, finish features, and disconnect at the end of the day. They are "lazy by nature" - not in a negative sense, but in the sense that good developers automate repetitive work and resist unnecessary complexity.

### QA Team
**The Factory Quality Control Analogy**: QA is the inspector at the end of the production line, checking every unit before it ships.

Two modes of testing:
- **Manual testing**: Human testers clicking through the application
- **Automated testing**: Scripts that test automatically (the direction everything is moving)
- **Regression testing**: Re-testing everything after a change to make sure nothing broke. Like checking every electrical socket in a building after rewiring one room. "Don't talk to QA during regression" - they are deep in concentration and the stakes are high.

### Ops Team
The traditional operations team has largely been absorbed into DevOps. They used to manage servers, deployments, and infrastructure as a separate function. The merger with development practices is literally why "DevOps" exists as a discipline.

### IT Team
**The Building Superintendent Analogy**: IT maintains the building - networks, hardware, access, internal tools. They keep the lights on so everyone else can work.

### Security Team
"Any system too open will be breached." Security reviews architecture, audits access, monitors threats, and enforces policies. They are often seen as blockers, but they exist because the consequences of a breach are existential.

### The Conflict Chain

```
Management/Client -> Product -> Development -> QA -> back to Product
```

Product pushes developers to ship faster. Developers push back on unrealistic timelines. QA finds bugs that delay releases. Product pushes for shortcuts. The cycle repeats.

"The enemy of my enemy is my friend" - alliances shift based on who is applying pressure. Dev and QA might clash during testing but unite against Product when timelines are unrealistic.

## Why It Matters for DevOps

DevOps sits at the intersection of all these teams. You need to speak Product's language (uptime, features, velocity), Development's language (code, environments, dependencies), QA's language (test coverage, regression), and Security's language (access control, compliance). The DevOps engineer who understands team dynamics navigates organizational friction instead of being crushed by it.

## Key Takeaways

- Every team has different incentives - this creates natural, unavoidable friction
- Product measures value by features shipped to users
- Development measures value by code quality and completed work
- QA measures value by bugs caught before production
- DevOps must bridge all of these perspectives
- Understanding the conflict chain helps you anticipate blockers and navigate politics

## Real-World Example

A product manager promises a client a feature by Friday. Development says it needs two weeks. Product escalates to management. Management pressures development. Development cuts corners - skips tests, hardcodes values. QA finds critical bugs on Thursday. The release is delayed to the following Wednesday anyway, but now with technical debt that will slow down the next three features. Everyone did their job according to their incentives. The system produced a bad outcome. DevOps processes (CI/CD, automated testing, realistic estimation) exist to break this cycle.
