#!/bin/bash

# 1. Get all lines from 'mount' that belong to the current user
# We filter for /dev/sd to ensure we are looking at physical drives
MOUNT_DATA=$(mount | grep "/media/$USER/" | grep "/dev/sd")

if [ -z "$MOUNT_DATA" ]; then
    echo "No mounted USB partitions found for user $USER."
    exit 0
fi

echo "Currently Mounted USB Devices:"
echo "------------------------------"

# 2. Parse the mount data into a menu
IFS=$'\n'
count=1
declare -A dev_map

for line in $MOUNT_DATA; do
    # Extract the device (e.g., /dev/sda1) - first word
    DEV=$(echo "$line" | awk '{print $1}')
    
    # Extract the mount point (e.g., /media/forester/KINGSTON) - third word
    MNT=$(echo "$line" | awk '{print $3}')
    
    # Get the size and label from lsblk for a prettier display
    INFO=$(lsblk -dno SIZE,LABEL "$DEV" | xargs)
    
    echo "$count) $DEV ($INFO) mounted at $MNT"
    
    # Store the device for the unmount command
    dev_map[$count]="$DEV"
    
    ((count++))
done

echo "------------------------------"
read -p "Enter the number to unmount (or 'q' to quit): " choice

if [[ "$choice" == "q" || -z "$choice" ]]; then
    exit 0
fi

SELECTED_DEV=${dev_map[$choice]}

if [ -z "$SELECTED_DEV" ]; then
    echo "Invalid selection."
    exit 1
fi

# 3. Perform the unmount
echo "Unmounting $SELECTED_DEV..."
udisksctl unmount -b "$SELECTED_DEV"

if [ $? -eq 0 ]; then
    echo "Success! The directory has been removed and the device is safe."
else
    echo "Error: Could not unmount $SELECTED_DEV."
fi

