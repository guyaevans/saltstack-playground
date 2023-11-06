#!/usr/bin/env bash

DOCKER_VOLUME_NAME="devcontainer-history"

if ! docker volume inspect "${DOCKER_VOLUME_NAME}" &>/dev/null 2>&1; then
  echo -n "INITIALIZE COMMAND :: Creating Docker volume '${DOCKER_VOLUME_NAME}'... "
  if docker volume create "${DOCKER_VOLUME_NAME}" &>/dev/null; then
    echo "done"
  fi
else
  echo "INITIALIZE COMMAND :: Docker volume '${DOCKER_VOLUME_NAME}' already exists - no need to create."
fi
### Build debian base image
echo "INITIALIZE COMMAND :: Building Debian base image..."
docker build -t local/debian-base -f ".devcontainer/Dockerfiles/Dockerfile-Debian-11-base" .
