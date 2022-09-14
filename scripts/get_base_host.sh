#!/bin/bash
#
# If the wired host is present, use that
# Otherwise, if the wireless host is present, use that
# Otherwise, return 'none'
# '{{ ip_start }}.{{ base_wired_addr }}/{{ ip_cidr }}'
here=$(dirname $0)
ip_start=$($here/get_ansible_var.sh ip_start localhost)
base_wired_addr=$($here/get_ansible_var.sh base_wired_addr localhost)
base_wireless_addr=$($here/get_ansible_var.sh base_wireless_addr localhost)

wired_host=${ip_start}.${base_wired_addr}
wireless_host=${ip_start}.${base_wireless_addr}

# echo wired is $wired_host
# echo wireless is $wireless_host

if ping -q -c 2 $wired_host >& /dev/null;
then
    echo wired_base
else
    if ping -q -c 2 $wireless_host >& /dev/null;
    then
        echo wireless_base
    else
        echo get_base_hosts.sh: Error - Neither wired_host nor wireless_host found 1>&2
        echo no-valid-base-host-found
        exit 1
    fi
fi

