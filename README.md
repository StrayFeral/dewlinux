# DEWLINUX Experiment: Could we use linux as cli-only in 2026?

## STATUS

- 2026-02-26: PHASE3 Start. I will make demo videos and will put them on Youtube.
- 2026-02-03: PHASE1 and PHASE2 Start. WORK-IN-PROGRESS...

## DESCRIPTION

This repository is to document my journey in my experimental project **"DEWLINUX"**.

**DEWLINUX** is a Terminal-only System Profile on top of a Debian-based Linux Environment.

The goal of the project is to explore what it is to use a modern linux distribution only in command-line mode in 2026.

I am going to use a linux distro without any desktop environment installed.

I am going to search and document some great everyday tools for use to a home user.

The experiment will be conducted at present in the form of a virtual machine environment.

Videos showing my progress would be uploaded to my Youtube channel, so please subscribe:

<https://www.youtube.com/@SkateCode>

To keep it simple, this experiment would assume a home-based system for everyday personal use, without additional peripheral devices, like printers or whatever else might come to mind. Primary input controller is assumed to be a standard keyboard and some mouse support have been added lately.

## USE CASES AND WHAT IS INSTALLED

Please see [documentation/index.html](documentation/index.html)

After installation you could simply run `contents.sh` which would be inside ~/dewlinux

## DISTRO

I've decided to use Debian, so I went with the netinst image which is only near 750mb.

> debian-13.3.0-amd64-netinst.iso

My goal was never to use the most barebone distro. While I have some experience with some unix distros, some RedHat derivatives, I am mostly experienced in pure Debian and some of the derivative distros, so Debian was the natural choice for me. While I am experimenting to go a bit hardcore, it was never my goal to go fully hardcore for which Devuan was never considered.

## INSTALLATION

> DISCLAIMER: The folowing instructions and code base represent a tested and verified installation and workflow ONLY for the above mentioned linux distro. If you're using another operating system of any sort, please keep in mind my goal was never to publish a multi-platform code. You are free to modify and adapt this project for your own OS and needs.

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

cat /home/$(ls /home)/dewlinux/configs/add_to_profile >> ~/.profile
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
- gmail: Installation and OAUTH2 setup of either a Google Mail (GMail) or a Microsoft mail account (Outlook.com/Hotmail.com/Live.com)
- DEBUG=1: Sets the DEBUG flag

> For the email installation and setup, please see bellow

> On the question should you enable AppArmor support, answer YES

That AppArmor dialog was the only thing I could not automate, sorry.

> IMPORTANT: Essentially what I've built is a terminal-only system. While installation of some packages does install specific libraries from graphical environments and we get about 20% contamination with such components, the system as a whole remains a terminal-only system with no graphical desktop environment being installed or able to run.

### NEOMUTT OAUTH2 (GMAIL/OUTLOOK) EMAIL SETUP

This is the only weird part.

> DISCLAIMER: The folowing setup was tested in detail and ensures a fully working OAUTH2 setup for a **free** GMAIL account (though a corporate GMAIL account should also work). Support of Google Contacts is also working, but only in read-only mode. While I made my OAUTH2 authorizer code to authorize a Microsoft account too, this scenario was never tested in reality. If you do a Microsoft email setup - use at your own risk. This project interacts with Google People API and local mail files. It is provided "as is." Use at your own risk.

> NOTE: While neomutt does support multiple email account setup, such scenario was never tested.

Before you do anything, the very very first thing you MUST ABSOLUTELY DO is to setup an "app" in the Google Cloud Platform (GCP). I am going to do a video in which I will explain it in detail why this is needed and why without it this setup will never work.

I know, many people would scratch their heads and bang themselves in the wall with the "Why should I do this crap" question, but trust me - you just have to. Google outphased the simple username/password authentication since it's not secure enough, recently outphased the apppasswords too (maybe still work in some areas - no idea) and the only authentication method working now is the OAUTH2, which requires you to setup an app in their GCP platform.

It took me time and lots of nerves until I set this right, since I had no previous GCP exposure at all. I could not find any Youtube video tutorial on how to do this, so I did it the hard way.

I am doing a video tutorial on how to do this, so you don't have to suffer - check my Youtube channel! <https://www.youtube.com/@SkateCode>

Please subscribe to my Youtube channel and click LIKE on the video because I really lost lots of time and efforts until I made this work. Thanks!

#### GETTING THE GOOGLE OAUTH2 CREDENTIALS

You need to do these steps only once.

Use your host OS and go to:

>https://console.cloud.google.com

You must create:
- New project
- Select the newly created project
- New EXTERNAL DESKTOP app
- Add your email
- Add your email as a TESTER
- Enable GMAIL API (search in APIs&Services)
- Enable People API
- Manually add a scopes:
    https://mail.google.com/
    https://www.googleapis.com/auth/contacts
    https://www.googleapis.com/auth/contacts.other.readonly

> COPY THE CLIENT_ID AND CLIENT_SECRET AND SAVE THEM SOMEWHERE !!

> NEVER "PUBLISH" YOUR APPLICATION OR GOOGLE WILL CHARGE YOU MONEY !!

> WARNING: DO NOT RUN the folowing code in a virtual machine terminal. You would need a modern browser for the manual loopback authorization to work. Sorry, but while you can do the installation of everything else straight in the virtual machine terminal, for this step you would need to SSH from another host with some modern browser installed. I mean technically you can do everything in the virtual machine and manually type the URL in your phone, but this would be overkill. So hope you have a working SSH server on your host.

Finally run this and follow the on-screen instructions!

```bash
make gmail
```

I made everything to display instructions on what to do, but regardless, the last thing you would need to do is to run

```bash
./sync_mail.sh
```

So it will do the initial email pull and create and initialize all local mailbox structure for neomutt to run properly.

Finally, if you have Google Contacts and you want to use them in abook, just run:

```bash
./pull_google_contacts.sh
```

> If for any reason you would need to re-authorize the setup (like if you changed your settings in GCP) just run `reauthorize.sh` and it will do what's needed.

### VIDEO

The folowing video shows the initial installation
> WORK IN PROGRESS! VIDEO NOT READY YET!

<div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden;">
  <iframe src="https://www.youtube.com/embed/VIDEO_ID" 
          style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;" 
          frameborder="0" allowfullscreen>
  </iframe>
</div>
