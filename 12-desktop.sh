#!/bin/bash
##
# Run all 12x desktop install scripts
##

# bail out on error
set -e

# change to directory containing the relevant scripts
OLD_DIR=$(pwd)
cd ./12/

#Usage: 121-xorg.sh [-h]
#bash 121-xorg.sh

#Usage: 122-sway.sh [-h]
bash 122-sway.sh

# change back to old directory
cd $OLD_DIR

