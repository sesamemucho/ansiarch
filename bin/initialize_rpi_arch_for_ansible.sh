#!/usr/bin/bash
#
# This script initializes Arch linux on a Raspberry Pi so that we can
# use Ansible on it.
# This means:
#   Initialize pacman keys
#   Update packages (and repos)
#   Install python
#

ipaddr=${1:?Need IP address of Rasbperry Pi}

ssh_cmd="ssh -i $(scripts/get_ansible_var.sh ansible_ssh_private_key_file) \
   -o LogLevel=ERROR $(scripts/get_ansible_var.sh ansible_ssh_common_args) root@${ipaddr}"

set -x

$ssh_cmd pacman-key --init
$ssh_cmd pacman-key --populate archlinuxarm

$ssh_cmd pacman --noconfirm -Syu

$ssh_cmd pacman --noconfirm -S python parted

$ssh_cmd reboot
