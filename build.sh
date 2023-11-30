#!/usr/bin/env sh
set -e

REGION="ap-south-1"
ECR_URL="240481310194.dkr.ecr.ap-south-1.amazonaws.com/testing-cicd"
BUILD_NUMBER="${BUILD_NUMBER:-$(date +%s)}"
MODULE_PATH="./go.mod"

echo "Building $BUILD_NUMBER" 

# Log in to Amazon ECR
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_URL

# Build a Docker image with a unique build number
docker build -t $ECR_URL:$BUILD_NUMBER \
  --build-arg MODULE_PATH="$MODULE_PATH" \
  --build-arg VERSION="$BUILD_NUMBER" \
  .

# Push to ECR
docker push $ECR_URL:$BUILD_NUMBER

# Tag for "latest" and also push that
docker tag $ECR_URL:$BUILD_NUMBER $ECR_URL:latest
docker push $ECR_URL:latest