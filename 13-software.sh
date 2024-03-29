#!/bin/bash
##
# Install user software
##

# bail out on error
set -e

# Package list
SYSTM="light pulseaudio pulseaudio-alsa xdg"
DEVEL="gcc go python rust"
WAYLT="grim slurp wl-clipboard"
XORGT="xclip"
TOOLS="htop ranger"
INETS="firefox"
MEDIA="vlc"

PKGS="$SYSTM"
if $DEVELOP; then
    PKGS+=" $DEVEL"
fi
if $WAYLAND; then
    PKGS+=" $WAYLT"
fi
PKGS+=" $TOOLS $INETS $MEDIA"

# installation
pacman -Syq --needed --noconfirm $PKGS
