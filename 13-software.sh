#!/bin/bash
##
# Install user software
##

# bail out on error
set -e

# Package list
SYSTM="light pulseaudio pulseaudio-alsa"
WAYLT="grim slurp wl-clipboard"
XORGT="xclip"
TOOLS="htop ranger"
INETS="firefox"

PKGS="$SYSTM"
if $WAYLAND; then
    PKGS+=" $WAYLT"
fi
PKGS+=" $TOOLS $INETS"

# installation
pacman -Syq --needed --noconfirm $PKGS
