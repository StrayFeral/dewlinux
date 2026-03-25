#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

# Debugging
# trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND" >&2' ERR
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND"; exit 130' INT

echo ""
echo "INSTALLING MAIN SYSTEM..."
echo ""

# Recreating the directory structure of most home systems
mkdir -p ~/Downloads
mkdir -p ~/Music
mkdir -p ~/Documents
mkdir -p ~/Videos
mkdir -p ~/Pictures

mkdir -p ~/bin
mkdir -p ~/.local/bin
mkdir -p ~/.cargo/bin
export PATH="$PATH:$HOME/.local/bin:$HOME/bin:$HOME/.cargo/bin"

# Configs
cat configs/add_to_profile >> ~/.profile
cat configs/add_to_bashrc >> ~/.bashrc

# Prepending .bashrc
cp configs/prepend_to_bashrc /tmp/.bashrc
cat ~/.bashrc >> /tmp/.bashrc
cp /tmp/.bashrc ~/.bashrc

cp configs/.vimrc ~/
mkdir -p ~/.config/nvim
cp configs/neovim_config ~/.config/nvim/init.vim


cp configs/.bash_aliases ~/
sudo mv /etc/motd /etc/motd_old
sudo cp configs/motd /etc/motd

# User-friendly way for newbies to understand what's connected and where
sudo apt -y install udisks2
sudo cp configs/99-usb-auto.rules /etc/udev/rules.d/
sudo cp scripts/usb-auto.sh /usr/local/bin/
sudo cp configs/usb-auto@.service /etc/systemd/system/
sudo udevadm control --reload
sudo systemctl daemon-reexec
cp scripts/usbcheck.sh ~/

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

sudo apt -y install bsdutils bsdextrautils  # Utilities
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
sudo apt -y install strace                  # Trace system calls
sudo apt -y install nload                   # Network monitoring

sudo apt -y install vlock                   # Console locker

sudo apt -y install pandoc                  # Document conversion tool
sudo apt -y install lynx links2             # Browsers

sudo apt -y install neovim                  # Text editor
sudo apt -y install mc                      # File manager
sudo apt -y install sc-im                   # Spreadsheets
sudo apt -y install fastfetch               # System info
sudo apt -y install tty-clock               # Clock

sudo apt -y install calcurse                # Calendar
sudo apt -y install taskwarrior             # TODO manager
sudo apt -y install moc moc-ffmpeg-plugin   # MP3 player: mocp
sudo apt -y install fbi fim                 # Image viewers
sudo apt -y install mpv                     # Video player
sudo apt -y install wordgrinder             # Word processor
sudo apt -y install alsa-utils              # Sound control
sudo apt -y install libasound2-dev

sudo apt -y install newsboat                # Newsreader

mkdir -p ~/.newsboat
cp configs/newsboat_urls ~/.newsboat/urls

# ASpell
sudo apt -y install aspell
sudo apt -y install aspell-bg
sudo apt -y install aspell-fr
sudo apt -y install aspell-ru
sudo apt -y install aspell-en

sudo apt -y install weechat                 # IRC client
sudo apt -y install poppler-utils           # pdftotext file.pdf - | less

mkdir -p ~/.vim/spell
# Vim spellchecking language files
wget "https://ftp.nluug.nl/pub/vim/runtime/spell/en.utf-8.spl" -O ~/.vim/spell/en.utf-8.spl
wget "https://ftp.nluug.nl/pub/vim/runtime/spell/fr.utf-8.spl" -O ~/.vim/spell/fr.utf-8.spl
wget "https://ftp.nluug.nl/pub/vim/runtime/spell/bg.utf-8.spl" -O ~/.vim/spell/bg.utf-8.spl
wget "https://ftp.nluug.nl/pub/vim/runtime/spell/ru.utf-8.spl" -O ~/.vim/spell/ru.utf-8.spl
wget "https://ftp.nluug.nl/pub/vim/runtime/spell/de.utf-8.spl" -O ~/.vim/spell/de.utf-8.spl
# Suggestion files
wget "https://ftp.nluug.nl/pub/vim/runtime/spell/en.utf-8.sug" -O ~/.vim/spell/en.utf-8.sug
wget "https://ftp.nluug.nl/pub/vim/runtime/spell/fr.utf-8.sug" -O ~/.vim/spell/fr.utf-8.sug
wget "https://ftp.nluug.nl/pub/vim/runtime/spell/bg.utf-8.sug" -O ~/.vim/spell/bg.utf-8.sug
wget "https://ftp.nluug.nl/pub/vim/runtime/spell/ru.utf-8.sug" -O ~/.vim/spell/ru.utf-8.sug
wget "https://ftp.nluug.nl/pub/vim/runtime/spell/de.utf-8.sug" -O ~/.vim/spell/de.utf-8.sug

# Wordgrinder config
mkdir -p ~/.wordgrinder
cp configs/wordgrinder_startup.lua ~/.wordgrinder/startup.lua

# Very cool tail replacement
mkdir -p lazytail
wget https://raw.githubusercontent.com/raaymax/lazytail/master/install.sh -O lazytail/install.sh
chmod +x lazytail/install.sh
bash lazytail/install.sh
lazytail init

# Scooter - terminal regexxer replacement
wget https://github.com/thomasschafer/scooter/releases/download/v0.9.0/scooter-v0.9.0-x86_64-unknown-linux-musl.tar.gz -O /tmp/scooter-v0.9.0-x86_64-unknown-linux-musl.tar.gz
tar -xzf /tmp/scooter-v0.9.0-x86_64-unknown-linux-musl.tar.gz
mv ./scooter ~/.local/bin/

sudo apt -y install cage foot               # These would get 256 colors

# Not sure this is automatically added, so I am adding it manually
echo "export PATH=$PATH:$HOME/.cargo/bin" >> ~/.profile

# Forcing colored prompt
sed -i "s|#force_color_prompt=yes|force_color_prompt=yes|g" ~/.bashrc

echo ""
echo "MAIN COMPONENTS INSTALLED."
