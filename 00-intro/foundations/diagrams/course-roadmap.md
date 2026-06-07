# Course Roadmap

```mermaid
graph TD
    M00[00 Pre-Course<br>Web Fundamentals] --> M01[01 Foundations<br>DevOps Philosophy]
    M01 --> M02[02 Linux<br>Command Line & Shell]
    M01 --> M03[03 Networking<br>TCP/IP & DNS]
    M02 --> M04[04 Python Basics<br>Scripting Fundamentals]
    M02 --> M05[05 Git & GitHub<br>Version Control]
    M04 --> M06[06 Python Advanced<br>OOP & APIs]
    M03 --> M07[07 AWS<br>Cloud Services]
    M05 --> M07
    M06 --> M08[08 Docker<br>Containers & Images]
    M07 --> M08
    M05 --> M09[09 CI/CD<br>Pipelines & Automation]
    M08 --> M09
    M08 --> M10[10 Kubernetes<br>Orchestration]
    M10 --> M11[11 Helm<br>K8s Packaging]
    M07 --> M12[12 Terraform<br>Infrastructure as Code]
    M10 --> M13[13 ArgoCD<br>GitOps]
    M09 --> M13
    M02 --> M14[14 Ansible<br>Config Management]
    M09 --> M15[15 Jenkins<br>Build Automation]
    M10 --> M16[16 Grafana<br>Monitoring & Observability]
```

## Reading the Map

- Arrows show prerequisites - follow them top to bottom
- Modules at the same level can be studied in parallel
- The core path runs through the center: 00 -> 01 -> 02 -> 04 -> 06 -> 08 -> 10
- Cloud (07, 12) and GitOps (13) branch off as specialized tracks
