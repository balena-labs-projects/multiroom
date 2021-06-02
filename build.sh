#!/bin/bash
set -e

BLOCK_NAME="multiroom"
DOCKER_REPO=${1:-balenablocks}

function build_and_push_image () {
  local BALENA_ARCH=$1
  local PLATFORM=$2

  TAG=$DOCKER_REPO/$BLOCK_NAME:$BALENA_ARCH

  echo "Building for $BALENA_ARCH, platform $PLATFORM, pushing to $TAG"
  
  docker buildx build . --pull \
      --build-arg BALENA_ARCH=$BALENA_ARCH \
      --platform $PLATFORM \
      --file Dockerfile.template \
      --tag $TAG --load

  echo "Publishing..."
  docker push $TAG
}

function create_and_push_manifest() {
  docker manifest create $DOCKER_REPO/$BLOCK_NAME:latest \
    --amend $DOCKER_REPO/$BLOCK_NAME:rpi \
    --amend $DOCKER_REPO/$BLOCK_NAME:armv7hf \
    --amend $DOCKER_REPO/$BLOCK_NAME:aarch64 \
    --amend $DOCKER_REPO/$BLOCK_NAME:amd64

  docker manifest push $DOCKER_REPO/$BLOCK_NAME:latest
}

build_and_push_image "rpi" "linux/arm/v6"
build_and_push_image "armv7hf" "linux/arm/v7"
build_and_push_image "aarch64" "linux/arm64"
build_and_push_image "amd64" "linux/amd64"

create_and_push_manifest