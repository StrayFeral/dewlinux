#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

# Debugging
# trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND" >&2' ERR
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND"; exit 130' INT

DEWPATH=""
if [ -n "${MAKEFILEPATH:-}" ]; then
    DEWPATH="${MAKEFILEPATH}/"
fi

echo ""
echo "INSTALLING GAMES..."
echo ""

echo "Downloading packages, this may take some time, please wait..."
echo ""

sudo apt-get install -y -qq --no-upgrade bsdgames pacman4console nudoku cowsay bastet vitetris frotz

if [ ! -f "${DEWPATH}zgames/LostPig.z8" ]; then
    wget "https://www.ifarchive.org/if-archive/games/zcode/LostPig.z8" -O "${DEWPATH}zgames/LostPig.z8"
fi

echo ""
echo "GAMES INSTALLED."
