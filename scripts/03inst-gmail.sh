#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

# Debugging
# trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND" >&2' ERR
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND"; exit 130' INT

echo ""
echo "INSTALLING GMAIL EMAIL TOOLS..."
echo ""
echo "On the 'Enable AppArmor' question just say 'Yes'..."
echo ""

echo "FIRST BE SURE YOU DID THE GCP APP SETUP!"
echo "IF NOT - PRESS CTRL-C NOW and go and do the setup."
echo ""
read -p "Press [ENTER] to resume ..."

sudo apt update
sudo apt -y install neomutt offlineimap msmtp msmtp-mta python3 python3-requests gnupg pass

mkdir -p ~/.mail/gmail ~/.msmtpqueue

cp configs/gmail/.msmtprc ~/
chmod 600 ~/.msmtprc
cp configs/gmail/.neomuttrc ~/
cp scripts/mailhelper.py ~/

# Generate a key
echo "Choose RSA type of key, 4096 size, 'never expire', then type 'y' and ENTER:"
gpg --full-generate-key

# Initialize the password store
export public_key=$(gpg --list-secret-keys --keyid-format LONG | grep sec | cut -d'/' -f2 | cut -d' ' -f1)
pass init "$public_key"

# If you don't want to type passwords in the middle of neomutt session
# you should install pinentry-tty or pinentry-curses
# echo "pinentry-program /usr/bin/pinentry-curses" >> ~/.gnupg/gpg-agent.conf
# however this is out of the scope of the current script as we would
# sync it all with an external script

# Get the refresh token
python3 scripts/gmail_config.py

# For some weird reason this file normally would get truncated and
# this will break the whole config. So I am copying at the very end
cp configs/gmail/.offlineimaprc ~/

echo ""
read -p "Enter your NAME (to use in FROM): " realname
read -p "Enter your FULL GMail email address: " emailaddr

sed -i "s|YOURLINUXUSERNAMEHERE|$USER|g" ~/.offlineimaprc
sed -i "s|YOURGMAILEMAILHERE|$emailaddr|g" ~/.offlineimaprc

sed -i "s|YOURLINUXUSERNAMEHERE|$USER|g" ~/.msmtprc
sed -i "s|YOURGMAILEMAILHERE|$emailaddr|g" ~/.msmtprc

sed -i "s|YOURGMAILEMAILHERE|$emailaddr|g" ~/.neomuttrc
sed -i "s|YOURNAMEHERE|$realname|g" ~/.neomuttrc


chmod 700 ~/mailhelper.py
sudo cp configs/gmail/usr.bin.msmtp /etc/apparmor.d/
sudo chmod 644 /etc/apparmor.d/usr.bin.msmtp
sudo apparmor_parser -r /etc/apparmor.d/usr.bin.msmtp
sudo systemctl restart apparmor

# -rwx------ 1 forester forester 2219 Feb 13 17:41 /home/forester/mailhelper.py
# -rw------- 1 forester forester 664 Feb 13 17:39 /home/forester/.msmtprc

echo ""
echo "GMAIL EMAIL TOOLS INSTALLED."
echo ""
echo "Now you need to run './sync_mail.sh' to initialize everything..."
echo ""
echo ""
echo "======================================================="
echo "YOUR WORKFLOW"
echo "======================================================="
echo ""
echo "Sync email            : ./sync_mail.sh"
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
echo "'sync_mail.sh' in a cron job, so I am not limiting you in any way."
echo ""
