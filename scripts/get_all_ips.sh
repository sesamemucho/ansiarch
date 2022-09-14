

here=$(readlink -f $(dirname $0))
for mach in $($here/get_all_relevant_machines.sh)
do
    guff=$(ansible-inventory -i inventory.yml all --list | jq "._meta.hostvars.${mach}.ip_start, ._meta.hostvars.${mach}.ipa" | tr -d '""' | sed 'N;s/\n/./')
    echo ${mach}: $guff
done
