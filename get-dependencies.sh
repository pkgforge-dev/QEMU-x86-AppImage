#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
if [ "$ARCH" = "aarch64" ]; then
    DATE=202602-2
    wget https://umea.mirror.pkgbuild.com/extra/os/x86_64/edk2-aarch64-${DATE}-any.pkg.tar.zst
    wget https://umea.mirror.pkgbuild.com/extra/os/x86_64/edk2-riscv64-${DATE}-any.pkg.tar.zst
    wget https://umea.mirror.pkgbuild.com/extra/os/x86_64/qemu-system-arm-firmware-10.2.2-4-x86_64.pkg.tar.zst
    wget https://umea.mirror.pkgbuild.com/extra/os/x86_64/edk2-ovmf-${DATE}-any.pkg.tar.zst
    wget https://umea.mirror.pkgbuild.com/extra/os/x86_64/seabios-1.17.0-2-any.pkg.tar.zst
    pacman -U *.pkg.tar.zst --noconfirm --arch x86_64
else
    pacman -S --noconfirm edk2-aarch64 qemu-system-arm-firmware
fi
pacman -Syu --noconfirm --overwrite '/usr/share/qemu/*' \
    libdecor         \
    pipewire-audio   \
    pipewire-jack    \
    qemu-full        \
    qemu-desktop     \
    qemu-user        \
    qemu-user-binfmt \
    spice-gtk        \
    swtpm            \
    virtiofsd

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
make-aur-package zenity-rs-bin
make-aur-package quickemu

# If the application needs to be manually built that has to be done down here
