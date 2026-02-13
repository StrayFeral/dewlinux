#!/bin/bash

# 1. Define the queue directory (must match your msmtpq setup)
# QUEUEDIR="~/.msmtpqueue"
QUEUEDIR="$HOME/.msmtpqueue"

echo "Mail Sync Started: $(date)"
echo "--------------------------------"

# 2. Flush Outbound Mail
if [ -n "$(ls -A "$QUEUEDIR" 2>/dev/null)" ]; then
    echo "Sending queued outbound messages..."
    # msmtp-flush is a wrapper that sends everything in the queue
    msmtp-flush
    if [ $? -eq 0 ]; then
        echo "Outbound sync complete."
    else
        echo "Error sending mail. Check internet connection."
        exit 1
    fi
else
    echo "No outbound mail to send."
fi

echo "--------------------------------"

# 3. Pull Inbound Mail
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

