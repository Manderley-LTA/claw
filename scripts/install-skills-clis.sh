#!/bin/bash
# Install custom CLIs required by OpenClaw built-in skills
# This script should be run during Docker image build

set -e

INSTALL_DIR="${HOME}/.local/bin"
mkdir -p "$INSTALL_DIR"

echo "Installing skill CLIs to $INSTALL_DIR..."

# Detect architecture
ARCH=$(uname -m)
case "$ARCH" in
  x86_64)
    ARCH_SUFFIX="x86_64"
    ;;
  aarch64|arm64)
    ARCH_SUFFIX="aarch64"
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

# Install himalaya (email CLI)
echo "Installing himalaya..."
HIMALAYA_VERSION="1.0.0"
curl -sSL "https://github.com/soywod/himalaya/releases/download/v${HIMALAYA_VERSION}/himalaya-v${HIMALAYA_VERSION}-${ARCH_SUFFIX}-linux.tar.gz" \
  | tar -xz -C "$INSTALL_DIR" himalaya
chmod +x "$INSTALL_DIR/himalaya"

# Install obsidian-cli (Obsidian vault manager)
echo "Installing obsidian-cli..."
npm install -g @death_au/obsidian-cli
ln -sf "$(npm root -g)/@death_au/obsidian-cli/bin/obsidian-cli.js" "$INSTALL_DIR/obsidian-cli" || true

# Install spogo (Spotify CLI)
echo "Installing spogo..."
SPOGO_VERSION="0.7.1"
curl -sSL "https://github.com/Schum123/spogo/releases/download/v${SPOGO_VERSION}/spogo-v${SPOGO_VERSION}-${ARCH_SUFFIX}-unknown-linux-gnu.tar.gz" \
  | tar -xz -C "$INSTALL_DIR" spogo
chmod +x "$INSTALL_DIR/spogo"

# Install gog (Google Workspace CLI)
echo "Installing gog..."
GOG_VERSION="1.2.0"
curl -sSL "https://github.com/vycius/gog-cli/releases/download/v${GOG_VERSION}/gog-${ARCH_SUFFIX}-unknown-linux-gnu" \
  -o "$INSTALL_DIR/gog"
chmod +x "$INSTALL_DIR/gog"

# Install openhue (Philips Hue CLI)
echo "Installing openhue..."
OPENHUE_VERSION="0.3.0"
curl -sSL "https://github.com/bahlo/openhue/releases/download/v${OPENHUE_VERSION}/openhue-${ARCH_SUFFIX}-unknown-linux-musl.tar.gz" \
  | tar -xz -C "$INSTALL_DIR" openhue
chmod +x "$INSTALL_DIR/openhue"

# Install sag (ElevenLabs TTS CLI)
echo "Installing sag..."
SAG_VERSION="0.1.5"
curl -sSL "https://github.com/openclaw/sag/releases/download/v${SAG_VERSION}/sag-${ARCH_SUFFIX}-unknown-linux-gnu.tar.gz" \
  | tar -xz -C "$INSTALL_DIR" sag
chmod +x "$INSTALL_DIR/sag"

# Install camsnap (RTSP/ONVIF camera CLI)
echo "Installing camsnap..."
CAMSNAP_VERSION="0.2.0"
curl -sSL "https://github.com/openclaw/camsnap/releases/download/v${CAMSNAP_VERSION}/camsnap-${ARCH_SUFFIX}-unknown-linux-gnu.tar.gz" \
  | tar -xz -C "$INSTALL_DIR" camsnap
chmod +x "$INSTALL_DIR/camsnap"

# Install ordercli (food delivery order checker)
echo "Installing ordercli..."
ORDERCLI_VERSION="0.1.0"
curl -sSL "https://github.com/openclaw/ordercli/releases/download/v${ORDERCLI_VERSION}/ordercli-${ARCH_SUFFIX}-unknown-linux-gnu.tar.gz" \
  | tar -xz -C "$INSTALL_DIR" ordercli
chmod +x "$INSTALL_DIR/ordercli"

echo "✅ All skill CLIs installed successfully!"
ls -lh "$INSTALL_DIR"
