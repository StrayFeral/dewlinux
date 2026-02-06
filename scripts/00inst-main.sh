#!/bin/bash
set -euo pipefail

# Debugging
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND" >&2' ERR

echo "INSTALLING MAIN SYSTEM..."

mkdir -p ~/bin

# Configs
cat configs/add_to_profile >> ~/.profile
cat configs/add_to_bashrc >> ~/.bashrc
cp configs/.inputrc ~/
cp configs/.vimrc ~/
cp configs/.bash_aliases ~/
sudo mv /etc/motd /etc/motd_old
sudo cp configs/motd /etc/motd

# Compiling C sources
sudo apt -y install build-essential
sudo apt -y install autoconf automake
sudo apt -y install pkg-config
sudo apt -y install libtool
sudo apt -y install libssl-dev libncurses-dev libsqlite3-dev

sudo apt -y install wget
sudo apt -y install curl
sudo apt -y install locate                  # File location
sudo apt -y install tmux                    # Terminal multiplexer
sudo apt -y install htop                    # Colored top

sudo apt -y install vlock                   # Console locking

sudo apt -y install pandoc                  # Document conversion tool
sudo apt -y install lynx links2             # Browsers
sudo apt -y install neomutt msmtp msmtp-mta offlineimap ca-certificates gnupg pass  # Mail client
sudo apt -y install mc                      # File manager
sudo apt -y install sc sc-im                # Spreadsheets
sudo apt -y install fastfetch               # System info
sudo apt -y install tty-clock               # Clock

sudo apt -y install calcurse                # Calendar
sudo apt -y install taskwarrior             # TODO manager
sudo apt -y install moc moc-ffmpeg-plugin   # MP3 player: mocp
sudo apt -y install fbi                     # Image viewer
sudo apt -y install mpv                     # Video player
sudo apt -y install wordgrinder             # Word processor
sudo apt -y install alsa-utils              # Sound control

sudo apt -y install weechat                 # IRC client
