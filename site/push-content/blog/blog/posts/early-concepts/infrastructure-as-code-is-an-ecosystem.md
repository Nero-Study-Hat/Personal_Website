---
title: Infrastructure as Code is an Ecosystem
tags:
  - early-concepts
  - takes
---
## Intro

Before I get into the outline for this writeup let's set level ground first.

> [!note] QUOTE: freeCodeCamp
> Infrastructure as Code (IaC) is a way of managing your infrastructure like it was code. This gives you all the benefits of using code to create your infrastructure, like version control, faster and safer infrastructure deployments across different environments, and having up to date documentation of your infrastructure.
> > https://www.freecodecamp.org/news/infrastructure-as-code-basics/

The case I want to make with this article is that IaC also is an ecosystem.

Many technologies and automated practices that can only exist once IaC does and group with it to form a vibrant space. This can be seen in a similar way to how a general purpose programming language is that language itself coupled with all the tooling and such that exists around it.

To give a little background, I got into IaC with Terraform, Ansible, Cloud Init. The reasoning was I had used Linux for sometime already and was used to Bash.

I seriously did not want to use Bash and I very seriously did not want to click buttons in a UI.

So I used that tool trio and life was good until I needed to expand out. I wanted the cloud and CI/CD. I thought that expansion would be easy because I had already defined my server requirements in code and my OS config requirements in code.

What I didn't anticipate was that I had only been learning the language and not the ecosystem. This meant I got very stuck and the time estimates I made for my project were *significantly* off.

The purpose of this article is introduce that ecosystem in a gentle way so that a past me can read this and have an understanding of what is out there.

It's not about saying starting with the language alone is wrong, if anything that is best. It's about being aware because I think moving through life aware is best.


> [!note] Writeup Outline
> 

stuff to talk about
- getting a handle on the language first
- immutable production and state
	- where this comes in
- gitops
	- where gitops comes in
	- CI/CD
	- Git Development Flow Types
	- SDLC
- identity
	- where identity comes in
	- Auth protocols purpose.
	- Workload federation.
- supply chain
	- where supply chain comes in
	- infra chain
	- app chain
	- dev tooling chain
- cool possibilities to imagine
	- sub second auto-scaling 0 -> 1 and 1-> 0


---
## Immutable Production & State

To some extent we are still mainly dealing with the base language here but the way we think about it changes and that change has a large impact.


