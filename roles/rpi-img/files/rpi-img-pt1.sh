#!/bin/bash

rpi_image_name=${1:?Need name of RPi output image file}
rpi_image_size=${2:?Need size of RPi output image file}
rpi_mount_point=${3:?Need name of mount point of RPi image}
rpi_arch_tgz=${4:?Need name of RPi ArchLinux (input) image file}

set -x
set -u

echo "rpi_image_name is $rpi_image_name"
echo "rpi_image_size is $rpi_image_size"
echo "rpi_mount_point is $rpi_mount_point"
echo "rpi_arch_tgz is $rpi_arch_tgz"

rm -f "$rpi_image_name"
fallocate -l "$rpi_image_size" "$rpi_image_name"

loopdev=$(losetup --show -f "$rpi_image_name")

sfdisk $loopdev <<EOF
size=      409600, type=c
,
EOF

partprobe $loopdev
losetup -d $loopdev

loopdev=$(losetup -P --show -f "$rpi_image_name")

mkfs.vfat -F32 ${loopdev}p1
mkfs.ext4 ${loopdev}p2

mount ${loopdev}p2 "$rpi_mount_point"
mkdir "$rpi_mount_point"/boot
mount ${loopdev}p1 "$rpi_mount_point"/boot

echo "Copying ArchLinux image to image file"
# The 'Igoring unknown extended header keyword' thing causes tar to exit with error
# This is not, actually, an error.
( tar xpf "$rpi_arch_tgz" -C "$rpi_mount_point" || true ) |& grep -v 'Ignoring unknown extended header keyword'

# echo "Extracting files from new e2fsprogs: " $(pwd)
# echo "tar --xz -C $rpi_mount_point -xvf roles/rpi-img/files/e2fsprogs-1.47.0-1-armv7h.pkg.tar.xz"
# tar --xz -C "$rpi_mount_point" -xvf roles/rpi-img/files/e2fsprogs-1.47.0-1-armv7h.pkg.tar.xz || true
# echo UID is $UID
# echo md5sum $rpi_mount_point/usr/bin/fsck.ext4: $(md5sum $rpi_mount_point/usr/bin/fsck.ext4)

# Leave everything mounted for further ansible work.
