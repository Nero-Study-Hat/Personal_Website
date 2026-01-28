FIXME: remove usage of I from this doc

# My Approach to Organizing Here

## Why Separate Bootstrap and Utility to their own directories.

Bootstrap modules are utlized for immidiate set up on project initialization and should not be needed again post that. As setup requirements evolve these modules will change.

This directory separates the bootstrap work required by Terraform that involves some initial click-ops.

While a utility modules may be needed for setup, what separates it from a bootstrap module is that it is also needed for updates beyond the initial project setup.

This directory separates Terraform managed resources that are not directly part of the resources managed per specific environment.

Both of them
- Manage resources separate from the deployment infrastructure itself.
- Provide useful functions with utilization timing independant of the environments` utlization times such as deployments from a particular major environment or progression environment.

---
## Why my approach to environment organization.

In this project the `envs` directory is split into multiple sub-directories because actual code significantly differs across major environments, each being a directory.

I am naming these significantly different environments that get their own directories `major environments` because they represent completely seprate deployments, timing, and logic with each respectively having their own minor progession environments for dev and production.

### Purpose of each major environment.

Environments and modules tree:

```
terrraform/
  envs/
    aws-low-cost/
    aws-professional/
    oracle-free/
    oracle-professional/
    proxmox/
  modules/
    common/
    aws/
    oracle/
    proxmox/
```

My approach for the off premise Cloud providers is to the split them into separate environments for "low-cost" and "professional".

The purpose of this split is make continous experimentation and learning an option without fear of cost in the "professional" environments where their resources don't stay up for long. Meanwhile the "low-cost" environments provide a place to comfortably host public facing content long term. 

#### More Detailed Breakdown

- aws-low-cost
  - This environment provides a cost learning environment with AWS and fail over option for my public facing contents' infrastructure.
- aws-professional
  - This provides a labbing ground with AWS to learn, experiment, and demonstrate acquired skills.
- oracle-free
  - This allows long term full time deployment of the content I have that I wish to be public facing with the monetary resources at my disposal.
- oracle-professional
  - This environment will provide more rich capability when I want that at a lower cost than the aws-professional environment.
- Proxmox:
  - This provides a fully private testing ground on x86 (Oracle will be on ARM) which makes this a good environment for quick small experiment ideas.

Note that each of these environments should
- Always be easy to deploy to either major environment at the manual trigger of a Github Actions workflow.
- Aways be easy to change to the chosen main major environment used for hosting my public facing content with my main domain in my Github Actions CI/CD setup.


### Where modules come in.

There is a specific modules directory so code re-use is clear, especially for common modules shared across major environments.

#TODO: continue this docs section

---
### Why just dev and production per major env.

I only plan to use dev and production environments for progression without a separate staging environment because of the very small nature of my project. It is still important to make sure that likely breaking changes that occur during development aren't public facing so I need the dev environment. I just don't need the staging environment because I am the only developer currently and the size of my infra as whole is quite small so it can easily be managed up and down in ephemeral dev environments which match the TBD (Trunk Based Development) branching strategy my project will be using.

#### Hypothetical: How to handle the project scale going significantly up.

Let's consider the case where I am working with multiple other people on the project and the infra scale becomes such that multiple fully mirrored production environments for development is unfeasable due to cost and complexity concerns.

I realize this unrealistic for a Homelab but it feels like a good exercise and practice to prepare just a little with some simple thought.

#TODO: continue this docs section


---
## How making changes will work.

Each major environment directory will be its own separated work environment for the reasons provided above. They each will have multiple `tf.vars` files and state files for different progression environments, dev and production.

I am using a `tf.vars` approach instead of Terraform Workspaces or separate directories per progression environment because
- Terraform workspaces adds overhead I need to worry about regarding which workspace I am in which with my git branch and module setup should not need to be an additional concern.
- Separate directories introduce needlessly complicated syncing challenges and the the full separation off development from production should be handled sufficiently with my git branching approach. 

My git branching approach will be Trunk Based Development. This means short lived update branches fork out from the main branch for a few days and then merge right back into main.

The workflow will go like so:

- Choose which major environment is being worked on. Each major environment has its own directory and significant differences. Currently they are separated by deployments to different providers including AWS, Oracle, and Proxmox.
- Change the backend state file in use to the development environment for that major environment. Feature branch should always be dev environment.
- Make changes to the Terraform code.
- Make sure the `tf.vars` stay synced properly between dev and production environments here. There should be test and variable usage approach to assure this.
- Test using the code and if everything works right fire off a PR to main.
- Go through the PR process (which I have not fully worked out yet) and once everything has been checked off merge into main.
- Once merged into main the dev environment should automatically go down if not was not already and the production environment should automatically deploy.

