#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

# Debugging
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND"; exit 130' INT

echo ""
echo "INSTALLING ADDITIONAL KEYBOARD LAYOUTS..."
echo ""

# This will install the Bulgarian and Russian phonetic layouts
# and will make them switchable with LEFTALT+LEFTSHIFT keys
if ! grep -q "bg,ru" /etc/default/keyboard; then
    sudo sed -i 's/XKBLAYOUT="\(.*\)"/XKBLAYOUT="\1,bg,ru"/' /etc/default/keyboard
    sudo sed -i 's/XKBVARIANT="\(.*\)"/XKBVARIANT="\1,phonetic,phonetic"/' /etc/default/keyboard
fi
sudo sed -i 's/XKBOPTIONS=.*/XKBOPTIONS="grp:lalt_lshift_toggle"/' /etc/default/keyboard

### Automatically set the a font with proper Cyrillic support
# I choose CODESET="Uni3", but "Combined" is safer
# sudo cat <<EOF > /etc/default/console-setup
cat <<EOF | sudo tee /etc/default/console-setup > /dev/null
ACTIVE_CONSOLES="/dev/tty[1-6]"
CHARMAP="UTF-8"
CODESET="Combined"
FONTFACE="TerminusBold"
FONTSIZE="12x24"
VIDEOMODE=
EOF

# Force Initramfs to include the Framebuffer and Console Setup
echo "FRAMEBUFFER=y" | sudo tee /etc/initramfs-tools/conf.d/framebuffer > /dev/null

# Prepare the system for the changes
sudo systemctl enable console-setup
sudo rm -f /etc/console-setup/cached_setup_font.sh

# This generates the cached font/keyboard files that initramfs-tools looks for
sudo setupcon --save-only

# Apply changes to the boot image
sudo udevadm trigger --subsystem-match=input --action=change || true

# Rebuild the initrd image to bake in the font and layouts
echo "Updating initramfs..."
sudo update-initramfs -u



# IMPORTANT:
# In order for the Cyrillic characters to be visualized properly on the
# terminal, you must select the proper terminal font:
# dpkg-reconfigure console-setup
# and select these in sequence: encoding, character set, font, font size

# So these charsets would work great:
# #Cyrillic - Slavic languages (also Bosnian and Serbian latin) (Uni3)
# OR
# .Combined - Latin; Slavic and non-Slavic Cyrillic

# Please note the "#" and the "." signs in front of the selected charsets

# For a font I personally select TerminusBold 12x24 (framebuffer-only)

echo ""
echo "KEYBOARD LAYOUTS INSTALLED."
