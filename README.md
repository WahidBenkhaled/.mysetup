# System setup

System setup is ... a quick way to set up a custom system


## Features

The script will set up the following:
- display manager (ly)
- window manager (dwm)
- dynamic menu (dmenu)
- terminal emulator (st)

Additional software:
- unclutter (a tool that hides the mouse cursor)
- slstatus (status bar)
- slock (lock screen)
- alsa-utils (for sound)
- acpid (event daemon for backlight)
- xclip (clipboard)
- scrot or mime (screenshot tool)
- ranger or lf (file manager)
- nvim (text editor)
- browser (multiple choices)
- rest (image viewer, audio player, and video player)

Optional software:
- gimp
- inkscape
- ffmpeg
- imagemagick


## Prerequisites

So fare this setup is tested only on a clean Debian base system installation  


## Installation

To use this setup you must download and execute an install script. That will download all the necessary files and install them.  
There is multiple ways to do this, here are two methods to choose from:  

### Option 1:

The popular method is to use git, first you need to insure that git is installed. Then execute the following command:  

    git clone --recursive --remote-submodules -j7 https://git.benkhaled.com/mysetup ~/.mysetup && bash ~/.mysetup/setup.sh


### Option 2:

Alternatively you can download it using wget or curl, just run one of the following command in the terminal

    wget -qO- https://git.benkhaled.com/mysetup | bash

    curl -s https://git.benkhaled.com/mysetup | bash

curl might not be installed by default, however wget should be included in Debian's base system.  


## Usage

No actions are required to use the files after the installation though a system reboot is recommended
