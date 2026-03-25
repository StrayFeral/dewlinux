#!/bin/bash

DEV="/dev/$1"

sleep 2

# Mount device
OUTPUT=$(udisksctl mount -b "$DEV" 2>/dev/null)

# Extract mount point
MOUNT_POINT=$(echo "$OUTPUT" | sed -n 's/.* at \(.*\)\.$/\1/p')

[ -z "$MOUNT_POINT" ] && exit 0

# Send message to all active terminals
while read user tty rest; do
    [ -z "$tty" ] && continue
    echo "New device is now connected as '$MOUNT_POINT'" > "/dev/$tty"
done < <(who)
