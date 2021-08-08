#!/usr/bin/env bash

TARGET_AWS_ACCOUNT=${1}
TARGET_IAM_ROLE=${2}

ROLE=$(aws sts assume-role --role-arn arn:aws:iam::${TARGET_AWS_ACCOUNT}:role/${TARGET_IAM_ROLE} --role-session-name jenkins-slave)
export AWS_ACCESS_KEY_ID=$(echo "$ROLE" | jq -r .Credentials.AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(echo "$ROLE" | jq -r .Credentials.SecretAccessKey)
export AWS_SESSION_TOKEN=$(echo "$ROLE" | jq -r .Credentials.SessionToken)

make plan
make apply
