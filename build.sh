#!/usr/bin/env sh
set -e

REGION="ap-south-1"
ECR_URL="240481310194.dkr.ecr.ap-south-1.amazonaws.com/testing-cicd"
BUILD_NUMBER="${BUILD_NUMBER:-$(date +%s)}"
MODULE_PATH="./go.mod"

echo "Building $BUILD_NUMBER" 

# log docker into eks using aws cli
$(aws ecr get-login --no-include-email --region $REGION)
# build a docker image with a unique build number
docker build -t $ECR_URL:$BUILD_NUMBER \
  --build-arg MODULE_PATH="$MODULE_PATH" \
  --build-arg VERSION="$BUILD_NUMBER" \
  .

# push to ecr
docker push $ECR_URL:$BUILD_NUMBER

#tag for "latest" and also push that
docker tag $ECR_URL:$BUILD_NUMBER $ECR_URL:latest
docker push $ECR_URL:latest
