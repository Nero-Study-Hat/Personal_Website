---
title: "MicroVMs: What they are and an Idea For My Own"
tags:
  - ideas
  - takes
  - early-concepts
---
## Preface

To understanding the separation of MicroVMs and containers try reading:
- [Firecracker vs Docker: The Technical Boundary Between MicroVMs and Containers - Hugging Face](https://huggingface.co/blog/agentbox-master/firecracker-vs-docker-tech-boundary)
- [Firecracker internals: a deep dive inside the technology powering AWS Lambda - Tal Hoffman](https://www.talhoffman.com/2021/07/18/firecracker-internals/)
- [How AWS Firecracker works: a deep dive - Shuveb Hussain](https://unixism.net/2019/10/how-aws-firecracker-works-a-deep-dive/)

Look at Firecracker used in the wild (big inspiration here):
- [Building a Firecracker-Powered Course Platform To Learn Docker and Kubernetes](https://iximiuz.com/en/posts/iximiuz-labs-story/)
- [Firecracker: start a VM in less than a second - Julia Evans](https://jvns.ca/blog/2021/01/23/firecracker--start-a-vm-in-less-than-a-second/)
- [Day 52: testing how many Firecracker VMs I can run - Julia Evans](https://jvns.ca/blog/2021/02/04/day-52--out-of-memory-errors/)
- [Blazing fast CI with MicroVMs - Actuated](https://blog.alexellis.io/blazing-fast-ci-with-microvms/)

Don't worry about reading these examples in full or understanding it all as they are more there to show what is possible, the uses, and get questions going in your head so hopefully answers pair up with those later.

To get an understanding of why the security boundary of MicroVMs is desired
- [Container Security - Natalie Somersall](https://some-natalie.dev/container-security/)
- [Seccomp, Seccomp, and Syscalls: BSidesSF and Seccomp in Kubernetes - Mark Manning](https://www.antitree.com/2026/04/seccomp-seccomp-and-syscalls-bsidessf-and-seccomp-in-kubernetes/)
- [Container Escape Telemetry: Series Overview - Daniel Wyleczuk-Stern](https://catscrdl.io/blog/containerescapetelemetry/intro/)
- [Copy Fail: 732 Bytes to Root on Every Major Linux Distribution. - Xint.io](https://xint.io/blog/copy-fail-linux-distributions)

## Firecracker isn't so scary.

It is creating a very slim virtual machine primitive using materials and scaffolding provided. It also is providing the VMM (Virtual Machine Monitor) upon which those VMs can run. All of this is based on KVM.

The notable materials it needs prepared beforehand are the networking interfaces and the file system device. The file system device needs to be populated with an init, a built kernel, and built application software to run. The scaffolding includes the things like iptables rules, kernel build pipelines, etc.

Once you understand it, Firecracker can be seen more as helpful creation and management backend tool then the front to back MicroVM handling shop.

Try reading:
- [Getting Started with Firecracker - Harry Hodge](https://www.harryhodge.co.uk/posts/2024/01/getting-started-with-firecracker/)

## What are tools like Kata Containers, Flintlock, firecracker-containerd

These tools mainly make available some combination of these three functions
1. Use existing workflows and technology to prepare the materials.
2. Orchestrate / manage the operate of the primitives that firecracker creates.
	1. By providing a conversion / integration layer to work with existing tooling like Docker, containerd and Kubernetes.
	2. By providing a new management daemon with some similarity in function to those existing in the container space.
3. Interact with the inside of the MicroVMs and the software placed running inside them.

### 1 - Material Prep

All of the networking and file system materials.

For a quick overview on the network side idea think of:
- network interfaces
- CNIs
- iptables rule chains
- eBPF maps

Try reading:
- [Networking for a Firecracker Lab - Timothy Gross](https://blog.0x74696d.com/posts/networking-firecracker-lab/)

For the file system side think of how Docker uses:
- overlayfs
- OCI images

Try reading:
- [Thoughts on creating VMMs from Docker images - Radek Gruchalski](https://gruchalski.com/posts/2021-03-03-thoughts-on-creating-vmms-from-docker-images/)
- [Day 44: Building my VMs with Docker - Julia Evans](https://jvns.ca/blog/2021/01/22/day-44--got-some-vms-to-start-in-firecracker/)
- [Day 47: Using device mapper to manage Firecracker images - Julia Evans](https://jvns.ca/blog/2021/01/27/day-47--using-device-mapper-to-manage-firecracker-images/)
- [Docker without Docker - fly.io](https://fly.io/blog/docker-without-docker/)

### 2 - Management Daemon


### 3 - Communicator



## My Idea on FreeBSD
---

First create a networking solution (will build on this later):
- veth devices are used for the MicroVMs
- use local to local and eBPF XDP ingress where possible plus eBPF XDP egress technique found by Loophole Labs if possible and applicable
- an agent is placed on the Hypervisor host with access to and knowledge on all the veth devices
- an overlay mesh network with ACLs is made
- the overlay network uses PKI and JIT connection with no central control plane like Nebula
- all MicroVMs are taken into the overlay network without any sidecar agents using the host agent
- every MicroVM should be locally isolated from each by default and rely on paths through the overlay network

Tune VM creation  with bhyve to produce MicroVM outputs. Tune further to make this creation use materials provided by the user: network interfaces and file system device.

Create tooling for the three core functions to go on top of a MicroVM VMM:
1. Material Prep
2. Management Daemon
3. Communicator

This tooling on top / around is where we build on the networking solution by creating material for it (veth devices, etc.) and handling management through it (communication).

Every container image in the MicroVMs should be declarative and built on Wolfi. This way everything is reproducible and surface area plus size is very small with the MicroVM containing only: the kernel, the minimal OS without a kernel (Wolfi), the application APKs.

The main features of the existing eco-system I want to keep are
1. the ability to create containers in a shared network namespace (helpful debugging)
2. the ability to create a file system shared by different containers

Both of these should probably involves both containers getting packed into the same MicroVM because of how much they share already. Virtualization isolation provides kernel and file system isolation preserving the network as the one travel boundary. When that is revoked MicroVMs lose a lot of their usefulness.

The other idea here is packaging multiple MicroVMs into a container for clear shared material and also easy management (up and down) of these groups at once with the container engine (eg. Docker) helping.

Quick note, Why on FreeBSD: FreeBSD uses a different kernel and file system that is very alien to Linux native material. Any malware operating on the Linux MicroVM to break out and do damage in the host would also need to be able to understand and work with FreeBSD. Additionally security by default and design is a much higher priority in FreeBSD.

Scope creep to drool over:
- [How to run Firecracker without KVM on cloud VMs](https://blog.alexellis.io/how-to-run-firecracker-without-kvm-on-regular-cloud-vms/)

## Some more interesting reading.
---

### On Kata 
Kata Containers provides a very good example and a lot of great documentation on utilization of MicroVMs in practice beyond a learning experiment lab and especially how to use them with the existing eco-system of container tooling out there.

- [Design Document virtualization.md - Kata Containers](https://github.com/kata-containers/kata-containers/blob/main/docs/design/virtualization.md)
- [Configure Kata Containers to use Firecracker](https://github.com/kata-containers/kata-containers/blob/main/docs/how-to/how-to-use-kata-containers-with-firecracker.md)
- [What WON'T work limitations.md - Kata Containers](https://github.com/kata-containers/kata-containers/blob/main/docs/Limitations.md)
- [How to Use Kata Containers with Docker for Enhanced Isolation](https://oneuptime.com/blog/post/2026-02-08-how-to-use-kata-containers-with-docker-for-enhanced-isolation/view)

