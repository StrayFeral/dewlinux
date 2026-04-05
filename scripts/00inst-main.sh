#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

export DEWVERSION=1

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

echo ""
echo "Downloading packages, this will take some time, please wait..."
echo ""

sudo apt-get install -y -qq --no-upgrade \
    build-essential autoconf automake pkg-config libtool libssl-dev libncurses-dev libsqlite3-dev \
    bsdutils bsdextrautils \
    wget curl upower locate tmux htop btop eza fzf ncdu bat dysk duf ripgrep fd-find gpm strace nload udisks2 \
    vlock pandoc lynx links2 neovim mc sc-im fastfetch tty-clock calcurse taskwarrior \
    moc moc-ffmpeg-plugin fbi fim mpv \
    wordgrinder \
    alsa-utils libasound2-dev newsboat \
    aspell aspell-bg aspell-fr aspell-ru aspell-en \
    weechat poppler-utils


sudo usermod -aG plugdev $USER
sudo udevadm control --reload
sudo udevadm trigger
sudo systemctl daemon-reexec
sudo cp configs/10-udisks2.rules /etc/polkit-1/rules.d/10-udisks2.rules
sudo systemctl restart polkit

# Creating symlinks
ln -sf ~/dewlinux/scripts/listusb ~/bin/listusb
ln -sf ~/dewlinux/scripts/removeusb ~/bin/removeusb
ln -sf ~/dewlinux/scripts/myip ~/bin/myip
ln -sf ~/dewlinux/pull_google_contacts ~/bin/pull_google_contacts
ln -sf ~/dewlinux/play_chess ~/bin/play_chess
ln -sf ~/dewlinux/dewhelp ~/bin/dewhelp
ln -sf ~/dewlinux/update_system ~/bin/update_system
ln -sf ~/dewlinux/sync_mail ~/bin/sync_mail
ln -sf ~/dewlinux/reauthorize ~/bin/reauthorize
ln -sf ~/dewlinux/scripts/battery ~/bin/battery

mkdir -p ~/.newsboat
cp configs/newsboat_urls ~/.newsboat/urls


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
printf "export PATH=$PATH:$HOME/.cargo/bin\n" >> ~/.profile

# Forcing colored prompt
sed -i "s|#force_color_prompt=yes|force_color_prompt=yes|g" ~/.bashrc

# Nice to have
wget "https://www.markdownguide.org/assets/markdown-cheat-sheet.md" -O ~/dewlinux/markdown-cheat-sheet.md

echo ""
echo "MAIN COMPONENTS INSTALLED."
