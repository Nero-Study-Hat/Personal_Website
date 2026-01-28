---
title: Relearning how I use GitHub for personal projects.
---

### What led me to this change after using GitHub for a few years already?
For a long time the way I would approach GitHub for personal projects would be a main branch that I tried to always keep stable and an unstable branch (often named cutting-edge cause that sounds cool). Main would always fall far behind cutting-edge as I kept working on the project and getting stuff done that never quite felt like a complete *something* to merge into main. Having just two branches to worry about did make sense though because my projects were generally small enough that I would be making changes across the entire codebase for a single feature so having multiple branches going at once would just not work. Altogether, for the size my projects were generally at and the type of stuff I was working on, my previous workflow worked well enough. Not great, there were issues, but it was *good enough* for me which meant I could focus on development and learning for these projects.
The project that really acted as a splash of cold water for me regarding how I use GitHib was my `Homelab Mono Repo` which absolutely could not work with my previous workflow. This pushed me to start researching a new workflow.

Other reasons I felt the need to improve my workflow included
- Some of the projects I am taking on are larger.
- The amount of time a project can expected to be in development is far larger.
- There will guaranteed be times when I am away from a project, possibly for a long span of time.
- I have more clarity regarding some of the projects I'm taking on now regarding what I want to make. Beyond just wanting to learn and explore with them, there are plans for them.

### The new workflow I want to implement and why.

I am going to start taking advantage of issues and milestones. Based on past projects without, I could really use these to make sure I get the right stuff done faster. Also, I have a better idea of what I actually want to make with some of my projects now. This really lends itself to milestones and more clear long term goals broken down into various issues to handle. Having some project management will not only make active progress easier as I manage my focus better but also really help for coming back from long absences as well as explaining to other people what work there is to be done.

Creating a branch for each issue that is worked on with the name `issueType-issueName` (eg. `feat/3-setup-base-nix-flake`) so I can specifically commit to the branch for the issue and I am working on and view history for issue alone. I can also see from main commit history where an issue branch was merged in with a PR which will have much better naming than most commits I make. This way I get better project history.

Something important here is that as much as I may say and hear that I need to name my commits better, there is just no way I can count on myself to be perfectly responsible when I am actually in the weeds working on a project. A ridiculous percentage of all the commits I have made over my time as a developer have just been `Small Changes` or something sarcastic like `Another semi colon.` That one wasn't a good time. Anyway, I am not going to plan on me naming well always because there is just no way that happens. Issue specific branches and PRs are a great help with the this because they require that I group a bunch of stupidly named commits and so forth in something that has been pre-organized already so that I am not relying on myself while working to be perfectly responsible. 

I also get better workspace scalability from this approach to branches as it will be simple to create branches to focus on a specific problems that are easy to identify and reach based on my naming system and them being attached to issues which are mentioned in milestones. 

#### The Breakdown
Milestones
- Rules
	- naming is `v#` for now
	- Content may include a description, connected issues (with checkmark bullets), and bullets of what should not be done.
	- The finished state should be notable enough to present other people. Not just a little progress on improving something already there.
- Benefits
	- Make the work that needs to be done to reach a notable project state clear.
	- Improve history organization for the project.
	- Make it clear what work needs to be done, issue(s) of note, at any given moment.
	- Convey the current progress state of the project.
Issues
- Rules
	- Name of issue should make the work involved clear.
	- Act as single items of work to attack whether that be a feature bug fix, test work, or something else.
- Benefits
	- Make working on any issue simpler by clarifying what needs to be done.
	- Future work ideas can be noted down in another issue.
Branches
- Rules
	- created for specific issues
	- naming system `issueType-issueName` (eg. `feat/3-setup-base-nix-flake`)
- Benefits
	- Make concurrent work across different issues easier to deal with.


### Ending thoughts.

I have been trying this out in my [nixos-config](https://github.com/Daniel-Giszpenc/nixos-config) repo where I found that I really need to think about whether I want to rebase PRs I merge in and that milestones have due dates which could be cool to plan with. I also found it didn't feel right to open issues that I allude to in milestones that can't even be worked on yet but I think it does make sense to do so, just not to give them a branch yet. I also forgot about putting the issue type in the branch names so I need to get on that. I probably need to learn about version naming and those systems as well for inspiration. Otherwise, I have found that having a clear issues to work on, issue specific history, PR name in `main` branch history, and a milestone for making clear what is my focus as things stand has been great.
Before I try screwing around with any more stuff than what I mentioned here, I really want to try taking the time to just battle test this stuff.

PS. Boy did I laugh and feel dumb when I started looking up how to use GitHub and stuff like PRs after using these things for a few years.