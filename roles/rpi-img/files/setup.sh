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
echo Starting at $(date) |& tee -a /root/setup.log
echo "pacman-key --init" |& tee -a /root/setup.log
pacman-key --init |& tee -a /root/setup.log
echo "pacman-key --populate archlinuxarm" |& tee -a /root/setup.log
pacman-key --populate archlinuxarm |& tee -a /root/setup.log

echo "pacman --noconfirm -Sy" |& tee -a /root/setup.log
pacman --noconfirm -Sy |& tee -a /root/setup.log
echo "pacman --noconfirm -S python parted gnupg" |& tee -a /root/setup.log
pacman --noconfirm -S python parted gnupg |& tee -a /root/setup.log
echo "gpgconf --kill all" |& tee -a /root/setup.log
gpgconf --kill all |& tee -a /root/setup.log
echo "gpgconf --launch all" |& tee -a /root/setup.log
gpgconf --launch all |& tee -a /root/setup.log
echo "pacman --noconfirm -Su" |& tee -a /root/setup.log
pacman --noconfirm -Su |& tee -a /root/setup.log

echo "reboot" |& tee -a /root/setup.log
reboot
