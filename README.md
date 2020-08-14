# terragrunt-balanced

> WIP - Too early to use

This is a reference architecture for deploying infrastructure components for the [Balanced Network](https://balanced.network/) stable coin.

## Deploying the Stack

The process involves three steps.

1. Setting up accounts, projects, and API keys
1. Run the CLI to configure the necessary files and ssh keys
1. Create a deployment file **(contact maintainers)**
1. Run the deployment with CLI

### Deployment Setup and CLI

To get started with an interactive CLI to configure node deployments:

```bash
git clone https://github.com/insight-w3f/terragrunt-balanced
cd terragrunt-balanced
pip3 install nukikata  # A tool we designed to do interactive code templating
nukikata .
```

By walking through the steps in the CLI, users should be able to fully customize the deployment of the cluster in any
 cloud provider. There are three key steps, installing prerequisites, configuring ssh keys, and setting up the stack
 .  Each step can be done in the CLI.

##### Prerequisites

To run all the different tools, you will need the following tools.

1. Terraform
1. Terragrunt
1. Ansible (Not supported on windows without WSL)
1. Packer
1. kubectl
1. helm
1. aws-iam-authenticator
1. awscli - AWS only

##### SSH Keys

To setup ssh keys, in order to maintain a simpler governance around these sensitive items, we have a notion of a ssh
-key profile in the deployment process where you generate new or link to existing keys and then write them to file
. The CLI walks you through the process but all it is doing is entering in the profile in a document called `secrets
.yml` which is ignored in version control. The document will end up looking something like this:

```yaml
ssh_profiles:
- name: balanced-dev
  private_key_path: ~/.ssh/balanced-dev
  public_key_path: ~/.ssh/balanced-dev.pub
- name: balanced-prod
  private_key_path: ~/.ssh/balanced-prod
  public_key_path: ~/.ssh/balanced-prod.pub
```

### Run File, Deployment ID, and Remote State

We order the deployment file names and remote state path per the following convetion.

| Num | Name | Description | Example |
|:---|:---|:-----|:---|
| 1 | Namespace | The namespace, ie the chain | icon-balanced  |
| 2 | Network Name | The name of the network  | pagoda  |
| 3 | Environment | The environment of deployment | prod |
| 4 | Provider | The cloud provider  | aws |
| 5 | Region | Region to deploy into | us-east-1 |
| 6 | Stack | The type of stack to deploy  | validator|
| 7 | Deployment ID | Identifier for rolling / canary deployments | 1 |

We then will rely on this hierarchy in the remote state and deployment file.

**Run File:**

`run.yaml` An inherited file closest to the stack being deployed.
```yaml
namespace: "icon"
network_name: "balanced"
environment: "dev"
provider: "aws"
region: "us-east-1"
stack: "validator-simple"
deployment_id: 1  # Something to discriminate between deployments - ie blue/green
```

**Deployment File:**

`terragrunt-icon/deployments/icon.mainnet.prod.aws.us-east-1.validator.1.yaml`

Deployment files are created locally by the nukikata CLI in the `deployments` directory and are referenced in each
 deployment run via the `run.yaml` which references the deployment file.


**Remote State:**

`s3://.../<bucket>/icon/mainnet/prod/aws/us-east-1/validator/1/terraform.tfstate`

The remote state bucket and path are created and managed for you by terragrunt. This is where the state of all the
 deployments is kept and can be referenced in subsequent deployments.


### Build Status
- network - [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-balanced-aws-network.svg?style=svg)](https://circleci.com/gh/insight-icon/terraform-balanced-aws-network)

### General
- [terraform-ansible-playbook](https://github.com/insight-infrastructure/terraform-aws-ansible-playbook) ![](https://img.shields.io/github/v/release/insight-infrastructure/terraform-aws-ansible-playbook?style=svg)
- [terraform-packer-build](https://github.com/insight-infrastructure/terraform-packer-build) ![](https://img.shields.io/github/v/release/insight-infrastructure/terraform-packer-build?style=svg)

![](./static/w3f_badge.png)
