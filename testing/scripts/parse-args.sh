Usage()
{
    cat <<-EOF
	Usage: $0 [options] vm-name vm-iso

    Create and start a testing VM.

    required argument:
      --bios|--efi  Indicates which VM to use: ansiarch-vm-bios or ansiarch-vm-efi

    positional argument:
      vm-iso        Path to .iso file for VM

    optional arguments:
      -h, --help              Prints this message
      -m, --memsize MEMSIZE   Sets memory size in megabytes (default is 1024)
      -s, --disksize DISKSIZE Sets disk size in gigabtypes (default is 4)
EOF
}

vm_memsize=1024
vm_disksize=40
vm_type=""
vm_name=""

connect="--connect qemu:///system"
echo args are: \""$@"\"

# Note that we use "$@" to let each command-line parameter expand to a
# separate word. The quotes around "$@" are essential!
# We need TEMP as the 'eval set --' would nuke the return value of getopt.
TEMP=$(getopt -o 'hm:s:' --long 'help,bios,efi,memsize:,disksize:' -n "$0" -- "$@")

if [ $? -ne 0 ]; then
	echo 'Terminating...' >&2
        Usage
	exit 1
fi

# Note the quotes around "$TEMP": they are essential!
eval set -- "$TEMP"
unset TEMP

while true; do
    echo \$1 is \"$1\"
    case "$1" in
        '--bios')
            vm_type="bios"
            vm_name="ansiarch-vm-bios"
            shift
            continue
            ;;
        '--efi')
            vm_type="efi"
            vm_name="ansiarch-vm-efi"
            shift
            continue
            ;;
	'-m'|'--memsize')
            vm_memsize=$2
	    shift 2
	    continue
	    ;;
	'-s'|'--disksize')
            vm_disksize=$2
	    shift 2
	    continue
	    ;;
        '-h'|'--help')
            Usage
            exit 0
            ;;
	'--')
	    shift
	    break
	    ;;
	*)
	    echo 'Internal error!' >&2
	    exit 1
	    ;;
    esac
done

if [[ -z $vm_type ]]
then
    echo "Must specify either --bios or --efi"
    Usage
    exit 2
fi
