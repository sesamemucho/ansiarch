# eventually, From Bash Cookbook
# cookbook filename: func_pathmunge
# Adapted from Red Hat Linux
listmunge() {
    lname=$1
    new_elem=$2
    after_p=$3
    local foo
    foo=${!lname}

    if ! echo ${!lname} | grep -E -q "(^|:)$new_elem($|:)" ; then
        if [[ $after_p = after ]] ; then
            foo="${!lname}:$new_elem"
        else
            foo="${new_elem}:${!lname}"
        fi
    fi

    # In case lname was empty to begin with, trim orphan ':' as appropriate
    blarf="`echo "$foo" | sed -e 's/^://' -e 's/:$//' -e 's/ /\\ /g'`"
    eval "$lname=\"$blarf\""
}

if [[ $0 == ${BASH_SOURCE} ]]
then
    echo This script sets up the PATH variable, and should be sourced: "source $0" or ". $0"
    echo instead of being run directly.
else
    here=$(readlink -f $(dirname $BASH_SOURCE))
    listmunge PATH "$here"
fi
