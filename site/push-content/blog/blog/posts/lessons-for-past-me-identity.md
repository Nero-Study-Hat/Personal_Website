---
title: "Lessons for Past Me: Identity"
date: 2/14/2026
---
> [!important]  Writeup Outline
> Sync up what the article is talking about and thinking of regarding identity and what you think the article is talking about.
> 
> Move to Identity Access Management solutions like AWS IAM and Tailscale's ACLs to see get a feel for a lot of the problems in the identity space and answers the industry has arrived at.
> 
> Go under the hood to understand where identity is coming with IdP, authentication protocols, and federation.
> 
> Dig into the root of trust with where identity and related material is retrieved from at the bottom turtle and where it is stored.
> 
> Zoom back out to see where how all the pieces of the identity puzzle covered can come together for more secure and useful infrastructure.

## Getting Us Synced Up

This article is bundling authentication, authorization, and all the mechanisms behind those two functions into **identity**.

At it's most fundamental authentication and authorization come down to this:
Infrastructure needs to vet **who** is allowed to act and **what** actions are allowed.

> If you want to learn more there is a good article from Okta.
> 
> https://www.okta.com/identity-101/authentication-vs-authorization/

The mechanisms will be uncovered as the article progresses.

## Identity Access Management Solutions

### AWS IAM

AWS IAM and similar cloud provider IAM solutions are a great reference point for what features and concepts exist in the space with the relevant knobs to twist and buttons to push without requiring us to get deep in the mechanisms yet.

To get a handle on these in a practical way let's look at the problems AWS IAM solves.

They include
- Workers need to be able to contribute to a project.
- Threats exist outside and inside of a project.
- Authentication and authorization are both temporary.
	- Individual workers on a project are temporary.
	- Worker permissions are temporary, never permanent.
- A paper trail is needed.
- Events happen that require response Yesterday.

#### Workers need to be able to contribute to a project.

It may sound obvious but this is one of the hardest parts of securing a project. The most secure project is one that doesn't exist and can't be touched.

All the same progress much march on so
- Workers, people and non-human automation entities, should be able contribute.
- Various tools should be usable by the project's workers.

This way we can still browse cat videos in fresh and interesting ways as contributions continue and project contributors can use tools that prevent their hair from graying at an accelerated pace.

#### Threats exist outside and inside of a project.

This is why the no touch project is so much more secure. In an ideal world we can trust everyone but in the real one we can 't.

> Industry answer to problems in the Identity space #1: **Least-Privilege**

> [!note] QUOTE: NIST
> A security principle that a system should restrict the access privileges of users (or processes acting on behalf of users) to the minimum necessary to accomplish assigned tasks.

This way only the workers that need to be trusted are (who can do stuff) and they only get as much trust as they need (what can be done). Now the amount of damage workers can should be heavily restricted.

> If you want to read more on this principle Cloudflare has a nice article
> 
> https://www.cloudflare.com/learning/access-management/principle-of-least-privilege/

#### Individual workers on a project are temporary.

Even if we perfectly got our authentication and authorization right last Tuesday, Jim from the Infrastructure team just left and he seemed unhappy. Trust should never be seen as a static entity. If we want real least privilege that means all privileges present needs to be constantly re-evaluated to make sure they really are least privilege. Jim shouldn't have access anymore, tsk.

A nice way to view least privilege with this temporary vision of trust in mind is:
> The absolute minimum trust required per point in time.

The way AWS IAM makes approaching this problem easier is "organizational units". Think of them as slots workers can be slotted into and pulled out. Permissions for workers should always come from an organizational unit they inherit from and never be attached to the workers directly.

If Jim was part of an organization unit, than taking him out of the project and bringing a new worker in to replace him with the same permissions he had becomes easy. Easy is good here because people are more likely to do easy things and maintaining least privilege is desirable behavior.
##### Organizations of One

Now let's talk personal projects. Your worker count of the singular you is still an organization and you can still benefit from using organizational units.

Think about the different actions you are taking. There are multiple contexts in which you interact with AWS. A developer pushing an app change, a platform engineer making an update to your EC2 instance, a security engineer making an IAM update perhaps.

Your worker count may be singular but the roles  your project has are not. If you want to easily bring help in than splitting into organizational units helps.

Also remember that trust is an always updating entity. Even if its just you, do you always need permissions for all those different contexts at all those points in time. Probably not.

#### Worker permissions are temporary, never permanent.

Consider where identity comes from.

For AWS this is going to be some sort of credentials or an access key for long term access.

Now the tricky problem, we *want long term identities*, after all we expect Jim's replacement Derrick to be employed for a long time and we should be able to see in the audit logs (we'll get more into those later) what he is responsible for doing so we need him to have a long term proof of identity in the project. Yet we *don't want long term active permissions*.

Let's break this down. The project needs to
1. Separate long term identities from the active permissions they need.
2. Make assuming the permissions they need easy without keeping them always active.

This is where we get to the next industry answer.

> Industry answer to problems in the Identity space #2: **Ephemerality**

> [!note] QUOTE: Chainguard
> Ephemerality is the property of lasting for a very short time. As it applies to production software, this is a far-reaching principle with critical applications including: credentials, keys, signatures, attestations, and even the infrastructure itself!

> To learn a lot about ephemerality check out this article.
> 
> https://www.chainguard.dev/unchained/the-principle-of-ephemerality

Consider where identity comes from and where permissions come from. Identity comes from some kind of proof(s) and permissions come with identity.

