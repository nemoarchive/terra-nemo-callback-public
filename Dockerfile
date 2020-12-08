FROM ubuntu:20.04

LABEL version="1"
LABEL maintainer="<author@email.com>"

# Install curl and Google Cloud SDK
# Instructions here -> https://cloud.google.com/sdk/docs/downloads-apt-get
RUN apt-get -qq update && apt-get -qq install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    gnupg \
    curl \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
    | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
    && apt-get -qq update && apt-get -qq install -y --no-install-recommends google-cloud-sdk \
    # Config options taken from https://hub.docker.com/r/google/cloud-sdk/dockerfile
    && gcloud config set core/disable_usage_reporting true \
    && gcloud config set component_manager/disable_update_check true \
    && gcloud config set metrics/environment github_docker_image \
    && gcloud --version
    #&& gcloud init --skip-diagnostics

COPY docker-entrypoint.sh /opt/docker-entrypoint.sh

# CMD ["/bin/bash"] # from Ubuntu base image