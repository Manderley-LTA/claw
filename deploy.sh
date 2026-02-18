#!/bin/bash

# ============================================
# OpenClaw Stack - Modular Deploy Script
# ============================================
#
# Usage:
#   ./deploy.sh --preset lightweight
#   ./deploy.sh --preset full
#   ./deploy.sh --preset luc-rcpro
#   ./deploy.sh --help
#
# Presets are combinations of docker-compose files
# Customize presets in this script

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default action
ACTION="up -d"
PRESET=""
VERBOSE=0

# Help function
show_help() {
    cat << EOF
${BLUE}OpenClaw Stack - Modular Deployment${NC}

${GREEN}Usage:${NC}
  $0 --preset <preset> [--action <action>] [--verbose]
  $0 --help

${GREEN}Presets:${NC}
  ${YELLOW}minimal${NC}           Core only (Traefik, OpenClaw, MinIO, Redis, Postgres, Qdrant)
  ${YELLOW}lightweight${NC}       Core + Monitoring + Search (SearXNG) — Recommended
  ${YELLOW}full${NC}              Core + Monitoring + Search + Security + Integrations + Supabase + Git
  ${YELLOW}luc-rcpro${NC}         Core + Monitoring + Search + Security + RC Pro App — Luc's preset
  ${YELLOW}custom${NC}            Manual compose files selection

${GREEN}Actions:${NC}
  up -d                 Start services (default)
  down                  Stop services
  logs -f               Stream logs
  ps                    Show running containers
  pull                  Pull latest images

${GREEN}Examples:${NC}
  ./deploy.sh --preset lightweight
  ./deploy.sh --preset luc-rcpro --action down
  ./deploy.sh --preset full --action logs -f
  ./deploy.sh --preset minimal --verbose

${GREEN}Options:${NC}
  --help                Show this message
  --verbose             Print docker-compose command before executing
  --action              Override default action (default: "up -d")

EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --preset)
            PRESET="$2"
            shift 2
            ;;
        --action)
            ACTION="$2"
            shift 2
            ;;
        --verbose|-v)
            VERBOSE=1
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

# Validate preset
if [ -z "$PRESET" ]; then
    echo -e "${RED}Error: --preset is required${NC}"
    show_help
    exit 1
fi

# Build docker-compose command based on preset
case "$PRESET" in
    minimal)
        COMPOSE_FILES="-f docker-compose.core.yml"
        DESCRIPTION="Core services (Traefik, OpenClaw, MinIO, Redis, Postgres, Qdrant)"
        ;;
    lightweight)
        COMPOSE_FILES="-f docker-compose.core.yml \
                      -f docker-compose.monitoring.yml \
                      -f docker-compose.search.yml"
        DESCRIPTION="Core + Monitoring + Search (SearXNG) — ~8-10 GB RAM"
        ;;
    full)
        COMPOSE_FILES="-f docker-compose.core.yml \
                      -f docker-compose.monitoring.yml \
                      -f docker-compose.search.yml \
                      -f docker-compose.security.yml \
                      -f docker-compose.integrations.yml \
                      -f docker-compose.supabase.yml \
                      -f docker-compose.git.yml"
        DESCRIPTION="Full stack: Core + Monitoring + Search + Security + Integrations + Supabase + Git — ~32-40 GB RAM"
        ;;
    luc-rcpro)
        COMPOSE_FILES="-f docker-compose.core.yml \
                      -f docker-compose.monitoring.yml \
                      -f docker-compose.search.yml \
                      -f docker-compose.security.yml \
                      -f docker-compose.rcpro.yml"
        DESCRIPTION="Luc's preset: Core + Monitoring + Search + Security + RC Pro App — ~10-12 GB RAM"
        ;;
    *)
        echo -e "${RED}Unknown preset: $PRESET${NC}"
        show_help
        exit 1
        ;;
esac

# Display preset info
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}OpenClaw Stack Deployment${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "Preset:      ${YELLOW}$PRESET${NC}"
echo -e "Description: ${YELLOW}$DESCRIPTION${NC}"
echo -e "Action:      ${YELLOW}$ACTION${NC}"
echo -e "${BLUE}========================================${NC}"

# Check for .env file
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}⚠️  Warning: .env file not found${NC}"
    echo -e "Please copy and configure .env.example:"
    echo -e "  ${GREEN}cp .env.example .env${NC}"
    echo -e "  ${GREEN}nano .env${NC}"
    exit 1
fi

# Source .env to get OPENCLAW_IMAGE
set -a
source .env
set +a

# Check for OpenClaw image
echo -e "${BLUE}Checking Docker image...${NC}"
OPENCLAW_IMG="${OPENCLAW_IMAGE:-openclaw:local}"

if [[ "$OPENCLAW_IMG" == *"ghcr.io"* ]] || [[ "$OPENCLAW_IMG" == *"/"* ]]; then
    # Pre-built image from registry - will be pulled automatically
    echo -e "${GREEN}✓ Using registry image: $OPENCLAW_IMG${NC}"
else
    # Local image - check if exists
    if ! docker images "$OPENCLAW_IMG" --format "{{.Repository}}:{{.Tag}}" | grep -q "$OPENCLAW_IMG"; then
        echo -e "${RED}✗ Error: Docker image not found: $OPENCLAW_IMG${NC}"
        echo -e "${YELLOW}Build the image first:${NC}"
        echo -e "  ${GREEN}./build-image.sh${NC}"
        echo -e "  ${GREEN}or${NC}"
        echo -e "  ${GREEN}docker build -t openclaw:local -f Dockerfile .${NC}"
        echo -e "${YELLOW}Or use a pre-built image in .env:${NC}"
        echo -e "  ${GREEN}OPENCLAW_IMAGE=ghcr.io/openclaw/openclaw:latest${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Local image found: $OPENCLAW_IMG${NC}"
fi

# Build final docker-compose command
CMD="docker compose $COMPOSE_FILES"

# Add docker-compose.rcpro.yml if available and not already included
if [[ "$PRESET" == "luc-rcpro" ]] && [ -f "docker-compose.rcpro.yml" ]; then
    # Already included above
    :
elif [[ "$PRESET" != "luc-rcpro" ]] && [[ "$COMPOSE_FILES" != *"docker-compose.rcpro.yml"* ]]; then
    # RC Pro not included in this preset (OK)
    :
fi

# Add action
CMD="$CMD $ACTION"

# Display command if verbose
if [ $VERBOSE -eq 1 ]; then
    echo -e "${BLUE}Executing:${NC}"
    echo -e "${YELLOW}$CMD${NC}"
    echo ""
fi

# Execute docker-compose
eval "$CMD"

# Success message
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Command completed successfully${NC}"
    if [[ "$ACTION" == *"up"* ]]; then
        echo -e "${BLUE}Services should be starting. Check status:${NC}"
        echo -e "  ${GREEN}docker compose ps${NC}"
        echo -e "${BLUE}Stream logs:${NC}"
        echo -e "  ${GREEN}docker compose logs -f${NC}"
    fi
else
    echo -e "${RED}✗ Command failed${NC}"
    exit 1
fi
