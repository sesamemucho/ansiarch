#!/bin/bash
#
# This script performs some simple validations on the ansible-archlinux
# configuration.
#

declare -i retval=0

# Not using this yet
# # Make sure there is a luks keyfile
# luks_keyfile=$(get_ansible_var.sh luks_keyfile)
# if [[ ! -r $luks_keyfile ]]
# then
#   echo "Luks keyfile ($luks_keyfile) not found"
#   let $(( retval++ ))
# fi

ssh_key=$(#!/usr/bin/bash
#
# This script initializes Arch linux on a Raspberry Pi so that we can
# use Ansible on it.
# This means:
#   Initialize pacman keys
#   Update packages (and repos)
#   Install python
#

ipaddr=${1:?Need IP address of Rasbperry Pi}

ssh_cmd="ssh -i $(get_ansible_var.sh ansible_ssh_private_key_file) \
   -o LogLevel=ERROR $(get_ansible_var.sh ansible_ssh_common_args) root@${ipaddr}"

set -x

$ssh_cmd pacman-key --init
$ssh_cmd pacman-key --populate archlinuxarm

$ssh_cmd pacman --noconfirm -Syu

$ssh_cmd pacman --noconfirm -S python parted

$ssh_cmd reboot
get_ansible_var.sh ansible_ssh_private_key_file)
if [[ ! -r $ssh_key ]]
then
  echo "SSH keyfile ($ssh_key) not found"
  let $(( retval++ ))
fi

if [[ $retval -eq 0 ]]
then
    # No errors; return good status
    exit 0
else
    # At least one error, return bad status
    exit 1
fi
