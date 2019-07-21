#!/bin/bash
##
# Run all 11x driver install scripts
##

# bail out on error
set -e

#Usage: 111-intel.sh [-h] [OPTIONS]
#OPTIONS:
#	--vulkan	install vulkan-intel drivers
#	--32-bit	install lib32-mesa drivers
#	--skylake	enable GuC/HuC firmware loading
bash 111-intel.sh --vulkan --skylake

#Usage: 112-filesystem.sh [-h]
bash 112-filesystem.sh
