# Creates and starts testing-xxx VM
#
#
set -u
set -e
set -x
here=$(readlink -f $(dirname $0))
. $here/parse-args.sh

vm_iso=${1:?Need location of iso file for arch installation}
there_vm=$(readlink -f /var/tmp/$(basename $vm_iso))

macaddr="52:54:00:c0:ff:ee"

echo vm_name is:     $vm_name
echo vm_iso is:      $vm_iso
echo vm_memsize is:  $vm_memsize
echo vm_disksize is: $vm_disksize

# If the vm name has "bios" in it, then we're doing BIOS
# Otherwise we're doing EFI
if [[ $vm_type == "bios" ]]
then
    boottype=""
    destroyflag=""
else
    boottype="--boot uefi"
    destroyflag="--nvram"
fi

# Get the IPv4 address used by the specified VM
ip_addr=$(ansible -i inventory.yml -m debug $vm_name -a "var=hostvars[inventory_hostname].ansible_host" | awk '/hostvars/ {print $2}' | sed -e 's/"//g')

# Make sure the old VM is gone
if virsh $connect list --state-running --name | grep $vm_name >&/dev/null;
then
    virsh $connect destroy $vm_name
fi

if virsh $connect list --all --name | grep $vm_name >&/dev/null;
then
    virsh $connect undefine $destroyflag $vm_name
fi

if ! virsh $connect net-dumpxml default | grep "$macaddr" >& /dev/null;
then
    # make sure libvirt will assign the desired address to our vm
    virsh $connect net-update default add ip-dhcp-host "<host mac='$macaddr'  ip='$ip_addr'/>" --live >& /dev/null
fi

cp -v $vm_iso $there_vm

# virt-install $connect                         \
#              --name "$vm_name"                \
#              --memory $vm_memsize             \
#              --vcpus=2,maxvcpus=4             \
#              --cpu host                       \
#              --boot uefi,bootmenu.enable=on,bios.useserial=on \
#              --graphics none \
#              --serial pty \
#              --cdrom "$there_vm"              \
#              --disk size=${vm_disksize},format=qcow2 \
#              --virt-type kvm                  \
#              --network default,mac="52:54:00:c0:ff:ee" \
#              --console pty,target.type=virtio \
#              $boottype                        \
#              --autoconsole text

# #             --extra-args 'console=ttyS0,115200n8 --- console=ttyS0,115200n8' \

# #             --noautoconsole

virt-install $connect                         \
             --name "$vm_name"                \
             --memory $vm_memsize             \
             --vcpus=2,maxvcpus=4             \
             --cpu host                       \
             --cdrom "$there_vm"              \
             --disk size=${vm_disksize},format=qcow2 \
             --virt-type kvm                  \
             --network default,mac="52:54:00:c0:ff:ee" \
             --console pty,target.type=virtio \
             $boottype                        \
             --noautoconsole

# # Using the '--wait' flag for virt-install never returns

# echo
# echo "Connecting to VM"
# echo "Use the \"Escape character\" (below) to exit the VM console."
# echo "Login as \"root\". No password required."
# echo

# exec virsh $connect console "$vm_name"

