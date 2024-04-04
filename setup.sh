#!/bin/bash


ask() {
    if [ -t 0 ]; then
        read -rp "$1 (Y/n): " response
    else
        read -rp "$1 (Y/n): " response < /dev/tty
    fi
    [[ -z "$response" ]] || [[ "$response" = [Yy] ]] || exit 0
}

# Check if the script is ran with 
if [[ $EUID -ne 0 ]]; then
    echo "Error: This script requires root privileges."
    exit 1
fi


# Install essential packages
nala --version &> /dev/null || apt install nala -y
nala install make zip curl gpg -y # remove git since it is the tool that download this script


# Set up the dotfiles
if ask "Set up dotfiles?"; then
git clone --separate-git-dir="$HOME"/.dotfiles https://git.benkhaled.com/.dotfiles ~/.cache/dotfiles
cp -iRT "$HOME"/.cache/dotfiles/ "$HOME"/ && rm -r "$HOME"/.cache/dotfiles/
fi


# Install base system dependencies
nala install xserver-xorg-core xserver-xorg-input-all xserver-xorg-video-fbdev xserver-xorg-video-intel xinit -y
nala install libx11-dev libxft-dev libxinerama-dev -y
nala install build-essential libpam0g-dev libxcb-xkb-dev -y

# Configure the suckless packages ------ ---------- ---------- ---------- ---------- ---------- ---------- CONFIGURATION
for f in ~/.mysetup/patches/*;do
    patch=$(basename "$f")
    patch -sd "$HOME/.mysetup/packages/suckless/${patch%%_*}/" -i "$(readlink -f "$f")"
done

# Install Nerd-font
fontUrl="$(wget -qO- "https://www.nerdfonts.com/font-downloads" | grep -oim1 'http[^\"]*FiraCode.zip')"
wget -qO- "$fontUrl" | busybox unzip -qq - -d "$HOME/.fonts/FiraCode/" && fc-cache -f

# Install suckless software   ---------- ---------- ---------- ---------- ---------- ---------- ---------- INSTALLATION 
for file in ~/.mysetup/packages/suckless/*; do
    make -C "$file/"
    make clean install -C "$file/"
done


# Install ly (display manager)
make -C ~/.mysetup/packages/fairyglade/ly/
make install installsystemd -C ~/.mysetup/packages/fairyglade/ly/
systemctl enable ly.service


# Install back-light and display controls
if ask "Set backlight controls and display configuration?"; then
    cp -iRT ~/.mysetup/display/ /etc/X11/
    cp -iRT ~/.mysetup/backlight/ /etc/
fi

# Install additional software ---------- ---------- ---------- ---------- ---------- ---------- ---------- OTHER SOFTWARE
nala install tmux unclutter alsa-utils acpid xclip scrot ranger btop -y
nala install feh mvp musikcube -y


# Install the latest stable neovim release
nala install ninja-build gettext cmake unzip curl #dependancies can be removed later
wget -qO- https://github.com/neovim/neovim/archive/refs/tags/stable.zip | busybox unzip -qq - -d ~/.mysetup/packages/
make CMAKE_BUILD_TYPE=Release -C neovim-stable/
cpack -G DEB --config neovim-stable/build/CPackConfig.cmake
nala install neovim-stable/build/*.deb -y


# Install browser
if [[ $browser == vimb ]]; then
    git clone git://github.com/fanglingsu/vimb.git ~/fanglingsu/vimb
    nala install libgtk-3-dev libwebkit2gtk-4.1-dev gst-libav gst-plugins-good -y
    make V=1 -C ~/fanglingsu/vimb
    make install -C ~/fanglingsu/vimb
elif [[ $browser == floorp ]]; then
    curl -fsSL https://ppa.ablaze.one/KEY.gpg | gpg --dearmor -o /usr/share/keyrings/Floorp.gpg
    curl -sS --compressed -o /etc/apt/sources.list.d/Floorp.list 'https://ppa.ablaze.one/Floorp.list'
    nala update && nala install floorp -y
else
    wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/vivaldi-browser.gpg
    echo "deb [signed-by=/usr/share/keyrings/vivaldi-browser.gpg arch=$(dpkg --print-architecture)] https://repo.vivaldi.com/archive/deb/ stable main" > /etc/apt/sources.list.d/vivaldi-archive.list
    nala update && nala install vivaldi-stable -y
fi


for p in gimp inkscape ffmpeg imagemagick; do
    if [ -t 0 ]; then
        read -rp "Install $p (y/N): " response
    else
        read -rp "Install $p (y/N): " response < /dev/tty
    fi
    [[ $response = [Yy] ]] || continue
    nala insatall "$p" -y
done
