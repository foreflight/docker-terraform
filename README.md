# docker-terraform [![CI](https://github.com/foreflight/docker-terraform/workflows/CI/badge.svg?branch=master)](https://github.com/foreflight/docker-terraform/actions?query=workflow%3ACI)

This repository contains a templated `Dockerfile` for image variants designed to run deployments using Terraform, Terragrunt, and the AWS CLI.

- [Usage](#usage)
  - [Authentication with AWS Vault](#authentication-with-aws-vault)
- [Template Variables](#template-variables)
- [Testing](#testing)

## Usage

Via Docker Compose, which includes volumes for basic functionality:

```yml
services:
  terraform:
    image: ghcr.io/foreflight/terraform:1.3.4
    volumes:
      - ./:/usr/local/src
      - $HOME/.aws:/root/.aws:ro
    environment:
      - AWS_PROFILE
    working_dir: /usr/local/src
    entrypoint: bash
```

```console
$ docker-compose run --rm terraform
root@43896c479d95:/usr/local/src# terraform --version
Terraform v1.3.4
on linux_arm64
```

### Authentication with AWS Vault

At ForeFlight, we use [AWS Vault](https://github.com/99designs/aws-vault) to log into our numerous AWS accounts via the [`AssumeRole`](https://docs.aws.amazon.com/STS/latest/APIReference/API_AssumeRole.html) API.

By default, the AWS CLI looks for credentials [in multiple places](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-precedence), starting with credentials passed as CLI parameters and ending with credentials exposed by the instance metadata server. 
AWS Vault has a [local implementation](https://github.com/99designs/aws-vault/blob/master/server/ec2server.go) of the [EC2 instance metadata server](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html). So, we can use AWS Vault's local instance metadata server to supply credentials to the AWS CLI without needing to mount or pass anything to the container image:

```console
$ aws-vault exec --server my-aws-profile
$ docker-compose run --rm terraform
root@59531b150efd:/usr/local/src# aws sts get-caller-identity
{
    "UserId": "AIDASAMPLEUSERID",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/DevAdmin"
}
```

### Template Variables

- `TERRAFORM_VERSION` - [Terraform version](https://github.com/hashicorp/terraform/releases).
- `TERRAGRUNT_VERSION` - [Terragrunt version](https://github.com/gruntwork-io/terragrunt/releases).
- `AWSCLI_VERSION` - [AWS CLI version 2 version](https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst?plain=1).

### Testing

An example of how to use `cibuild` to build and test an image:

```console
$ CI=1 TERRAFORM_VERSION=1.3.4 TERRAGRUNT_VERSION=v0.39.2 AWSCLI_VERSION=2.8.8 ./scripts/cibuild
```
