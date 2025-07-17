# docker-terraform 

[![Build and Publish ForeFlight Terraform Image](https://github.com/foreflight/docker-terraform/actions/workflows/continuous_integration.yml/badge.svg)](https://github.com/foreflight/docker-terraform/actions/workflows/continuous_integration.yml)

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
      - ~/.terraform.d/plugin-cache:/root/.terraform.d/plugin-cache
    environment:
      - AWS_REGION
      - AWS_PROFILE
      - TF_PLUGIN_CACHE_DIR=/root/.terraform.d/plugin-cache
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

### Testing

An example of how to use `cibuild` to build and test an image:

```console
$ CI=1 ALPINE_VERSION=3.22 TERRAFORM_VERSION=1.12.2 TFLINT_VERSION=v0.58.1 ./scripts/cibuild
```
