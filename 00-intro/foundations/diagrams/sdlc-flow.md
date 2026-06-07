# SDLC Flow

```mermaid
graph LR
    R[Requirements<br>Define what to build] --> D[Design<br>Architecture decisions]
    D --> DEV[Development<br>Write code]
    DEV --> T[Testing<br>Validate against requirements]
    T --> PROD[Production<br>Deploy to users]
    PROD --> M[Maintain<br>Monitor & optimize]
    M -->|New requirements| R

    T -->|Bugs found| DEV
    PROD -->|Incidents| DEV
```

## Key Points

- The cycle is continuous - maintenance generates new requirements
- Requirements errors propagate through every subsequent phase
- Testing validates against requirements, not against assumptions
- Maintenance is the longest phase - "the infinity stage"
- DevOps automates the path from Development through Production and Maintenance
