#!/bin/bash
# This script gets the names of all relevant machines from the inventory.
# 'relevant' means all persistent machines that have their own IP address
# except for localhost.
# This ends up being all the hosts under on_lan. I couldn't figure out how
# to do this in one jq command.

here=$(readlink -f $(dirname $0))
tmpfile=$(mktemp)
trap "rm $tmpfile" EXIT

ansible-inventory -i $here/../inventory.yml all --list --output $tmpfile
for c in $(cat x.json | jq -r '.on_lan.children[]'); do cat $tmpfile | jq -r ".$c.hosts[]"; done
