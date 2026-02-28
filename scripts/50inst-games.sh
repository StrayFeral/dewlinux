#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

# Debugging
# trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND" >&2' ERR
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND"; exit 130' INT

echo ""
echo "INSTALLING GAMES..."
echo ""

sudo apt -y install bsdgames            # Collection of old BSD games
sudo apt -y install pacman4console      # PacMan clone
sudo apt -y install nudoku              # Sudoku
sudo apt -y install cowsay              # Not a game, but it's a classic
sudo apt -y install bastet              # Tetris clone
sudo apt -y install vitetris            # Tetris clone

# Installing interpretter for Infocom Z-machine games and a sample game
sudo apt -y install frotz
wget "https://www.ifarchive.org/if-archive/games/zcode/LostPig.z8" -O zgames/LostPig.z8

echo ""
echo "GAMES INSTALLED."
