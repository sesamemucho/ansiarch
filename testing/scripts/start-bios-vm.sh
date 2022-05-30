#
#
here=$(readlink -f $(dirname $0))

$here/start-vm.sh --bios "$@"
