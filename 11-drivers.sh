#!/bin/bash
##
# Run all 11x driver install scripts
##

# bail out on error
set -e

# change to directory containing the relevant scripts
OLD_DIR=$(pwd)
cd ./11/

#Usage: 111-intel.sh [-h] [OPTIONS]
#OPTIONS:
#	--vulkan	install vulkan-intel drivers
#	--32-bit	install lib32-mesa drivers
#	--skylake	enable GuC/HuC firmware loading
bash 111-intel.sh --vulkan --skylake

#Usage: 112-filesystem.sh [-h]
bash 112-filesystem.sh

# change back to old directory
cd $OLD_DIR
