

here=$(readlink -f $(dirname $0))
ips=$(ansible-inventory -i inventory.yml all --list | jq '._meta.hostvars.localhost.ip_start' | tr -d '"').
domain=$(ansible-inventory -i inventory.yml all --list | jq '._meta.hostvars.localhost.domain' | tr -d '"')
for mach in $($here/get_all_relevant_machines.sh)
do
    guff=$(ansible-inventory -i inventory.yml all --list | jq "._meta.hostvars.${mach}.ipa | map(.ip) | map(\"$ips\" + .)|@sh" | tr -d "'\"\"'")

    for ipa in ${guff}
    do
        echo $ipa:  ${mach} ${mach}.${domain}
    done
done

# jq "._meta.hostvars.${mach}.ip_start, ._meta.hostvars.${mach}.ipa" | tr -d '""' | sed 'N;s/\n/./')
#     echo ${mach}: $guff
# done
