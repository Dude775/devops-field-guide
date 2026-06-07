# Team Conflict Map

```mermaid
graph TD
    CLIENT[Client / Management<br>Wants features NOW] -->|Pressure| PROD[Product<br>Defines what to build]
    PROD -->|Feature requests & deadlines| DEV[Development<br>Writes the code]
    DEV -->|Code to test| QA[QA<br>Finds the bugs]
    QA -->|Bug reports & blocks| DEV
    QA -->|Release approval| PROD

    SEC[Security<br>Enforces policies] -->|Reviews & blocks| DEV
    SEC -->|Audit requirements| DEVOPS[DevOps<br>Builds & maintains infrastructure]
    IT[IT<br>Maintains internal systems] -->|Access & tools| DEV

    DEVOPS -->|Deployment pipeline| DEV
    DEVOPS -->|Monitoring & alerts| PROD
    DEVOPS -->|Infrastructure| QA

    style DEVOPS fill:#2d6a4f,color:#fff
```

## Conflict Patterns

| Conflict | Root Cause |
|----------|-----------|
| Product vs Dev | Unrealistic timelines vs technical reality |
| Dev vs QA | "It works on my machine" vs "It fails in testing" |
| Everyone vs Security | Speed vs safety |
| Dev vs DevOps | "Just deploy it" vs "It is not production-ready" |

## The Alliance Rule

"The enemy of my enemy is my friend." - Teams align and realign based on who is applying pressure at any given moment.
