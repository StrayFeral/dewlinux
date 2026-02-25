#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

# Debugging
# trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND" >&2' ERR
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND"; exit 130' INT

echo ""
echo "INSTALLING MAIN SYSTEM..."
echo ""

mkdir -p ~/bin
mkdir -p ~/.local/bin

# Configs
cat configs/add_to_profile >> ~/.profile
cat configs/add_to_bashrc >> ~/.bashrc
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

# I've spent near a day to figure out how to automate the dialog of
# msmpt asking for apparmor and since this lost me too much time and
# msmtp still asks me, I give up so I can move on to other tasks.
# If anyone gets a smart idea working on this Debian image -
# be my guest.

sudo apt -y install wget
sudo apt -y install curl
sudo apt -y install locate                  # File location
sudo apt -y install tmux                    # Terminal multiplexer
sudo apt -y install htop btop               # System monitoring
sudo apt -y install eza                     # Colorful ls
sudo apt -y install fzf                     # Modern search tool
sudo apt -y install ncdu                    # Great du replacement
sudo apt -y install bat                     # Cat replacement
sudo apt -y install dysk                    # df replacement
sudo apt -y install duf                     # df replacement
sudo apt -y install ripgrep                 # grep replacement
sudo apt -y install fd-find                 # find replacement
sudo apt -y install gpm                     # Mouse support

sudo apt -y install vlock                   # Console locker

sudo apt -y install pandoc                  # Document conversion tool
sudo apt -y install lynx links2             # Browsers

sudo apt -y install neovim                  # Text editor
sudo apt -y install mc                      # File manager
sudo apt -y install sc sc-im                # Spreadsheets
sudo apt -y install fastfetch               # System info
sudo apt -y install tty-clock               # Clock

sudo apt -y install calcurse                # Calendar
sudo apt -y install taskwarrior             # TODO manager
sudo apt -y install moc moc-ffmpeg-plugin   # MP3 player: mocp
sudo apt -y install fbi fim                 # Image viewers
sudo apt -y install mpv                     # Video player
sudo apt -y install wordgrinder             # Word processor
sudo apt -y install alsa-utils              # Sound control

sudo apt -y install weechat                 # IRC client

sudo apt -y install poppler-utils           # pdftotext file.pdf - | less

echo ""
echo "MAIN COMPONENTS INSTALLED."
