#!/bin/bash
##
# Setup host info and vconsole settings
##

set -e

# defaults
HNAME="darkstar"
CONF=false
CKMAP="us"
CFONT="default8x16"
EIP="127.0.1.1"

usage() {
   echo -e "Usage: $1 [-h] [OPTIONS] [HOSTNAME]"
   echo -e "ARGUMENTS:"
   echo -e "\tHOSTNAME\thostname for the system"
   echo -e "OPTIONS:"
   echo -e "\t--ext-ip IP\tmachines permanent ip adress"
   echo -e "\t--keymap KM\tkeymap as found under /usr/share/kbd/keymaps/**/*.map.gz"
   echo -e "\t--font FNT\tfont as found under /usr/share/kbd/consolefonts/*.psfu?.gz"
}

set_hostname() {
    # 1: Hostname

    echo "$1" > /etc/hostname
}

set_hosts() {
    # 1: Hostname
    # 2: External IP

    cat << EOF > /etc/hosts
#IP-------------HOSTNAME----------------ALIASES-
127.0.0.1	localhost
$2	$1

::1	localhost
EOF
}

set_vconsole() {
    # 1: Keymap as found under /usr/share/kbd/keymaps/**/*.map.gz
    # 2: Font as found under /usr/share/kbd/consolefonts/

    cat << EOF > /etc/vconsole.conf
KEYMAP=$1
FONT=$2
EOF
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
        --ext-ip)
            EIP="$2"
            shift
            shift
            ;;
        --ext-ip=*)
            EIP="${1#*=}"
            shift
            ;;
        --keymap)
            CONF=true
            CKMAP="$2"
            shift
            shift
            ;;
        --keymap=*)
            CONF=true
            CKMAP="${1#*=}"
            shift
            ;;
        --font)
            CONF=true
            CFONT="$2"
            shift
            shift
            ;;
        --font=*)
            CONF=true
            CFONT="${1#*=}"
            shift
            ;;
        -*|--*)
            echo -e "ERROR: Illegal option: $key"
            usage $0
            exit 1
            ;;
        *)
            POSARGS+=("$1")
            shift
            ;;
    esac
done

# check positional args
if [[ ${#POSARGS[@]} -gt 1 ]]; then
    echo -e "ERROR: Too many arguments."
    usage $0
    exit 1
fi
set -- "${POSARGS[@]}"
if [[ -n $1 ]]; then
    HNAME="$1"
fi

set_hostname $HNAME
set_hosts $HNAME $EIP
$CONF && set_vconsole $CKMAP $CFONT

