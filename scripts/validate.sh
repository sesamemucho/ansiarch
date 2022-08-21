#!/bin/bash
#
# This script performs some simple validations on the ansible-archlinux
# configuration.
#

declare -i retval=0

# Not using this yet
# # Make sure there is a luks keyfile
# luks_keyfile=$(cat group_vars/all.yml | awk '/^luks_keyfile:/ {print $2}')
# if [[ ! -r $luks_keyfile ]]
# then
#   echo "Luks keyfile ($luks_keyfile) not found"
#   let $(( retval++ ))
# fi

ssh_key=$(cat group_vars/all.yml | awk '/^ansible_ssh_private_key_file:/ {print $2}')
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
