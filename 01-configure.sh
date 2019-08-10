#!/bin/bash
##
# Run all 01x system install scripts
##

# bail out on error
set -e

# change to directory containing the relevant scripts
OLD_DIR=$(pwd)
cd ./01/

#Usage: 011-time.sh [-h] [OPTIONS]
#OPTIONS:
#	--winboot	Set hwclock with '--localtime' flag (Useful when dual booting with Windows)
#	--timezone TZ	Set time zone to TZ (relative path from /usr/share/zoneinfo, eg. Europe/Berlin)
echo "Setting up time..."
bash 011-time.sh --winboot --timezone Europe/Berlin


#Usage: 012-locale.sh [-h] [OPTIONS] [LOCALES]
#ARGUMENTS:
#	LOCALES	comma-separated list of locales
#OPTIONS:
#	--lang LOCALE	system and message languages
#	--form LOCALE	formatting
echo "Setting up locale..."
bash 012-locale.sh --lang en_US.UTF-8 --form de_DE.UTF-8 en_US,de_DE


#Usage: 013-host.sh [-h] [OPTIONS] [HOSTNAME]
#ARGUMENTS:
#	HOSTNAME	hostname for the system
#OPTIONS:
#	--ext-ip IP	machines permanent ip adress
#	--keymap KM	keymap as found under /usr/share/kbd/keymaps/**/*.map.gz
#	--font FNT	font as found under /usr/share/kbd/consolefonts/*.psfu?.gz
echo "Setting up host..."
bash 013-host.sh --keymap de-latin1-nodeadkeys --font Lat2-Terminus16

# change back to old directory
cd $OLD_DIR