AWS IAM takes advantage of this by enabling the creation of short term only identities which can be assumed by other identities so long as they have the permission to do so. Use the organizational units previously mentioned to have workers inherit the permission to do so.

This works under the hood by limiting the amount of long lived proofs of identity made and creating short lived proofs of identity (tokens) that are valid for limited amounts of time and need to be requested.

Here's an example following the story of a fellow named Bob working on a personal project.

Bob needs to change some VPC settings. He can't at the moment because there are no proofs of identity on his machine for the `awscli2` package to pull from, short or long lived.

So he runs the command `aws login` which opens the AWS Console login page in his favorite browser. Here he logs in with long lived proof of identity which involves a password manager for a very strong password and Multi-Factor Authentication (MFA) to be as secure as can be (and take advantage of that browser support).

When the login succeeds a token is generated on his machine. It is a short lived proof of identity for the `awscli2` package to pull from. Now he runs his `terraform plan`  and `terraform apply` successfully. Then goes back to debugging JavaScript. While he is off doing that, in 15 minutes the token expires and now if some shady actor got access to his machine at this point they would be too late because there are no valid proofs of identity to use there.

Now on top of a worker being easily movable in and out of a project, even a worker that is in the project only has permissions as long as they *need* them which they retrieve by asking. They don't just have those permissions permanently anymore and active proofs of identity with permission can't spread.

Dead tokens can spread while getting real permission requires attempting to authenticate.

#### Bonus: Meeting irregular access needs.

Think about how Bill from accounting needs to see some of the billing details in AWS a few times a year. He doesn't need long term access so he doesn't need a long term proof of identity but he does need access. This situation is where a member of the infrastructure team can spawn a short term identity meant to be used by accounting and pass the short lived token for that over to Bill through a secure channel.

#### A paper trail is needed.

Know how email is the decides where blame goes with who was responsible for what in a way that can't be contested because receipts exist that can't altered. Receipts that include the who what and when involved.

Infrastructure needs receipts like that as well bringing us to the next industry answer.

> Industry answer to problems in the Identity space #3: **Audit, Logging, Non-Repudiation**

> [!note] QUOTE: ASHER SECURITY
> - **Logging** captures events, who did what, when, where, how.
> - **Audit trails** stitch those logged events into meaningful sequences that tell a story: not just “login at 10:02am,” but “User X accessed file Y, modified it, then exported it.”

> To learn more go to:
> - https://www.ashersecurity.com/what-is-audit-logging-the-foundation-of-cyber-visibility/
> - https://www.graphapp.ai/blog/understanding-the-importance-of-audit-logs-in-cybersecurity

> [!note] QUOTE: PORTNOX
> Non-repudiation in cybersecurity is a security principle that ensures no one can deny their actions or involvement in a digital transaction, communication, or data exchange.
> - **Proof of Origin**: Confirms the identity of the sender. The sender cannot later deny sending a specific message or performing a specific action.
> - **Proof of Delivery/Receipt**:Confirms that the intended recipient received the information. The recipient cannot claim they never got it.
> - **Integrity Protection**: Ensures that the message or transaction has not been altered during transmission. If tampering occurs, it can be detected.

> To learn more go to:
> - https://www.portnox.com/cybersecurity-101/general-security/what-is-non-repudiation-in-cybersecurity/

Put all three of these together and we have a complete immutable picture of what is going in our project at all times.

Now let's look consider the importance this has in the context of our discussion of identity.

Remember how workers need to prove they are who they claim. Project owners need to prove their project has the security controls they claim it does. In order for that trust to come just turning the knobs isn't enough. Whenever you are doing something right you still need to be able to **prove** you are doing it right.

Day to day all this visibility seriously helps maintain and strengthen security posture. It's similar to how you can clean a room more effectively with good light because you know where the grime is. Same here.

Moving to when something goes wrong, when not if, whether malicious or otherwise this all becomes critical. Incident response and review are both critical cybersecurity and regular operations. Always remember that mistakes happen and chaos thrives given enough time. Look at how Cloudflare beat off the largest DDoS to date and then took themselves down.

The teams assigned to incident response and review (which may include you) will seriously appreciate everything you have collected because it gives them the guaranteed visibility they need to investigate and act.

#### Events happen that require response yesterday.

Keeping with incident response, it needs to be fast and we are talking as fast as it can possibly be done.

The longer an incident goes on, often the more damage incurred. There also is the trust component because customers will notice if this takes a long time.

> [!note] QUOTE: When the governments' backdoor was still compromised months after discovery.
> On the call Tuesday, officials from CISA and the FBI urged Americans to use encrypted messaging apps to avoid having their communications intercepted by Chinese spies or other hacking groups.
> 
> > https://techcrunch.com/2024/12/04/fbi-recommends-encrypted-messaging-apps-combat-chinese-hackers/

With the consequences in mind, automated response becomes critical.

The engine that powers this automated response is the paper trail previously mentioned with planned responses to specific event signals. This way the playbooks you already have written out can trigger within milliseconds.


---
### Tailscale ACLs

> [!tip] Seeing IAM in the context of the network rather than a Cloud account.





## Going Under the Hood


### IdP


### Auth Protocols: SAML, OIDC, JWT


### Federation



## Digging Deeper to the Sources of Trust

> [!tip] The bottom turtle and root of trust.


### Spiffe / Spire



### PKI

smallsetp-ca

## Fitting All The Puzzle Pieces Together

