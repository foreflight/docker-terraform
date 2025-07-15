ARG alpine_version=3.22

# We install each tool (e.g., Terraform, Terragrunt, and the AWS CLI) in a
# separate build stage. This design allows us to install each tool in parallel
# while preventing a change to one layer from blowing away the cache of
# subsequent layers.
# https://docs.docker.com/build/building/multi-stage/
FROM alpine:${alpine_version} AS terraform-builder

# These args support multi-platform builds if we decide to produce a linux/arm64
# variant.
# https://www.docker.com/blog/faster-multi-platform-builds-dockerfile-cross-compilation-guide/#93cb
ARG TERRAFORM_VERSION
ARG TARGETOS
ARG TARGETARCH

RUN set -ex \
    && apk add curl unzip \
    && curl "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${TARGETOS}_${TARGETARCH}.zip" -o "terraform.zip" \
    && unzip terraform.zip \
    && mv terraform /usr/local/bin/

FROM alpine:${alpine_version} AS terragrunt-builder

ARG TERRAGRUNT_VERSION
ARG TARGETOS
ARG TARGETARCH

RUN set -ex \
    && apk add curl \
    && curl -L "https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_${TARGETOS}_${TARGETARCH}" -o "terragrunt" \
    && chmod +x terragrunt \
    && mv terragrunt /usr/local/bin/

FROM alpine:${alpine_version} AS tflint-builder

ARG TFLINT_VERSION
ARG TARGETOS
ARG TARGETARCH

RUN set -ex \
    && apk add curl unzip \
    && curl -L "https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_${TARGETOS}_${TARGETARCH}.zip" -o "tflint.zip" \
    && unzip tflint.zip\
    && mv tflint /usr/local/bin/

FROM alpine:${alpine_version}

ARG AWSCLI_VERSION
ENV TF_PLUGIN_CACHE_DIR=/tmp/terraform

RUN set -ex \
    && deps=" \
        ca-certificates \
        less \
        git \
        openssh-client \
        bash \
        aws-cli \
        jq \
    " \
    && apk add $deps \
    && rm -rf /var/cache/apk/* \
    && mkdir -p $TF_PLUGIN_CACHE_DIR

# Install Terraform.
COPY --from=terraform-builder /usr/local/bin/terraform /usr/local/bin/terraform
# Install Terragrunt.
COPY --from=terragrunt-builder /usr/local/bin/terragrunt /usr/local/bin/terragrunt
#Install TFLint
COPY --from=tflint-builder /usr/local/bin/tflint /usr/local/bin/tflint

ENTRYPOINT ["/usr/local/bin/terraform"]
