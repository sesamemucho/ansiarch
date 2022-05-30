vm_name=${1:?Need name of ansible-arch-testing VM}
connect="--connect qemu:///system"

virsh $connect destroy "$vm_name"
virsh $connect undefine --remove-all-storage --nvram "$vm_name" 
