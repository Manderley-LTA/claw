#!/bin/bash

# ============================================
# OpenClaw - Build Docker Image
# ============================================
#
# Builds the openclaw:local Docker image with all
# skill CLIs and system dependencies included.
#
# Usage:
#   ./build-image.sh
#   ./build-image.sh --tag my-openclaw:v1.0
#   ./build-image.sh --help

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Defaults
TAG="openclaw:local"
DOCKERFILE="Dockerfile"
BUILD_ARGS=""

# Help function
show_help() {
    cat << EOF
${BLUE}OpenClaw Docker Image Builder${NC}

${GREEN}Usage:${NC}
  $0 [options]

${GREEN}Options:${NC}
  --tag <tag>              Docker image tag (default: openclaw:local)
  --dockerfile <path>      Dockerfile path (default: Dockerfile)
  --build-arg <arg>        Pass build argument (can be repeated)
  --no-cache              Build without using cache
  --help                   Show this message

${GREEN}Examples:${NC}
  $0                                    # Build as openclaw:local
  $0 --tag my-openclaw:v1.0             # Build with custom tag
  $0 --no-cache                         # Rebuild everything
  $0 --build-arg OPENCLAW_DOCKER_APT_PACKAGES="htop curl"

${YELLOW}Note:${NC} Building takes 5-10 minutes on first run.
Images are cached locally for faster rebuilds.

EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --tag)
            TAG="$2"
            shift 2
            ;;
        --dockerfile)
            DOCKERFILE="$2"
            shift 2
            ;;
        --build-arg)
            BUILD_ARGS="$BUILD_ARGS --build-arg $2"
            shift 2
            ;;
        --no-cache)
            BUILD_ARGS="$BUILD_ARGS --no-cache"
            shift
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

# Check if Dockerfile exists
if [ ! -f "$DOCKERFILE" ]; then
    echo -e "${RED}Error: Dockerfile not found: $DOCKERFILE${NC}"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed or not in PATH${NC}"
    exit 1
fi

# Check if Docker daemon is running
if ! docker ps &> /dev/null; then
    echo -e "${RED}Error: Docker daemon is not running${NC}"
    exit 1
fi

# Display build info
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}OpenClaw Docker Image Builder${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "Dockerfile:  ${YELLOW}$DOCKERFILE${NC}"
echo -e "Image tag:   ${YELLOW}$TAG${NC}"
if [ -n "$BUILD_ARGS" ]; then
    echo -e "Build args:  ${YELLOW}$BUILD_ARGS${NC}"
fi
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${YELLOW}⏳ Building... (this may take 5-10 minutes)${NC}"
echo ""

# Build the image
BUILD_CMD="docker build -t $TAG $BUILD_ARGS -f $DOCKERFILE ."

if ! eval "$BUILD_CMD"; then
    echo -e "${RED}✗ Build failed${NC}"
    exit 1
fi

# Success message
echo ""
echo -e "${GREEN}✓ Image built successfully: $TAG${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo -e "  ${GREEN}1. Verify image:${NC} docker images | grep $TAG"
echo -e "  ${GREEN}2. Deploy stack:${NC} ./deploy.sh --preset lightweight"
echo ""

# Optional: Show image info
echo -e "${BLUE}Image info:${NC}"
docker images "$TAG" --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
