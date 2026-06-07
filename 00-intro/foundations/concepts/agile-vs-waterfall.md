# Agile vs Waterfall

## TL;DR

Waterfall is the old way - plan everything upfront, deliver once. Agile is the current way - plan in small increments, deliver constantly. DevOps exists because Agile won.

## Full Picture

### Waterfall
The traditional approach: gather all requirements, design everything, build everything, test everything, deploy once. "Meet in 6 months and see the result."

This method is largely irrelevant for modern software. The world changes too fast. By the time you deliver after six months, the requirements have shifted, competitors have moved, and half the assumptions are wrong.

### Agile
Constant changes, frequent releases, almost weekly deployments. Work in small iterations (sprints), get feedback, adjust, repeat.

**The Shoemaker Analogy**: A waterfall shoemaker measures your foot once, disappears for three months, and delivers a shoe that may or may not fit. An agile shoemaker makes a rough prototype in a week, has you try it on, adjusts, and iterates until it fits perfectly. Each version is better than the last.

### The Connection to DevOps

Agile created a problem: if you release weekly instead of every six months, you need deployment processes that can keep up. Manual deployments every week? Unsustainable. Manual testing every week? Too slow.

This is exactly why the traditional Ops role merged with Development. The pace of Agile delivery demanded automation, infrastructure as code, and continuous integration/deployment. DevOps is the operational answer to Agile's velocity.

## Why It Matters for DevOps

Every tool and practice in DevOps - CI/CD pipelines, automated testing, infrastructure as code, container orchestration - exists to support Agile delivery at scale. Understanding this history explains why these tools were created and what problems they solve.

## Key Takeaways

- Waterfall: one big delivery. Agile: many small deliveries.
- Agile's speed created the operational pressure that birthed DevOps
- DevOps automates what Agile demands
- If releases are frequent, everything around them must be automated

## Real-World Example

A company using waterfall releases their product twice a year. They switch to Agile and start releasing every two weeks. Suddenly, the operations team that used to do 2 deployments a year now handles 26. They can't keep up manually. They automate. They adopt CI/CD. They containerize. They have become a DevOps team without anyone officially renaming them.
