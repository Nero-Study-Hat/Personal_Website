---
title: Chainguard Assemble 2026 Reflection
tags:
  - early-concepts
  - reflection
---

# Chainguard Assemble 2026 Reflection

There are a few angles I want to come at this from.

1. All the technical bits and bobs I learned. (having access to so many brilliant super well informed and nice people is amazing)
2. My experience networking.
3. This being my first tech conference and me going as a student.

# The Technical Side

A significant part of why I came to assemble was me hearing about a bunch of what Chainguard was doing with things like DriftlessAF coming out and wondering how the heck these solutions worked. The other half of this was me really liking the Chainguard mission and what it looked like they were doing but not really understanding the conversation around their potential shortcomings and pain points.

As those pain points go, I don't necessarily mean points that actually existed like a missing feature but also refer to things people online make a fuss about which kind of made sense but I wasn't sure about one way or the other.

## Confusion Points

My main confusion points here on Chainguard specifically going into the conference were probably
- Self reporting
	- Why is Chainguard self publishing STIGs?
- Proprietary OS code
	- ChainguardOS involves proprietary source code. Isn't open source generally more vetted and secure and what even are the lines in the sand of open and closed source here? Also, why the lines where they are?
- Lock-in and on-boarding
	- Chainguard has a partially proprietary OS and a bunch of custom special tooling, what goes on with the potential lock in problem and also on boarding for that matter?
- Dependency conflicts and constant graph level updates from all over
	- A Chainguard goal is getting everything to latest (a specific pinned digest, not quite classical latest) and their factory is rebuilding everything a package feeds into when there is a new release so how is dependency conflict managed when the software world is so messily connected often enough and various bits don't play nice?
- Making the unstructured and agentic work
	- Chainguard factory 2.0 is all about agentic reconciliation as opposed to being event driven and as a part of that, a big functionality point is being able to process unstructured data better as well as correct new breakages purely via automation. How???
- Patching CVEs
	- Chainguard images support version streams with older versions which may not have all the security patches they need but the factory automatically finds the right patch to bring in. How?
- More secure claims
	- Chainguard's products and infrastructure are supposedly more secure but how are the these more secure products built and how can a customer confidently attest every claim?
- Human gates
	- Chainguard now has an agentic framework (they taught me that's the AF in DriftlessAF of course) but they are a security focused company where quality is key so what enables them to handle the volume that passes through their system?

For some of these I asked the direct question, others I heard about the answer indirectly, and some I simply got enough info that I can hazard guesses.

