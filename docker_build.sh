#!/bin/bash

# Docker build script for LiteLLM Database
# This script builds the docker/Dockerfile.database and pushes to Google Artifact Registry

set -e

# Configuration
DOCKERFILE_PATH="docker/Dockerfile.database"
REGISTRY_URL="us-central1-docker.pkg.dev/gen-lang-client-0608717027/pixelml-us-central-1-registry"
IMAGE_NAME="litellm-database"

# Extract version from pyproject.toml
echo "Extracting version from pyproject.toml..."
VERSION=$(grep '^version = ' pyproject.toml | head -1 | sed 's/version = "//' | sed 's/"//')

if [ -z "$VERSION" ]; then
    echo "Error: Could not extract version from pyproject.toml"
    exit 1
fi

echo "Found version: $VERSION"

# Construct full image URL
IMAGE_URL="${REGISTRY_URL}/${IMAGE_NAME}:${VERSION}"
LATEST_URL="${REGISTRY_URL}/${IMAGE_NAME}:latest"

echo "Building Docker image: $IMAGE_URL"

# Build the Docker image
docker build \
    -f "$DOCKERFILE_PATH" \
    -t "$IMAGE_URL" \
    -t "$LATEST_URL" \
    .

echo "Docker image built successfully!"

# Push the versioned tag
echo "Pushing image with version tag: $IMAGE_URL"
docker push "$IMAGE_URL"

# Push the latest tag
echo "Pushing image with latest tag: $LATEST_URL"
docker push "$LATEST_URL"

echo "Docker image pushed successfully!"
echo "Image URLs:"
echo "  Versioned: $IMAGE_URL"
echo "  Latest:    $LATEST_URL"
