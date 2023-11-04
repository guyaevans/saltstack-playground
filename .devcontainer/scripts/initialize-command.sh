#!/usr/bin/env bash

DOCKER_VOLUME_NAME="devcontainer-history"
DOCKER_NETWORK_NAME="saltstack-playground"

if ! docker volume inspect "${DOCKER_VOLUME_NAME}" &>/dev/null 2>&1; then
  echo -n "INITIALIZE COMMAND :: Creating Docker volume '${DOCKER_VOLUME_NAME}'... "
  if docker volume create "${DOCKER_VOLUME_NAME}" &>/dev/null; then
    echo "done"
  fi
else
  echo "INITIALIZE COMMAND :: Docker volume '${DOCKER_VOLUME_NAME}' already exists - no need to create."
fi
if [[ ! $(docker network ls -qf name=${DOCKER_NETWORK_NAME}) =~ [0-9a-z]{12} ]]; then
  echo -n "INITIALIZE COMMAND :: Creating Docker network '${DOCKER_NETWORK_NAME}'... "
  if docker network create "${DOCKER_NETWORK_NAME}" &>/dev/null; then
    echo "done"
  fi
else
  echo "INITIALIZE COMMAND :: Docker network '${DOCKER_NETWORK_NAME}' already exists - no need to create."
fi
### Build salt-playground
docker build -t local/debian-base -f ".devcontainer/Dockerfiles/Dockerfile-Debian-11-base" .
docker compose -f ".devcontainer/docker-compose.yml" build
