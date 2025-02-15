#!/usr/bin/env sh

HOME_FOLDER="$HOME"
INSTALL_FOLDER="install"
emacs_version=29
emacs_dl="https://github.com/emacs-mirror/emacs.git"
kitty_dl="https://github.com/kovidgoyal/kitty"
zsh_dl=""
omz_dl="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
p10k_dl="https://github.com/romkatv/powerlevel10k.git"
doom_dl="https://github.com/doomemacs/doomemacs"
picom_dl="https://github.com/yshui/picom.git"
i3_dl="https://github.com/i3/i3/archive/refs/tags/4.24.zip"
rofi_dl="https://github.com/davatorium/rofi/releases/download/1.7.8/rofi-1.7.8.tar.gz"
polybar_dl=""

# If a package depends on another one, put it lower in the list so the dependency is process before.
# e.g : doom depends on emacs -> put doom lower than emacs
OPTION_LIST="
emacs Emacs$emacs_version on
kitty Kitty on
zsh Zsh on
omz OhMyZsh! on
doom DoomEmacs on
picom Picom on
i3 i3 on
rofi Rofi on
polybar Polybar on
"

sudo apt update
if ! command -v dialog &>/dev/null ; then
    echo "Installing dialog"
    sudo apt install dialog -y
fi

NPM_DEP=
PIP_DEP=
APT_DEP=
MAN_DEP=

add_apt_dep() {
    if [ -z "$APT_DEP" ]
    then
        APT_DEP="$1"
    else
        APT_DEP="$APT_DEP $1"
    fi
}

add_npm_dep() {
    if [ -z "$NPM_DEP" ]
    then
        NPM_DEP="$1"
    else
        NPM_DEP="$NPM_DEP $1"
    fi
}

add_pip_dep() {
    if [ -z "$PIP_DEP" ]
    then
        PIP_DEP="$1"
    else
        PIP_DEP="$PIP_DEP $1"
    fi
}

add_man_dep() {
    if [ -z "$MAN_DEP" ]
    then
        MAN_DEP="$1"
    else
        MAN_DEP="$MAN_DEP $1"
    fi
}

dep_emacs () {
    add_apt_dep "git libacl1-dev build-essential autoconf texinfo libgtk-3-dev libwebkit2gtk-4.0-dev libgccjit-12-dev libxpm-dev libgif-dev libgnutls28-dev libjansson-dev libncurses-dev libsystemd-dev libtree-sitter-dev libmagickcore-dev libmagick++-dev libmagickwand-dev"
}

emacs () {
    echo "Building Emacs $emacs_version"
    git clone "$emacs_dl" emacs
    cd emacs || exit 1
    git switch "emacs-$emacs_version"
    chmod +x autogen.sh
    ./autogen.sh
    ./configure --with-cairo --with-xwidgets --with-x-toolkit=gtk3 --with-native-compilation --with-mailutils  --with-json --with-png --with-jpeg --with-modules --with-gnutls --with-imagemagick
    make -j$(nproc)
    sudo make install
    cd ../ || exit 1
}

dep_doom () {
    add_apt_dep "git ripgrep fd-find glslang-tools default-jre default-jdk graphviz isort pipenv shellcheck tidy libvterm-dev"
    add_npm_dep "marked markdownlint stylelint js-beautify"
    add_pip_dep "nose pytest pyright"
}

doom () {
    echo "Building Doom Emacs"
    rm -rf "$HOME/.emacs.d/"
    mkdir -p -- "$HOME/org/roam"
    git clone --depth 1 "$doom_dl" "$HOME/.config/emacs"
    "$HOME/.config/emacs/bin/doom/install" --env
}

dep_kitty () {
    add_apt_dep "git libxkbcommon-x11-dev libx11-xcb-dev libdbus-1-dev libxcursor-dev libxrandr-dev libxi-dev libxinerama-dev libgl1-mesa-dev libfontconfig-dev liblcms2-dev libssl-dev libpython3-dev librsync-dev libxxhash-dev libsimde-dev"
    add_man_dep "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/NerdFontsSymbolsOnly.zip"
}

