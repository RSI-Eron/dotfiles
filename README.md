# Installation

## Clone du repo
```
cd ~/.config
git init .
git remote add origin git@github.com:RSI-Eron/dotfiles.git # Ou le lien HTTP
git fetch
```


# Idées
Mettre en variable $HOME/.config


# ---------------------------------

# Packages

## Emacs

### Dependencies (installable via 'apt install <name>' ou 'apt build-dep emacs')
build-essential
autoconf
texinfo
libgtk-3-dev
libwebkit2gtk-4.0-dev
libgccjit-12-dev
libxpm-dev
libgif-dev
libgnutls28-dev
libjansson-dev
libncurses-dev
libsystemd-dev
libtree-sitter-dev
libmagickcore-dev
libmagick++-dev
libmagickwand-dev

### Commands

git clone git@github.com:emacs-mirror/emacs.git
git switch emacs-29 # Ou plus recent
cd emacs
./autogen.sh
./configure --with-cairo --with-xwidgets --with-x-toolkit=gtk3 --with-native-compilation --with-mailutils  --with-json --with-png --with-jpeg --with-modules --with-gnutls --with-imagemagick
make -j$(nproc)
sudo make install




## Doom

A faire apres zsh et emacs :)


### Dependencies
ripgrep
fd-find
glslang-tools
default-jre
default-jdk
graphviz
isort
pipenv
shellcheck
tidy
libvterm-dev


### NPM dependecies
marked
markdownlint
stylelint
js-beautify

### Pip dependencies
nose
pytest

### Commands
rm -rf ~/.emacs.d/
mkdir -p -- "$HOME/org/roam"
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom/install --env




## Kitty

### Dependencies
libxkbcommon-x11-dev
libx11-xcb-dev
libdbus-1-dev
libxcursor-dev
libxrandr-dev
libxi-dev
libxinerama-dev
libgl1-mesa-dev
libfontconfig-dev
liblcms2-dev
libssl-dev
libpython3-dev
librsync-dev
libxxhash-dev

### Other
Go

### Commands
git clone https://github.com/kovidgoyal/kitty && cd kitty
make -j$(nproc)
sudo ln -s kitty/launcher/kitty /usr/bin/
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/kitty 50
sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty


## ZSH + OhMyZSH + p10k

### Dependecies
neofetch

### Manual dependencies
https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

### Commands
sudo apt install zsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
ln -s ~/.config/.zshrc ~/.zshrc



## Picom

### Dependencies
meson
libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-dpms0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev libxext-dev meson ninja-build uthash-dev

### Commands
git clone git@github.com:yshui/picom.git  && cd picom
meson setup --buildtype=release build
ninja -C build install


## i3

### Dependencies
dh-autoreconf libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev xcb libxcb1-dev libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev libxcb-xinerama0-dev libxkbcommon-x11-dev libstartup-notification0-dev libxcb-randr0-dev libxcb-xrm0 libxcb-xrm-dev libxcb-shape0 libxcb-shape0-dev

### Commands
meson setup --buildtype=release build
ninja -C build install



## Rofi

### Dependencies
flex
bison
libxcb-ewmh-dev
check

### Commands
mkdir build && cd build
../configure
make -j$(nrpoc)
sudo make install


## Polybar

### Dependencies
flameshot

### Manual dependencies
https://fontawesome.com/v6/docs/desktop/
https://fontawesome.com/5v/docs/desktop/

### Install from apt repo
