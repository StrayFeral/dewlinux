#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

# Debugging
# trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND" >&2' ERR
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND"; exit 130' INT

echo ""
echo "INSTALLING CHESS GAMES..."
echo ""
echo "This requires installation of the devmore tools"
echo ""

sudo apt-get install -y -qq --no-upgrade stockfish  # Best chess engine
cargo install -q chess-tui                          # Chess TUI front-end

# Configuring chess-tui
mkdir -p ~/.config/chess-tui
if [ -f ~/.config/chess-tui/config.toml ]; then
    # In case you're gonna use gnuchess
    # run as:
    # gnuchess --uci
    sed -i "s|engine_path = \"\"|$(which stockfish)|g" ~/.config/chess-tui/config.toml
    sed -i "s|sound_enabled = true|sound_enabled = false|g" ~/.config/chess-tui/config.toml
else
    cp configs/chess-tui.toml ~/.config/chess-tui/config.toml
fi

echo ""
echo "CHESS GAMES INSTALLED."
