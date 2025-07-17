# docker-terraform 

[![Build and Publish ForeFlight Terraform Image](https://github.com/foreflight/docker-terraform/actions/workflows/continuous_integration.yml/badge.svg)](https://github.com/foreflight/docker-terraform/actions/workflows/continuous_integration.yml)

This repository contains a `Dockerfile` for image variants designed to run deployments using Terraform and the AWS CLI.

- [Usage](#usage)
- [Build Arguments](#build-arguments)
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
$ docker compose run --rm terraform
fa5dce73516d:/workspace# terraform --version
Terraform v1.12.2
on linux_arm64
```

### Build Arguments

- `ALPINE_VERSION` - [Alpine Linux base image version](https://hub.docker.com/_/alpine/tags).
- `TERRAFORM_VERSION` - [Terraform version](https://github.com/hashicorp/terraform/releases).
- `TFLINT_VERSION` - [TFLint version](https://github.com/terraform-linters/tflint/releases).

### Testing

An example of how to use `cibuild` to build and test an image:

```console
$ CI=1 ALPINE_VERSION=3.22 TERRAFORM_VERSION=1.12.2 TFLINT_VERSION=v0.58.1 ./scripts/cibuild
```