kitty () {
    wget -O go.tar.gz https://go.dev/dl/go1.24.0.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go.tar.gz
    export PATH=$PATH:/usr/local/go/bin

    echo "Building Kitty"
    git clone "$kitty_dl" kitty
    cd kitty || exit 1
    make -j$(nproc)
    sudo ln -s kitty/launcher/kitty /usr/bin/
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/kitty 50
    sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty
    cd ../ || exit 1
}

dep_zsh () {
    add_apt_dep ""
}

zsh () {
    echo "Building zsh"
    sudo apt install zsh -y
}

dep_omz () {
    add_apt_dep "git neofetch"
    add_man_dep "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
"
}

omz () {
    echo "Building Oh My Zsh!"
    sh -c "$(wget -O- "$omz_dl")"
    git clone --depth=1 "$p10k_dl" ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    ln -s "$HOME/.config/.zshrc" "$HOME/.zshrc"
}

dep_picom () {
    add_apt_dep "git meson libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-dpms0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev libxext-dev meson ninja-build uthash-dev"
}

picom () {
    echo "Building Picom"
    git clone "$picom_dl" picom
    cd picom || exit 1
    meson setup --buildtype=release build
    ninja -C build install
    cd .. || exit 1
}

dep_i3 () {
    add_apt_dep "unzip dh-autoreconf libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev xcb libxcb1-dev libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev libxcb-xinerama0-dev libxkbcommon-x11-dev libstartup-notification0-dev libxcb-randr0-dev libxcb-xrm0 libxcb-xrm-dev libxcb-shape0 libxcb-shape0-dev i3lock feh"
}

i3 () {
    echo "Building i3"
    wget -O i3.zip -- "$i3_dl"
    unzip i3.zip -d i3
    cd i3 || exit 1
    meson setup --buildtype=release build
    ninja -C build install
    cd .. || exit 1
}

dep_rofi () {
    add_apt_dep "unzip flex bison libxcb-ewmh-dev check"
}

rofi () {
    echo "Building Rofi"
    wget -O rofi.tar.gz -- "$rofi_dl"
    mkdir rofi && tar xf rofi.tar.gz --strip-components=1 -C rofi
    mkdir rofi/build
    cd rofi/build || exit 1
    ../configure
    make -j$(nproc)
    sudo make install
    cd ../.. || exit 1
}

dep_polybar () {
    add_apt_dep "flameshot"
    add_man_dep "https://fontawesome.com/v6/docs/desktop/
https://fontawesome.com/v5/docs/desktop/"
}

polybar () {
    echo "Building Polybar"
    sudo apt install polybar -y
}


exec 3>&1;
result=$(dialog --checklist "Select features to install" 50 120 45 $OPTION_LIST 2>&1 1>&3);
exitcode=$?;
exec 3>&-;

if [ "$exitcode" -ne "0" ]; then
    echo "Aborting"
    exit "$exitcode"
fi


for tag in $result
do
    "dep_$tag"
done


if [ -n "$NPM_DEP" ]; then
    add_apt_dep "npm"
fi

if [ -n "$PIP_DEP" ]; then
    add_apt_dep "python3-pip"
fi


echo "Manually install these. Press enter when you're done. (ignore this step with '--skip-manual')"
echo "$MAN_DEP"
read -r ignore

sudo apt -qq install -y -- $APT_DEP
sudo npm i -g $NPM_DEP

sudo rm -f /usr/lib/python3.*/EXTERNALLY-MANAGED 2>/dev/null
sudo pip3 install $PIP_DEP # venv ? uh

mkdir -p -- "$HOME_FOLDER/$INSTALL_FOLDER"
echo "Entering $HOME_FOLDER/$INSTALL_FOLDER folder"
cd "$HOME_FOLDER/$INSTALL_FOLDER" || exit 1

for tag in $result
do
    "$tag"
done
