#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm      \
    gtk3                     \
    libdecor                 \
    qemu-system-x86          \
    qemu-system-x86-firmware \
    sdl2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here
mkdir -p ./AppDir/bin
mv -v /usr/share/qemu/* ./AppDir/bin
