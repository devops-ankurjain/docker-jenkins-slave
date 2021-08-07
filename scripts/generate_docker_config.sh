#!/usr/bin/env bash

## Skaffold needs ~/.docker/config.json
# - https://github.com/GoogleContainerTools/skaffold/issues/1719

AWS_REGION=ap-southeast-2
TOOLS_ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
AUTH=$(echo AWS:$(aws ecr get-login-password --region ${AWS_REGION}) | openssl base64 -A)
mkdir ~/.docker
cat << EOF > ~/.docker/config.json
{
 "auths": {
        "${TOOLS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com": {
                "auth": "${AUTH}"
        }
 }
}
EOF
