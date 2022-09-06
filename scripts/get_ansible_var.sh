#!/bin/bash

# This script prints out the value of the variable passed in as an
# argument to this script.
#
here=$(dirname $0)
top=$(readlink -f $here/..)
varname=${1:?Need the name of an ansible variable}

#ansible -i <(echo -e "---\nall:\n  localhost:") localhost -a "echo var: {{ $varname }}" | sed -ne '/^var:/s/var: //p'
ansible -i $top/inventory.yml localhost -a "echo var: {{ $varname }}" | sed -ne '/^var:/s/var: //p'
