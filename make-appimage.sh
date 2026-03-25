#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q qemu-system-x86 | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://gitlab.com/qemu-project/qemu/-/raw/master/ui/icons/qemu.svg
export DESKTOP=DUMMY
export MAIN_BIN=qemu-system-x86_64
export DEPLOY_GTK=1
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1

# Deploy dependencies
quick-sharun /usr/bin/qemu-system-x86_64 /usr/bin/qemu-system-i386

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
