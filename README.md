# docker-terraform [![CI](https://github.com/foreflight/docker-terraform/workflows/CI/badge.svg?branch=master)](https://github.com/foreflight/docker-terraform/actions?query=workflow%3ACI)

This repository contains a templated `Dockerfile` for image variants designed to run deployments using Terraform, Terragrunt, and the AWS CLI.

## Usage

Via Docker Compose, which includes volumes for basic functionality:

```yml
services:
  terraform:
    image: ghcr.io/foreflight/terraform:1.3.3
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
Terraform v1.3.3
on linux_arm64
```

### Template Variables

- `TERRAFORM_VERSION` - [Terraform version](https://github.com/hashicorp/terraform/releases).
- `TERRAGRUNT_VERSION` - [Terragrunt version](https://github.com/gruntwork-io/terragrunt/releases).
- `AWSCLI_VERSION` - [AWS CLI version 2 version](https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst?plain=1).

### Testing

An example of how to use `cibuild` to build and test an image:

```console
$ CI=1 TERRAFORM_VERSION=1.3.3 TERRAGRUNT_VERSION=v0.39.2 AWSCLI_VERSION=2.8.4 ./scripts/cibuild
```
