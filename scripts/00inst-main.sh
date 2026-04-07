#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

export DEWVERSION=2

# Debugging
# trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND" >&2' ERR
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND"; exit 130' INT

DEWPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
if [ ! -f ~/.profile ] || ! grep -q "= DEWLINUX APPENDED" ~/.profile; then
    cat "${DEWPATH}configs/add_to_profile" >> ~/.profile
fi
if [ ! -f ~/.bashrc ] || ! grep -q "= DEWLINUX APPENDED" ~/.bashrc; then
    cat "${DEWPATH}configs/add_to_bashrc" >> ~/.bashrc
fi

# Prepending .bashrc - file already exist
if ! grep -q "= DEWLINUX PREPENDED" ~/.bashrc; then
    cp -f "${DEWPATH}configs/prepend_to_bashrc" /tmp/.bashrc
    cat ~/.bashrc >> /tmp/.bashrc
    mv -f /tmp/.bashrc ~/.bashrc
fi

if [ ! -f ~/.vimrc ] || ! grep -q "= DEWLINUX APPENDED" ~/.vimrc; then
    cp -f "${DEWPATH}configs/.vimrc" ~/
fi

mkdir -p ~/.config/nvim
if [ ! -f ~/.config/nvim/init.vim ] || ! grep -q "= DEWLINUX APPENDED" ~/.config/nvim/init.vim; then
    cp -f "${DEWPATH}configs/neovim_config" ~/.config/nvim/init.vim
fi

if [ ! -f ~/.bash_aliases ] || ! grep -q "= DEWLINUX APPENDED" ~/.bash_aliases; then
    cp -f "${DEWPATH}configs/.bash_aliases" ~/
fi

# Replacing MOTD
sudo mv -f /etc/motd /etc/motd_old
sudo cp -f "${DEWPATH}configs/motd" /etc/motd

echo ""
echo "Downloading MAIN packages, this will take approx 2:30 minutes, please wait..."
echo ""

sudo apt-get install -y -qq --no-upgrade \
    build-essential autoconf automake pkg-config libtool libssl-dev libncurses-dev libsqlite3-dev \
    terminus-font \
    bsdutils bsdextrautils \
    wget curl upower locate tmux htop btop eza fzf ncdu bat dysk duf ripgrep fd-find gpm strace nload udisks2 \
    vlock pandoc lynx links2 neovim mc sc-im fastfetch tty-clock calcurse taskwarrior \
    moc moc-ffmpeg-plugin fbi fim mpv \
    wordgrinder \
    alsa-utils libasound2-dev newsboat \
    aspell aspell-bg aspell-fr aspell-ru aspell-en \
    weechat poppler-utils \
    cage foot \
    jq

# Package jq was added only because of the lazytail installation

sudo usermod -aG plugdev $USER
sudo udevadm control --reload
sudo udevadm trigger
sudo systemctl daemon-reexec

sudo cp -f "${DEWPATH}configs/10-udisks2.rules" /etc/polkit-1/rules.d/10-udisks2.rules
sudo systemctl restart polkit

# Creating symlinks
ln -sf ~/dewlinux/scripts/listusb       ~/bin/listusb
ln -sf ~/dewlinux/scripts/removeusb     ~/bin/removeusb
ln -sf ~/dewlinux/scripts/myip          ~/bin/myip
ln -sf ~/dewlinux/pull_google_contacts  ~/bin/pull_google_contacts
ln -sf ~/dewlinux/play_chess            ~/bin/play_chess
ln -sf ~/dewlinux/dewhelp               ~/bin/dewhelp
ln -sf ~/dewlinux/update_system         ~/bin/update_system
ln -sf ~/dewlinux/sync_mail             ~/bin/sync_mail
ln -sf ~/dewlinux/reauthorize           ~/bin/reauthorize
ln -sf ~/dewlinux/scripts/battery       ~/bin/battery

mkdir -p ~/.newsboat
cp -f "${DEWPATH}configs/newsboat_urls" ~/.newsboat/urls


