
latest_archiso := $(shell ls archlinux-*.iso | sort | tail -1)
run:
	run_archiso -i $(latest_archiso)

archiso:
	 ansible-playbook -v -i inventory.yml archiso-img.yml |& tee archiso.log
