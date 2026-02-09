# DEWLINUX Experiment: Could we use linux as cli-only in 2026?

## STATUS

2026-02-03: PHASE1 and PHASE2 Start. WORK-IN-PROGRESS...

## DESCRIPTION

This repository is to document my journey in my experimental project **"DEWLINUX"**.

**DEWLINUX** is a Terminal-only System Profile on top of a Debian-based Linux Environment.

The goal of the project is to explore what it is to use a modern linux distribution only in command-line mode in 2026.

I am going to use a linux distro without any desktop environment installed.

I am going to search and document what **in my opinion** are the best everyday use tools for a home user.

The experiment will be conducted at present in the form of a virtual machine environment.

Videos showing my progress would be uploaded to my Youtube channel, so please subscribe:

<https://www.youtube.com/@SkateCode>

To keep it simple, this experiment would assume a home-based system for everyday personal use, without additional peripheral devices, like printers or whatever else might come to mind.

## USE CASES AND WHAT IS INSTALLED

Please see [documentation/index.html](documentation/index.html)

After installation you could simply run `dewdoc.sh` which would be inside ~/dewlinux

## DISTRO

I've decided to use Debian, so I went with the netinst image which is only near 750mb.

> debian-13.3.0-amd64-netinst.iso

My goal was never to use the most barebone distro. While I have some experience with some unix distros, some RedHat derivatives, I am mostly experienced in pure Debian and some of the derivative distros, so Debian was the natural choice for me. While I am experimenting to go a bit hardcore, it was never my goal to go fully hardcore for which Devuan was never considered.

## INSTALLATION

> Partitioning and base OS installation are manual by design.

Start creating a virtual machine with the specified Debian image. Choosing any other image is at your own risk. You may choose also to install on an actual computer, but I tested this setup only on a virtual machine.

> VIRTUAL MACHINES: For hostname type: **blah.local**

Where **"blah"** is your desired hostname. If **".local"** is omitted, it could increase your boottime a lot later if you install sendmail.

**LOGIN AS ROOT**

```bash
apt update
apt upgrade

export DEBIAN_FRONTEND="noninteractive"

apt -y install make sudo git vim vim-nox console-setup console-data

# Only if you want to change the console font and size
# I personally choose: TerminusBold 12x24
# DEBIAN_FRONTEND=dialog dpkg-reconfigure console-setup

# Adding the main user to the sudoers file
usermod -aG sudo $(ls /home)

update-alternatives --set editor $(which vim.nox)

# Get the installation scripts
git clone https://github.com/StrayFeral/dewlinux.git /home/$(ls /home)/dewlinux
chown -R $(ls /home):$(ls /home) /home/$(ls /home)/dewlinux

cat /home/$(ls /home)/dewlinux/configs/add_to_root_profile >> ~/.profile
cat /home/$(ls /home)/dewlinux/configs/add_to_bashrc >> ~/.bashrc
cp /home/$(ls /home)/dewlinux/configs/.vimrc ~/

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
- all (or no parameter): Install everything
- main: Main packages installation
- games: Games installation
- dev: Development tools installation (C, Perl, Python)
- cyr: Installation of Cyrillic keyboard layouts
- DEBUG=1: Sets the DEBUG flag

> On the question should you enable AppArmor support, answer YES

That AppArmor dialog was the only thing I could not automate, sorry.

> IMPORTANT: Essentially what I've built is a terminal-only system. While installation of some packages does install specific libraries from graphical environments and we get about 20% contamination with such components, the system as a whole remains a terminal-only system with no graphical desktop environment being installed or able to run.

### NEOMUTT EMAIL SETUP - WORK IN PROGRESS!

```bash
export GPG_TTY=$(tty)
sudo apt install neomutt isync msmtp msmtp-mta pass gpg notmuch abook

# List existing GPG keys
gpg --list-keys
gpg --list-secret-keys --keyid-format LONG

# Generate if you don't have one (choose RSA)
gpg --full-generate-key

# The part after the slash ("/") is the key ID
gpg --list-secret-keys --keyid-format LONG

# Suppose your key ID is ABCDEF12
pass init ABCDEF12

# For NON-GMAIL
pass insert email/personal
# pass show email/personal

mkdir -p ~/Mail/Inbox
cp configs/email/.mbsyncrc ~/

mbsync -a

cp configs/email/.msmtprc ~/
chmod 600 ~/.msmtprc

cp /usr/share/doc/msmtp/examples/msmtpq/msmtpq ~/bin/
cp /usr/share/doc/msmtp/examples/msmtpq/msmtp-runqueue.sh ~/bin/
chmod +x ~/bin/msmtp*
mkdir -p ~/.msmtp.queue

cp configs/email/.neomuttrc ~/.neomuttrc
mkdir -p ~/.cache/mutt/headers ~/.cache/mutt/bodies

# When asks for mail path: ~/Mail
notmuch setup

# Init and press q
abook


########### workflow:
inside neomutt when writing email: y to reply
S to sync



#########
mbsync to pull the new mail













sudo apt install isync notmuch

# Create a local bin if you don't have one
# mkdir -p ~/.local/bin
Then create the folder: mkdir -p ~/.msmtp.queue

# Copy the scripts from the doc directory
cp /usr/share/doc/msmtp/examples/msmtpq/msmtpq ~/bin/
cp /usr/share/doc/msmtp/examples/msmtpq/msmtp-runqueue.sh ~/bin/

# Make them executable
chmod +x ~/bin/msmtpq ~/bin/msmtp-runqueue.sh

cp configs/temp/mailsync.service  ~/.config/systemd/user/mailsync.service





# List existing GPG keys
gpg --list-keys
gpg --list-secret-keys --keyid-format LONG

# Generate if you don't have one (choose RSA)
gpg --full-generate-key

# The part after the slash ("/") is the key ID
gpg --list-secret-keys --keyid-format LONG

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

### VIDEO

The folowing video shows the initial installation
> WORK IN PROGRESS! VIDEO NOT READY YET!

<div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden;">
  <iframe src="https://www.youtube.com/embed/VIDEO_ID" 
          style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;" 
          frameborder="0" allowfullscreen>
  </iframe>
</div>
