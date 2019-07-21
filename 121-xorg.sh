#!/bin/bash
##
# Install and set up xorg-server
##

# bail out on error
set -e

# defaults


usage() {
    echo -e "Usage: $1 [-h]"
}

install() {
    PKGS="xorg-server"
    pacman -Syq --needed --noconfirm $PKGS
}

configure_static() {
    cat << EOF > /etc/X11/xorg.conf.d/10-keyboard.conf
Section "InputClass"
	Identifier "system-keyboard"
	MatchIsKeyboard "on"
	Option "XkbLayout" "de"
	Option "XkbModel" "pc105"
	Option "XkbOptions" "compose:prsc"
EndSection
EOF
}

configure_dynamic() {
    cat << EOF > /etc/X11/xinit/xinitrc.d/10-keyboard.sh
#!/bin/sh
# set keyboard layout to german
setxkbmap -model pc105 -layout de -option compose:prsc
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
    echo -e "ERROR: Too many arguments."
    usage $0
    exit 1
fi
set -- "${POSARGS[@]}"

# main program
install
