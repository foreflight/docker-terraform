# docker-terraform [![CI](https://github.com/foreflight/docker-terraform/workflows/CI/badge.svg?branch=master)](https://github.com/foreflight/docker-terraform/actions?query=workflow%3ACI)

This repository contains a templated `Dockerfile` for image variants designed to run deployments using Terraform, Terragrunt, and the AWS CLI.

- [Usage](#usage)
- [Template Variables](#template-variables)
- [Testing](#testing)

## Usage

Via Docker Compose, which includes volumes for basic functionality:

```yml
services:
  terraform:
    image: ghcr.io/foreflight/terraform:1.12.2
    volumes:
      - .:/workspace
      - ~/.aws:/root/.aws:ro
      - ~/.terraform.d/plugin-cache:/tmp/terraform
    environment:
      - AWS_REGION
      - AWS_PROFILE
      - TF_LOG
    tty: true
    working_dir: /workspace
    entrypoint: bash
```

```console
$ docker-compose run --rm terraform
root@5e7b9d6614b0:/usr/local/src# terraform -version
Terraform v1.12.2
on linux_amd64
```

### Template Variables

- `TERRAFORM_VERSION` - [Terraform version](https://github.com/hashicorp/terraform/releases).
- `TERRAGRUNT_VERSION` - [Terragrunt version](https://github.com/gruntwork-io/terragrunt/releases).
- `AWSCLI_VERSION` - [AWS CLI version 2 version](https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst?plain=1).

### Testing

An example of how to use `cibuild` to build and test an image:

```console
$ CI=1 TERRAFORM_VERSION=1.12.2 TERRAGRUNT_VERSION=v0.83.2 TFLINT_VERSION=v0.58.1 ./scripts/cibuild
```
