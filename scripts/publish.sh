#!/bin/bash

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")"; cd ..; pwd)"
source ${PROJECT_ROOT}/config_docker.sh

DOCKER_REGISTRY_ADDR=$DOCKER_REGISTRY_ADDR

while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    --localhost)
      DOCKER_REGISTRY_ADDR="localhost:5005"
      shift # remove the key
      ;;
    *)
      echo "Unknown option: $key"
      exit 1
      ;;
  esac
done

docker buildx build --platform linux/arm64/v8 \
  -t ${DOCKER_REGISTRY_ADDR}/${DOCKER_IMAGE_NAME} ${PROJECT_ROOT} \
  -f ${PROJECT_ROOT}/Dockerfile.Prod

docker push ${DOCKER_REGISTRY_ADDR}/${DOCKER_IMAGE_NAME}:latest
