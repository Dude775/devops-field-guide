\# Hands-On 6.0 - Color API update for Services \[Devs Only]



\## Goal



Update the Color API so each response includes the container hostname.



This prepares the app for Kubernetes Services labs, where hostname helps identify which Pod returned the response.



\## What was done



\- Added Node.js os module

\- Added hostname variable from os.hostname()

\- Updated the main HTML route

\- Added /api endpoint

\- Added text response for /api

\- Added JSON response for /api?format=json

\- Built Docker image idf775/color-api:1.1.0

\- Ran local container on localhost:8080

\- Verified hostname against Docker Container ID

\- Pushed image to Docker Hub



\## Endpoints



| Endpoint | Format | Result |

|---|---|---|

| / | HTML | Shows color and hostname |

| /api | Text | color=blue hostname=container-id-prefix |

| /api?format=json | JSON | color and hostname fields |



\## Docker



| Item | Value |

|---|---|

| Image | idf775/color-api:1.1.0 |

| Container | hands-on-6-dev-color-api |

| Port | localhost:8080 -> 80 |



\## Verification



Container ID prefix and app hostname matched.



Example:



\- Container ID prefix: fcc58120531a

\- Hostname returned by app: fcc58120531a



\## Files



| Path | Purpose |

|---|---|

| app/src/index.js | Updated Color API source |

| app/Dockerfile | Docker build file |

| outputs/curl-checks.txt | Endpoint checks |

| outputs/container-running.txt | Container proof |

| outputs/docker-image.txt | Local image proof |

| outputs/docker-hub-tag-1.1.0.txt | Docker Hub tag check |



\## Notes



This is the Developers version of Hands-On 6.0.



The Non Developers version is documented in a separate folder and was not modified.



