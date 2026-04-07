#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

# Debugging
# trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND" >&2' ERR
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND"; exit 130' INT

DEWPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "INSTALLING OAUTH2 EMAIL TOOLS..."
echo ""
echo "On the 'Enable AppArmor' question just say 'Yes'..."
echo ""

echo "FIRST BE SURE YOU DID THE **CLOUD** APP SETUP!"
echo "IF NOT - PRESS CTRL-C NOW and go and do the setup."
echo ""
echo ""
read -p "Enter your NAME (to use in FROM)   : " realname
read -p "Enter your FULL email address      : " emailaddr
echo ""

emailaddr="${emailaddr,,}"

# I really hate to hardcode things
export TOKENENDPOINT="https://login.microsoftonline.com/common/oauth2/v2.0/token"
if [[ "$emailaddr" == *"gmail"* ]]; then
    export TOKENENDPOINT="https://oauth2.googleapis.com/token"
fi

echo ""
echo "Downloading packages, this may take some time, please wait..."
echo ""

sudo apt update
sudo apt-get install -y -qq --no-upgrade neomutt offlineimap msmtp msmtp-mta python3 python3-requests gnupg pass abook

mkdir -p ~/bin
mkdir -p ~/.mail/gmail
# ~/.msmtpqueue

# Local vCard Storage
mkdir -p ~/.contacts/google

mkdir -p ~/.msmtp.queue
chmod 700 ~/.msmtp.queue

mkdir -p ~/.abook


if [ ! -f ~/.abook/abookrc ] || ! grep -q "= DEWLINUX APPENDED" ~/.abook/abookrc; then
    cp -f "${DEWPATH}configs/gmail/abookrc" ~/.abook/abookrc
fi

# While I am using abook to hold the Google contact list, I still
# want the aliases
touch ~/.neomutt_aliases

# Default signature file
if [ ! -f ~/.neomutt_signature ]; then
    cp -f "${DEWPATH}configs/gmail/.neomutt_signature" ~/.neomutt_signature
fi

if [ ! -f ~/.msmtprc ] || ! grep -q "= DEWLINUX APPENDED" ~/.msmtprc; then
    cp -f "${DEWPATH}configs/gmail/.msmtprc" ~/
    chmod 600 ~/.msmtprc
fi
if [ ! -f ~/.neomuttrc ] || ! grep -q "= DEWLINUX APPENDED" ~/.neomuttrc; then
    cp -f "${DEWPATH}configs/gmail/.neomuttrc" ~/
fi
if [ ! -f ~/bin/get_mail_secret.py ]; then
    cp -f "${DEWPATH}scripts/get_mail_secret.py" ~/bin
fi
if [ ! -f ~/msmtp-enqueue-only ]; then
    cp -f "${DEWPATH}scripts/msmtp-enqueue-only" ~/bin
fi

export MSMTPQ_DIR="$HOME/.msmtp.queue"
export MSMTP_QUEUE="$HOME/.msmtp.queue"
export MSMTPQ_Q_ONLY=1

if ! grep -q "MSMTPQ_DIR" ~/.profile; then
    printf '\nexport MSMTPQ_DIR="$HOME/.msmtp.queue"\n' >> ~/.profile
    printf 'export MSMTP_QUEUE="$HOME/.msmtp.queue"\n' >> ~/.profile
    printf 'export MSMTPQ_Q_ONLY=1\n' >> ~/.profile
fi


# Generate a key
echo ""
echo ""
#echo "Choose RSA type of key, 4096 size, 'never expire', then type 'y' and ENTER:"
#echo ""
export GPG_TTY=$(tty)
#gpg --full-generate-key
gpg --batch --generate-key <<EOF
    Key-Type: RSA
    Key-Length: 4096
    Subkey-Type: RSA
    Subkey-Length: 4096
    Name-Real: $realname
    Name-Email: $emailaddr
    Expire-Date: 0
    %commit
EOF


