#!/bin/bash

# $1 = device node (e.g., /dev/sda1)

DEV="$1"
MOUNT_BASE="/media"
LABEL=$(blkid -o value -s LABEL "$DEV")
if [ -z "$LABEL" ]; then
    LABEL=$(basename "$DEV")   # fallback if no label
fi

MOUNT_POINT="$MOUNT_BASE/$LABEL"

# Create mount point if it doesn't exist
mkdir -p "$MOUNT_POINT"

# Mount the device (read/write, no auto options)
mount "$DEV" "$MOUNT_POINT"

if [ $? -eq 0 ]; then
    # Print message to all terminals
    echo "USB device $DEV mounted at $MOUNT_POINT" | wall
fi
