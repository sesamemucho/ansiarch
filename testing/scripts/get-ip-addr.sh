#
# Get the IP address of an ansible-arch-install testing VM.
#

vm_name=${1:?Need name of ansible-arch-testing VM}

# Get the mac address
macad=$(virsh --connect qemu:///system domiflist "$vm_name" | awk '$2 == "network" { print $5}')

# Use arp to get the IP (this requires arp from net-tools package):
arp -na  | grep $macad | sed -Ee 's/^[^(]*\(([0-9.]+)\).*/\1/'