# Initialize the password store
# export public_key=$(gpg --list-secret-keys --keyid-format LONG | grep sec | cut -d'/' -f2 | cut -d' ' -f1)
export public_key=$(gpg --list-secret-keys --with-colons | grep '^fpr' | head -n 1 | cut -d: -f10)
pass init "$public_key"

# If you don't want to type passwords in the middle of neomutt session
# you should install pinentry-tty or pinentry-curses
# echo "pinentry-program /usr/bin/pinentry-curses" >> ~/.gnupg/gpg-agent.conf
# however this is out of the scope of the current script as we would
# sync it all with an external script

# Get the refresh token
python3 "${DEWPATH}scripts/oauth2_config.py" $emailaddr

# For some weird reason this file normally would get truncated and
# this will break the whole config. So I am copying at the very end
if [ ! -f ~/.offlineimaprc ] || ! grep -q "= DEWLINUX APPENDED" ~/.offlineimaprc; then
    cp -f "${DEWPATH}configs/gmail/.offlineimaprc" ~/
fi

sed -i "s|YOURLINUXUSERNAMEHERE|$USER|g" ~/.offlineimaprc
sed -i "s|YOURGMAILEMAILHERE|$emailaddr|g" ~/.offlineimaprc
sed -i "s|TOKENENDPOINTHERE|$TOKENENDPOINT|g" ~/.offlineimaprc

sed -i "s|YOURLINUXUSERNAMEHERE|$USER|g" ~/.msmtprc
sed -i "s|YOURGMAILEMAILHERE|$emailaddr|g" ~/.msmtprc

sed -i "s|YOURGMAILEMAILHERE|$emailaddr|g" ~/.neomuttrc
sed -i "s|YOURNAMEHERE|$realname|g" ~/.neomuttrc

chmod 700 ~/bin/get_mail_secret.py
if [ ! -f /etc/apparmor.d/usr.bin.msmtp ] || ! grep -q "= DEWLINUX APPENDED" /etc/apparmor.d/usr.bin.msmtp; then
    sudo cp -f "${DEWPATH}configs/gmail/usr.bin.msmtp" /etc/apparmor.d/
    sudo chmod 644 /etc/apparmor.d/usr.bin.msmtp
    
    sudo mkdir -p /etc/apparmor.d/local
    sudo touch /etc/apparmor.d/local/usr.bin.msmtp
    
    #sudo apparmor_parser -r /etc/apparmor.d/usr.bin.msmtp
    sudo apparmor_parser -r /etc/apparmor.d/usr.bin.msmtp 2>/dev/null || true
    #sudo systemctl restart apparmor
    sudo systemctl reload apparmor
fi

# -rwx------ 1 forester forester 2219 Feb 13 17:41 /home/forester/get_mail_secret.py
# -rw------- 1 forester forester 664 Feb 13 17:39 /home/forester/.msmtprc

echo ""
echo "Now you need to run 'sync_mail' to initialize everything..."
echo ""
echo ""
echo "======================================================="
echo "YOUR WORKFLOW"
echo "======================================================="
echo ""
echo "Sync email            : sync_mail"
echo "Read/Write messages   : neomutt"
echo ""
echo "The intended workflow is that syncinc of the email is done via an"
echo "external script, so it's easier to control. Assumption is made that"
echo "the machine would not be connected to internet all the time OR"
echo "even if it is, I want to run it all minimalistic, so I would sync"
echo "the email only when I want to, similar to updating the whole system"
echo "'apt upgrade' only when I want to."
echo ""
echo "This is also a reverance to the good old DOS days of the dial-up"
echo "when we would have connection only at a certain time, not constantly."
echo ""
echo "So again - you should run the script when you WANT to get new"
echo "inbound mail or send your outbound messages."
echo ""
echo "In every other moment you can run 'neomutt' to read/write messages"
echo "or just hang around."
echo ""
echo "And after all if you want some automation - you can always put"
echo "'sync_mail' in a cron job, so I am not limiting you in any way."
echo ""
echo "You might want to edit ~/.neomutt_signature which now is your"
echo "email signature file."
echo ""
echo ""
echo "OAUTH2 EMAIL TOOLS INSTALLED."
