#!/bin/bash

# This script prints out the value of the variable passed in as an
# argument to this script.
#

varname=${1:?Need the name of an ansible variable}

ansible -i invent-local.yml localhost -a "echo var: {{ $varname }}" | sed -ne '/^var:/s/var: //p'
