#!/bin/bash
#
# If the wired host is present, use that
# Otherwise, if the wireless host is present, use that
# Otherwise, return 'none'
# '{{ ip_start }}.{{ base_wired_addr }}/{{ ip_cidr }}'
here=$(dirname $0)
ip_start=$($here/get_ansible_var.sh ip_start)
base_wired_addr=$($here/get_ansible_var.sh base_wired_addr)
base_wireless_addr=$($here/get_ansible_var.sh base_wireless_addr)

wired_host=${ip_start}.${base_wired_addr}
wireless_host=${ip_start}.${base_wireless_addr}

echo wired is $wired_host
echo wireless is $wireless_host

