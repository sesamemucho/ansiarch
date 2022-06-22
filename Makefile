KEYFILE := ./files/ansible_archlinux
hosts := $(patsubst host_vars/%.yml,%,$(wildcard host_vars/*.yml))

latest_archiso := $(shell ls archlinux-*.iso | sort | tail -1)
gen:
	ansible-galaxy install -r requirements.yml
	if [[ ! -r files/luks_keyfiles ]]; \
	then \
	  echo 'Luks keyfile (files/luks_keyfile) not found'; \
	  exit 1; \
	fi
run:
	run_archiso -d -i $(latest_archiso)

archiso:
	 ansible-playbook -f 2 -v -i inventory.yml archiso-img.yml |& tee archiso.log

do:
	ansible-playbook -i inventory.yml -l $(HOST) load.yml

barf:
#	@echo hosts are: $(hosts)
	@ echo $(foreach host,$(hosts),host $(host) bost)

# Template to create rules for each VM host named in host_vars/
#
#
define make_host
.PHONY: $(1)
$(1):
	ansible-playbook -i inventory.yml -l $(1) load.yml
endef

$(foreach host,$(hosts),$(eval $(call make_host,$(host))))
