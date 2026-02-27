#!/bin/bash

# Preventing race condition
LOCKFILE="/tmp/mailsync.lock"

# Use 'flock' to grab an exclusive lock.
# -n: Fail immediately if another instance is running (don't wait)
# -e: Exclusive lock
exec 200>$LOCKFILE
flock -n 200 || { echo "Mailsync is already running in another terminal."; exit 1; }

# EVERYTHING BELOW RUNS ONLY IF WE HAVE THE LOCK


# Deleting any existing lock file from a previous problematic
# run of offlineimap only if offlineimap is not running
if ! pgrep -x "offlineimap" > /dev/null; then
    rm -f ~/.offlineimap/*.lock
fi

QUEUEDIR="$HOME/.msmtpqueue"
export EMAIL_CONN_TEST=p

echo "Mail Sync Started: $(date)"
echo "--------------------------------"

# Flush Outbound Mail
export MSMTPQ_DIR="$HOME/.msmtp.queue"
export PATH="/usr/libexec/msmtp/msmtpq:$PATH"

# IMPORTANT: Ensure GPG can talk to your terminal for the password
export GPG_TTY=$(tty)

echo "Syncing outbound mail..."

if ls "$MSMTPQ_DIR"/*.msmtp >/dev/null 2>&1; then
    # We use a subshell to ensure msmtp-queue sees everything it needs
    # We also explicitly point to your msmtprc
    msmtp-queue -r -- -C "$HOME/.msmtprc"
    
    if [ $? -eq 0 ]; then
        echo "Outbound sync complete."
    else
        echo "Error: msmtp failed (Exit Code 78 usually means authentication/config error)."
        echo "Check if your GPG agent is running: gpg-connect-agent /bye"
    fi
else
    echo "No outbound mail to send."
fi

echo "--------------------------------"

# Pull Inbound Mail
echo "Downloading new messages via OfflineIMAP..."
# -o runs it once and exits (no background daemon)
# -u basic provides clean output for your terminal
offlineimap -o -u basic -c "$HOME/.offlineimaprc"

if [ $? -eq 0 ]; then
    echo "Inbound sync complete."
else
    echo "OfflineIMAP encountered an error."
fi

echo "--------------------------------"
echo "Mail Sync Finished."

