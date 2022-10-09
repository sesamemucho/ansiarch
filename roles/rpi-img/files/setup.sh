#!/usr/bin/bash
#
# This script initializes Arch linux on a Raspberry Pi so that we can
# use Ansible on it.
# This means:
#   Initialize pacman keys
#   Update packages (and repos)
#   Install python
#

set -x
echo Starting at $(date) >> /root/setup.log
pacman-key --init &>> /root/setup.log
pacman-key --populate archlinuxarm &>> /root/setup.log

pacman --noconfirm -Sy &>> /root/setup.log
pacman --noconfirm -S python parted gnupg &>> /root/setup.log
pacman --noconfirm -Su &>> /root/setup.log

reboot
