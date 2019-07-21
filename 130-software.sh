#!/bin/bash
##
# Install user software
##

# bail out on error
set -e

# Package list
PKGS="htop firefox"

# installation
pacman -Syq --needed --noconfirm $PKGS
