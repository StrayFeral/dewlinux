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


## USE CASES AND WHAT IS INSTALLED

Please see [documentation/index.html](documentation/index.html)

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
# OR
# dpkg-reconfigure console-setup

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
- DEBUG=1: Sets the DEBUG flag


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

### VIDEO

The folowing video shows the initial installation
> WORK IN PROGRESS! VIDEO NOT READY YET!

<div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden;">
  <iframe src="https://www.youtube.com/embed/VIDEO_ID" 
          style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;" 
          frameborder="0" allowfullscreen>
  </iframe>
</div>
