#!/bin/bash
##
# Setting timezone and hwclock for ArchLinux
##

set -e

# defaults
TIMEZONE='UTC'
WINDBOOT=false

usage() {
    echo -e "Usage: $1 [-h] [OPTIONS]"
    echo -e "OPTIONS:"
    echo -e "\t--winboot\tSet hwclock with '--localtime' flag (Useful when dual booting with Windows)"
    echo -e "\t--timezone TZ\tSet time zone to TZ (relative path from /usr/share/zoneinfo, eg. Europe/Berlin)"
}

set_timezone() {
    # 1: zoneinfo-path Timezone

    ln -sf /usr/share/zoneinfo/$1 /etc/localtime
}

set_hwclock() {
    # 1: localtime bool-flag

    FLAGS='--systohc'
    if $1; then
        FLAGS+=' --localtime'
    fi

    hwclock $FLAGS
}

# parse args
POSARGS=()
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -h|--help)
            usage $0
            exit 0
            ;;
        --timezone)
            TIMEZONE="$2"
            shift
            shift
            ;;
        --timezone=*)
            TIMEZONE="${1#*=}"
            shift
            ;;
        --winboot)
            WINBOOT=true
            shift
            ;;
        *)
            echo -e "ERROR: Illegal option/argument: $key"
            exit 1
            ;;
    esac
done

# main program
set_timezone $TIMEZONE
set_hwclock $WINDBOOT

