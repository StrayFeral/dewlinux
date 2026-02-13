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

echo "**** WORK IN PROGRESS ******"
echo ""

#read -p "Enter Age: " age

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
cp configs/gmail/.offlineimaprc ~/
cp scripts/.offlineimap.py ~/

# Generate a key
echo "Choose RSA type of key, 4096 size, 'never expire', then type 'y' and ENTER:"
gpg --full-generate-key

# Initialize the password store
export public_key=$(gpg --list-secret-keys --keyid-format LONG | grep sec | cut -d'/' -f2 | cut -d' ' -f1)
pass init "$public_key"
#pass insert gmail/accpass

# If you don't want to type passwords in the middle of neomutt session
# you should install pinentry-tty or pinentry-curses
# echo "pinentry-program /usr/bin/pinentry-curses" >> ~/.gnupg/gpg-agent.conf
# however this is out of the scope of the current script as we would
# sync it all with an external script

# Get the refresh token
python3 scripts/gmail_config.py


#auth oauthbearer
#passwordeval python3 ~/bin/dew-token.py




#~ TEST
#~ ===========

#~ echo "Subject: DEW Test" | msmtpq ridge.forester.one@gmail.com

#~ ls ~/.msmtpqueue
#~ # (You should see two files: a .mail file and a .msmtp file).

#~ # SYNC:
#~ ~/bin/dew-sync.sh

#~ # IF msmtpq script is missing, get it here:
#~ # https://www.google.com/search?q=https://github.com/marlam/msmtp/blob/master/scripts/msmtpq/msmtpq

# Test we can get the temp.access.token:
# python3 get_temp_acc_token.py



#~ Troubleshooting the "Sent" Folder
#~ Gmail is smart/annoying: when you send a mail via SMTP, Gmail automatically puts a copy in your [Gmail]/Sent Mail folder.

#~ If you find duplicate "Sent" messages in NeoMutt, comment out set record = "+/[Gmail]/Sent Mail" in your config.

#~ If you want to keep a local-only copy for true offline work, keep it on.





echo ""
echo "GMAIL EMAIL TOOLS INSTALLED."
