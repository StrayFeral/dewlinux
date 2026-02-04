# DEWLINUX Experiment: Could we use linux as cli-only in 2026?

## STATUS

2026-02-03: Start. WORK-IN-PROGRESS


## DESCRIPTION

This repository is to document my journey in my experimental project **"DEWLINUX"**.

**DEWLINUX** is a Terminal-only System Profile on top of a Debian-based Linux Environment.

The goal of the project is to explore what it is to use a modern linux distribution only in command-line mode in 2026.

I am going to use a linux distro without any desktop environment installed.

I am going to search and document what **in my opinion** are the best everyday use tools for a home user.

The experiment will be conducted at present in the form of a virtual machine image.

Videos showing my progress would be uploaded to my Youtube channel, so please subscribe:

<https://www.youtube.com/@SkateCode>

To keep it simple, this experiment would assume a home-based system for everyday personal use, without additional peripheral devices, like printers or whatever else might come to mind.


## USE CASES

make -f DewMakefile


Since this experiment assumes a system for personal home use, the folowing use cases were taken into consideration:

- A bootable and operational computer as a base
    - Debian linux
- Basic accessibility option - Font setup
- Basic system management and system information
    - manual system management
    - neofetch for information
    - htop
- Comfortable shell with some coloring
    - bash
- Desktop organization
    - tmux
- Comfortable file management
    - locate
    - mc
- Text editing - text files
    - vim
- Document conversion
    - pandoc
- Text editing - Word Processor
    - wordgrinder
- Spreadsheet
    - sc
    - sc-im
- Calendar and self-organizing
    - calcurse
- TODO management and self-organizing
    - Taskwarrior
- Music listening
    - alsamixer  # Soundcontrol
    - moc
- Image viewing
    - fbi
- Internet browsing
    - lynx and links2
- Email
    - neomutt
- Chat
    - weechat
- Software development
    - vim editor is already installed
    - python3
    - perl
    - ALE plugin for vim
    - hexcurse hex editor
- Software development - for manual install
    - Python linter and code formatter
    - Perl linter and code formatter
- Games
    - bsdgames
        - adventure
        - arithmetic
        - backgammon
        - bcd
        - crack
        - dick
        - fortune
        - hangman
        - hunt
        - madlibs
        - maze
        - robots
        - trek
        - worm
        - wormwar
        - quiz
        - tippecanoe
    - pacman4console
    - bastet  # Tetris clone
    - nudoku
    - frotz
    - asciiquarium
    - cowsay
    - vitetris


## DISTRO

I've decided to use Debian, so I went with the netinst image which is only near 750mb.

> debian-13.3.0-amd64-netinst.iso

My goal was never to use the most barebone distro. While I have some experience with some unix distros, some RedHat derivatives, I am mostly experienced in pure Debian and some of the derivative distros, so Debian was the natural choice for me. While I am experimenting to go a bit hardcore, it was never my goal to go fully hardcore for which Devuan was never considered.


## INSTALLATION

> Partitioning and base OS installation are manual by design.

Everything from this line and on will be kept as a recipe how to reproduce the 

When promoted for hostname, enter **"blah.local"** where **"blah"** is your desired hostname, but do not forget the **".local"**, unless you have your own purchased domain name.


**LOGIN AS ROOT**

```bash
apt update
apt upgrade

apt -y install sudo git vim vim-nox console-setup

# Only if you want to change the console font and size
# setfont Lat15-TerminusBold18x20  # Font change ~/.profile
# sudo dpkg-reconfigure console-setup

# Adding the main user to the sudoers file
usermod -aG sudo $(ls /home)

# In the next prompt choose "vim.basic"
update-alternatives --config editor

# Get the installation scripts
git clone https://github.com/StrayFeral/dewlinux.git /root/$(ls /home)/dewlinux
chown -R $(ls /home):$(ls /home) /home/$(ls /home)/dewlinux

cat /home/$(ls /home)/dewlinux/configs/add_to_profile >> /root/.profile
cat /home/$(ls /home)/dewlinux/configs/add_to_bashrc >> /root/.bashrc

logout
```

**LOGIN AS the newly created user**

```bash
cd ~/dewlinux
```

Now depends what do you want to do. If you want to install the entire system just type:

```bash
make
# ... or: make all
# (it is the same)
```

Parameters to `make`:
- all (or no parameter listed): Install everything
- main: Install only the most needed tools
- games: Install only the games
- dev: Install development tools (C, Perl, Python)


### NEOMUTT EMAIL SETUP
```bash
# List existing GPG keys
gpg --list-keys

# Suppose your key ID is ABCDEF12
pass init ABCDEF12

# For NON-GMAIL
pass insert email/personal
passwordeval "pass show email/personal"

# FOR GMAIL
pass insert gmail/app-password
pass show gmail/app-password

# TEST
echo "Test email from TTY" | msmtp -s "Test" recipient@example.com



GMAIL > Settings > Forwarding and POP/IMAP > Enable IMAP
Google Account > Security > App Passwords > select "Mail" > Generate
**COPY to clipboard**

COPY: ~/.msmtprc
chmod 600 ~/.msmtprc

COPY: ~/.offlineimaprc
RUN: offlineimap

COPY: ~/.muttrc

RUN: offlineimap  # This syncs gmail with local mail
RUN: neomutt


FOR GMAIL
Google “App Password” (simplest)

Works only if your account allows it (for Gmail + 2FA)
Generate App Password in your Google account → 16-character password
Store in ~/.password-store or NeoMutt config
NeoMutt + msmtp can use it as normal password

CRONTAB:
*/10 * * * * /home/yourusername/bin/offlineimap-sync.sh
```

