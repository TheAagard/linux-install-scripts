#!/bin/bash
##
# Generating and setting locales under ArchLinux
##

set -e

# defaults
CONF=true
LOCS="en_US"
LING=""
FROM=""

usage() {
    echo -e "Usage: $1 [-h] [OPTIONS] [LOCALES]"
    echo -e "ARGUMENTS:"
    echo -e "\tLOCALES\tcomma-separated list of locales"
    echo -e "OPTIONS:"
    echo -e "\t--lang LOCALE\tsystem and message languages"
    echo -e "\t--form LOCALE\tformatting"
}

generate_locales() {
    # 1: CSV of locales

    # reset locale.gen
    sed -i -e '/^#/! s/\(.*\)/#\1/' /etc/locale.gen

    # separate CSV and uncomment locales
    IFS=',;'
    for loc in $1; do
        sed -i -e "/^#$loc/ s/#//" /etc/locale.gen
    done
    
    if [[ -z "$LING" ]]; then
        LING=$(echo $1 | cut -d ' ' -f 1)
    fi
    if [[ -z "$FORM" ]]; then
        FORM=$(echo $1 | cut -d ' ' -f 1)
    fi

    # generate locales
    locale-gen
}

#TODO: fix incomplete locale strings
write_locale_conf() {
    # 1: System language
    # 2: Formatting

    cat << EOF > /etc/locale.conf
LANG=$1
LC_CTYPE="$1"
LC_NUMERIC="$2"
LC_TIME="$2"
LC_COLLATE="$1"
LC_MONETARY="$2"
LC_MESSAGES="$1"
LC_PAPER="$2"
LC_NAME="$2"
LC_ADDRESS="$2"
LC_TELEPHONE="$2"
LC_MEASUREMENT="$2"
LC_IDENTIFICATION="$2"
LC_ALL=
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
        --lang)
            LING="$2"
            CONF=true
            shift
            shift
            ;;
        --lang=*)
            LING="${1#*=}"
            CONF=true
            shift
            ;;
        --form)
            FORM="$2"
            CONF=true
            shift
            shift
            ;;
        --form=*)
            FORM="${1#*=}"
            CONF=true
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
    echo -e "ERROR: Too many arguments"
    usage $0
    exit 1
fi
set -- "${POSARGS[@]}"
if [[ -n $1 ]]; then
    LOCS=$1
fi

# main program
generate_locales $LOCS
$CONF && write_locale_conf $LING $FORM