mkdir -p ~/.vim/spell
# Vim spellchecking language files
[ -f ~/.vim/spell/en.utf-8.spl ] || wget "https://ftp.nluug.nl/pub/vim/runtime/spell/en.utf-8.spl" -O ~/.vim/spell/en.utf-8.spl
[ -f ~/.vim/spell/fr.utf-8.spl ] || wget "https://ftp.nluug.nl/pub/vim/runtime/spell/fr.utf-8.spl" -O ~/.vim/spell/fr.utf-8.spl
[ -f ~/.vim/spell/bg.utf-8.spl ] || wget "https://ftp.nluug.nl/pub/vim/runtime/spell/bg.utf-8.spl" -O ~/.vim/spell/bg.utf-8.spl
[ -f ~/.vim/spell/ru.utf-8.spl ] || wget "https://ftp.nluug.nl/pub/vim/runtime/spell/ru.utf-8.spl" -O ~/.vim/spell/ru.utf-8.spl
[ -f ~/.vim/spell/de.utf-8.spl ] || wget "https://ftp.nluug.nl/pub/vim/runtime/spell/de.utf-8.spl" -O ~/.vim/spell/de.utf-8.spl
# Suggestion files
[ -f ~/.vim/spell/en.utf-8.sug ] || wget "https://ftp.nluug.nl/pub/vim/runtime/spell/en.utf-8.sug" -O ~/.vim/spell/en.utf-8.sug
[ -f ~/.vim/spell/fr.utf-8.sug ] || wget "https://ftp.nluug.nl/pub/vim/runtime/spell/fr.utf-8.sug" -O ~/.vim/spell/fr.utf-8.sug
[ -f ~/.vim/spell/bg.utf-8.sug ] || wget "https://ftp.nluug.nl/pub/vim/runtime/spell/bg.utf-8.sug" -O ~/.vim/spell/bg.utf-8.sug
[ -f ~/.vim/spell/ru.utf-8.sug ] || wget "https://ftp.nluug.nl/pub/vim/runtime/spell/ru.utf-8.sug" -O ~/.vim/spell/ru.utf-8.sug
[ -f ~/.vim/spell/de.utf-8.sug ] || wget "https://ftp.nluug.nl/pub/vim/runtime/spell/de.utf-8.sug" -O ~/.vim/spell/de.utf-8.sug

# Wordgrinder config
mkdir -p ~/.wordgrinder
cp -f "${DEWPATH}configs/wordgrinder_startup.lua" ~/.wordgrinder/startup.lua

# Very cool tail replacement
mkdir -p /tmp/lazytail
wget https://raw.githubusercontent.com/raaymax/lazytail/master/install.sh -O /tmp/lazytail/install.sh
chmod +x /tmp/lazytail/install.sh

# Feeding ENTER pressings to the installer to assume their defaults in
# case they ask about it
(echo "1"; yes "y") | bash /tmp/lazytail/install.sh
yes "" | ~/.local/bin/lazytail init

# Scooter - terminal regexxer replacement
wget https://github.com/thomasschafer/scooter/releases/download/v0.9.0/scooter-v0.9.0-x86_64-unknown-linux-musl.tar.gz -O /tmp/scooter-v0.9.0-x86_64-unknown-linux-musl.tar.gz
tar -xzf /tmp/scooter-v0.9.0-x86_64-unknown-linux-musl.tar.gz -C /tmp/
mv -f /tmp/scooter ~/.local/bin/

# Not sure this is automatically added, so I am adding it manually
if ! grep -q "cargo/bin" ~/.profile; then
    printf "export PATH=$PATH:$HOME/.cargo/bin\n" >> ~/.profile
fi

# Forcing colored prompt
sed -i "s|#force_color_prompt=yes|force_color_prompt=yes|g" ~/.bashrc

# Nice to have
[ -f ~/dewlinux/markdown-cheat-sheet.md ] || wget "https://www.markdownguide.org/assets/markdown-cheat-sheet.md" -O ~/dewlinux/markdown-cheat-sheet.md

echo ""
echo "MAIN COMPONENTS INSTALLED."
