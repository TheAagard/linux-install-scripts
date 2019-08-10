#!/bin/bash
##
# Install and set up intel drivers
##

set -e

# defaults
VULKAN=false
BIT32=false
SKYLAKEP=false

usage() {
    echo -e "Usage: $1 [-h] [OPTIONS]"
    echo -e "OPTIONS:"
    echo -e "\t--vulkan\tinstall vulkan-intel drivers"
    echo -e "\t--32-bit\tinstall lib32-mesa drivers"
    echo -e "\t--skylake\tenable GuC/HuC firmware loading"
}

install() {
    # 1: vulkan-intel driver bool-flag
    # 2: lib32-mesa driver bool-flag

    PKGS="mesa"
    if $2; then
        PKGS+=" lib32-mesa"
    fi
    if $1; then
        PKGS+=" vulkan-intel"
    fi

    pacman -Syq --needed --noconfirm $PKGS
}

set_kms() {
    MODULES=$(grep -w "^MODULES" /etc/mkinitcpio.conf | sed -e "s/MODULES=(\([^)]*\))/\1/")
    if [[ -n "$MODULES" ]]; then
        MODULES+=" "
    fi
    for MODULE in $MODULES; do
        if [[ "i915" == $MODULE ]]; then
            #echo "No changes neccessary"
            exit 0
        fi
    done
    MODULES+="i915"
    sed -i -e "/^MODULES/ s/(.*)/(${MODULES})/" /etc/mkinitcpio.conf
}

set_GuC_HuC() {
    INS="options i915 enable_guc"
    if [[ ! $(grep -irw "$INS" /etc/modprobe.d/*.conf) ]]; then
        echo "$INS=2" >> /etc/modprobe.d/i915.conf
    fi
}

# parse args
POSAGRS=()
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -h|--help)
            usage $0
            exit 0
            ;;
        --32-bit)
            BIT32=true
            shift
            ;;
        --vulkan)
            VULKAN=true
            shift
            ;;
        --skylake)
            SKYLAKE=true
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
if [[ ${#POSARGS[@]} -gt 0 ]]; then
    echo -e "ERROR: Too many arguments"
    usage $0
    exit 1
fi
set -- "${POSARGS[@]}"

# main program
install $VULKAN $BIT32
set_kms
$SKYLAKEP && set_GuC_HuC
