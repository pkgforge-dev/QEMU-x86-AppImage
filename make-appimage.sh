#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q qemu-full | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://gitlab.com/qemu-project/qemu/-/raw/master/ui/icons/qemu.svg
export DEPLOY_GTK=1
export GTK_DIR=gtk-3.0
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1
export DEPLOY_PIPEWIRE=1
export OPTIMIZE_LAUNCH=1

# Deploy dependencies
quick-sharun \
	/usr/bin/qemu-*      \
	/usr/lib/qemu/*.so   \
	/usr/bin/bash        \
	/usr/bin/zenity      \
	/usr/bin/spicy       \
	/usr/bin/quickemu    \
	/usr/bin/quickget    \
	/usr/bin/quickreport \
	/usr/share/edk2      \
	/usr/share/qemu		 \
	/usr/lib/binfmt.d	 \
	/usr/lib/libcapstone.so*

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
