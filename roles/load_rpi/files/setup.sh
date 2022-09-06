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

pacman-key --init
pacman-key --populate archlinuxarm

pacman --noconfirm -Sy
pacman --noconfirm -S python parted gpg-agent
pacman --noconfirm -Su

reboot
