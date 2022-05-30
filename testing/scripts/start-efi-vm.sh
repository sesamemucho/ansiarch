#
#
here=$(dirname $0)
. $here/parse-args.sh

vm_iso=${1:?Need location of iso file for arch installation}

$here/start-vm.sh -m $vm_memsize -s $vm_disksize "testing-efi" "$vm_iso"
