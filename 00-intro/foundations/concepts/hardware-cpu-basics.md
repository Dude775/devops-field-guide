# Hardware and CPU Basics

## TL;DR

The CPU is the brain of the computer. Cores are small brains inside it, threads are the hands each brain gets, and GHz is the speed. The kernel translates software requests into hardware actions.

## Full Picture

### CPU - The Brain
The Central Processing Unit executes instructions. Everything your computer does - running code, rendering pages, processing data - goes through the CPU.

### Cores - Small Brains Inside the Processor
Modern CPUs have multiple cores. Each core can execute instructions independently. More cores means more tasks can run simultaneously.

- Minimum: 4 cores
- Good: 8-10+ cores
- Each core handles its own workload in parallel

### Threads - Hands the Brain Gets
Threads are the execution paths within each core. Most modern CPUs support hyper-threading, which gives each core two threads. A 4-core CPU with hyper-threading has 8 threads.

- Usually 2x the number of cores
- More threads = more concurrent task handling

### GHz - Speed
Gigahertz measures the clock speed - how many cycles per second a core can execute.

- Typical range: 2.6 GHz to 4.6 GHz
- Higher is faster, but not the only factor (architecture matters too)

### The Kernel
The kernel is the core of the operating system. It sits between software and hardware, translating requests from applications into instructions the hardware understands. When a program says "save this file," the kernel translates that into specific disk operations.

### 64-bit Architecture
Modern systems use 64-bit architecture, which determines how much memory the CPU can address and how large each processing unit of data can be.

### Apple Silicon Note
Apple's M-series chips (M1, M2, M3) use a fundamentally different architecture (ARM) than AMD/Intel chips (x86). This means software compiled for one may not run natively on the other. Compatibility layers like Rosetta 2 exist but add overhead. This matters when choosing Docker images and build targets.

### How to Check
On Windows: Task Manager -> Performance tab shows cores, threads, and speed.

## Why It Matters for DevOps

When provisioning cloud servers, you choose CPU specifications. Understanding cores vs threads vs clock speed determines whether you pick a compute-optimized instance (high clock speed, fewer cores) or a general-purpose one. Kubernetes resource requests are specified in CPU cores. Docker containers share the host's CPU. ARM vs x86 affects which container images work on which infrastructure.

## Key Takeaways

- CPU cores = parallel processing capacity
- Threads = 2x cores typically (hyper-threading)
- GHz = speed per core
- Kernel = OS layer between software and hardware
- ARM (Apple) vs x86 (Intel/AMD) creates compatibility considerations
- Cloud provisioning requires understanding these concepts

## Real-World Example

A team deploys a Node.js application (single-threaded by default) on a 16-core server. The application uses one core and ignores the other 15. They are paying for 16x the compute they need. Understanding that Node.js is single-threaded per process would have led them to either choose a smaller instance or run multiple processes with a process manager like PM2.
