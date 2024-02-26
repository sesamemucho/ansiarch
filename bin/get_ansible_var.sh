#!/bin/bash

# This script prints out the value of the variable passed in as an
# argument to this script.
#
here=$(dirname $0)
top=$(readlink -f $here/..)
varname=${1:?Need the name of an ansible variable}
hostname=${2:-localhost}

ansible-inventory -i $top/inventory.yml --host $hostname | jq -j ".${varname}"
