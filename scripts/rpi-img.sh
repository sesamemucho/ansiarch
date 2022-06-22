#!/bin/bash

set -e
set -x
ANSIBLE_VAULT="./group_vars/home.yml"
IMG_SIZE="14GiB"
IMG_NAME="/data/rpi-img/base-rpi.img"
# The 'ArchLinuxARM-rpi-aarch64-latest.tar.gz' is the only one I could
# get to work, for the RPi 3, at least.
ARCH_TGZ="/data/big/ArchLinuxARM-rpi-armv7-latest.tar.gz"
MNT_POINT="/mnt"

get_item()
{
    echo $(ansible-vault view $ANSIBLE_VAULT | grep "^${1}:" | sed -e 's/^.*: *//')
}

if [[ $UID -ne 0 ]]
then
    echo You must run this script as root
    exit 1
fi

if [[ -z $ANSIBLE_VAULT_PASSWORD_FILE ]]
then
    echo Be sure to run this script with sudo -E: sudo -E $0
    exit 1
fi

rm -f "${IMG_NAME}"
fallocate -l ${IMG_SIZE} ${IMG_NAME}

loopdev=$(losetup --show -f ${IMG_NAME})

sfdisk $loopdev <<EOF
size=      409600, type=c
,
EOF

partprobe $loopdev

loopdev=$(losetup -P --show -f ${IMG_NAME})

mkfs.vfat -F32 ${loopdev}p1
mkfs.ext4 ${loopdev}p2

mount ${loopdev}p2 ${MNT_POINT}
mkdir ${MNT_POINT}/boot
mount ${loopdev}p1 ${MNT_POINT}/boot

echo "Copying ArchLinux image to image file"
tar xpf "$ARCH_TGZ" -C ${MNT_POINT}


# Setup base IP config
cat <<EOF >"${MNT_POINT}/etc/systemd/network/eth0.network"
[Match]
Name=eth0

[Network]
Address=$(get_item ip_start).155.42/$(get_item ip_cidr)
Gateway=$(get_item gateway)
DNS=$(get_item dns)
EOF

sync
umount ${MNT_POINT}/boot
umount ${MNT_POINT}

losetup -D
