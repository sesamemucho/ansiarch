#!/bin/bash

# This script prints out the value of the variable passed in as an
# argument to this script.
#
here=$(dirname $0)
top=$(readlink -f $here/..)
varname=${1:?Need the name of an ansible variable}
hostname=${2:?Need the name of an ansible host}

ansible-inventory -i $top/inventory.yml all --host $hostname | jq ".${varname}" | tr -d '""'
