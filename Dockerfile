FROM python:3.9.6-slim-buster

## Pin AWS Region and Versions
ENV AWS_DEFAULT_REGION=ap-southeast-2 \
    AWS_CLI_VERSION=2.2.22 \
    PACKER_VERSION=1.7.4 \
    SKAFFOLD_VERSION=1.29.0 \
    SKAFFOLD_UPDATE_CHECK=false \
    TERRAFORM_VERSION=1.0.4

## Refresh Apt Keys
RUN apt-get update && \
    apt-get -y install gnupg --no-install-recommends && \
    apt-key adv --refresh-keys

## Install Basic Packages
RUN apt-get -y install --no-install-recommends \
    less vim make telnet wget curl jq unzip dnsutils openssh-client colordiff gettext \
    ca-certificates git gnupg bsdtar

## AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" -o "awscliv2.zip" && \
    unzip -q awscliv2.zip && \
    rm -fv awscliv2.zip && \
    ./aws/install && \
    /usr/local/bin/aws --version

## Install Python Packages
RUN python -m pip install --upgrade pip==21.2.1
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

## Misc Tools
RUN curl -L -o /tmp/skaffold "https://github.com/GoogleContainerTools/skaffold/releases/download/v${SKAFFOLD_VERSION}/skaffold-linux-amd64" && \
    install /tmp/skaffold /usr/local/bin/ && \
    skaffold config set --global collect-metrics false && \
    curl "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" | bsdtar -xvf- -C /usr/local/bin/ && \
    curl "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" | bsdtar -xvf- -C /usr/local/bin/ && \
    chmod 0755 /usr/local/bin/*

## Misc Scripts
COPY scripts /scripts

## Cleanup
RUN apt-get clean && \
    rm -rf /tmp/* /var/lib/apt/lists/*
