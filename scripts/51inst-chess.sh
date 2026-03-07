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

# I am installing these two just so the user have a choice
# also these two could be played on the terminal itself
# and still gnuchess could be played with chess-tui too
sudo apt -y install gnuchess               # GNU chess engine
sudo apt -y install phalanx

sudo apt -y install stockfish              # Best chess engine
cargo install chess-tui                    # Chess TUI front-end

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
