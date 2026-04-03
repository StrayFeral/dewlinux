#!/bin/bash

# Keywords for GUI / X / Desktop packages
keywords='xserver|xorg|x11|gnome|kde|xfce|lxde|mate|cinnamon|gtk|qt|xterm|xinit|lightdm|gdm|sddm'

echo "Scanning for installed GUI / X / Desktop components..."

# Search installed packages
installed=$(dpkg -l | awk '{print $2}' | grep -E "$keywords")

if [ -z "$installed" ]; then
    echo "No GUI/X packages detected. System is terminal-only."
else
    echo "Found GUI/X packages installed:"
    echo "$installed"
fi

# Optional: check for X binaries
echo
echo "Checking for GUI/X binaries in PATH..."
for bin in X xterm startx gnome-session startkde startxfce4; do
    if command -v "$bin" &>/dev/null; then
        echo " - $bin"
    fi
done

# Optional: check for DISPLAY variable (running GUI session)
if [ -n "$DISPLAY" ]; then
    echo
    echo "GUI session detected (DISPLAY=$DISPLAY)"
else
    echo
    echo "No GUI session currently running."
fi

