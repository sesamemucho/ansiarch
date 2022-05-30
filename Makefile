KEYFILE := ./files/ansible_archlinux

latest_archiso := $(shell ls archlinux-*.iso | sort | tail -1)
gen:
	ansible-galaxy install -r requirements.yml

run:
	run_archiso -d -i $(latest_archiso)

archiso:
	 ansible-playbook -f 2 -v -i inventory.yml archiso-img.yml |& tee archiso.log

do:
	ansible-playbook -i inventory.yml -l $(HOST) load.yml
