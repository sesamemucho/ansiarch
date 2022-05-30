# Update the host var file of a testing VM with its IP address
# The IP address isn't known until runtime.

ip_addr=${1:?Need IP address of ansible-arch-testing VM}
vm_name=${2:?Need name of ansible-arch-testing VM}

echo "---" >host_vars/"$vm_name".yml
echo "ansible_host: $ip_addr" >>host_vars/"$vm_name".yml

if [[ $vm_name =~ bios ]]
then
    echo "boot_partition_suffix: '2'" >>host_vars/"$vm_name".yml
    echo "root_partition_suffix: '3'" >>host_vars/"$vm_name".yml
    echo "boottype: bios" >>host_vars/"$vm_name".yml
else
    echo "boot_partition_suffix: '1'" >>host_vars/"$vm_name".yml
    echo "root_partition_suffix: '2'" >>host_vars/"$vm_name".yml
    echo "boottype: efi" >>host_vars/"$vm_name".yml
fi

cat host_vars/testing-common.yml >> host_vars/"$vm_name".yml
