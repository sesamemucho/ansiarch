#!/bin/bash

ssh -i files/ansible_archlinux -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$@"
