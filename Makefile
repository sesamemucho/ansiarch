DEBUG_FLAG ?=
KEYFILE := ./files/ansible_archlinux
HOST ?= unset
hosts := $(patsubst host_vars/%.yml,%,$(wildcard host_vars/*.yml))

latest_archiso := $(shell ls archlinux-*.iso | sort | tail -1)
gen:
	ansible-galaxy install -r requirements.yml
	scripts/validate.sh

run:
	run_archiso -d -i $(latest_archiso)

archiso:
	 ansible-playbook $(DEBUG_FLAG) -f 2 -i inventory.yml archiso-img.yml |& tee archiso.log

rpi-base:
	ansible-playbook $(DEBUG_FLAG) -i inventory.yml rpi-img.yml

rpi-test:
	ansible-playbook $(DEBUG_FLAG) -i inventory.yml rpi-test.yml

load:
	@ set -e; \
	  if [[ $(HOST) == 'unset' ]]; \
	  then \
	    echo "HOST must be set on the command line:"; \
	    echo "make HOST=myhost load"; \
	    exit; \
	  fi; \
	  : Are we using wired_base or wireless_base?; \
	  base_host=$$(scripts/get_base_host.sh); \
	  ansible-playbook $(DEBUG_FLAG) -i inventory.yml --extra-vars="base_host=$$base_host aa_host=$(HOST)" load.yml; \
	  ansible-playbook $(DEBUG_FLAG) -i inventory.yml -l $(HOST) configure.yml

# Template to create rules for each VM host named in host_vars/
#
#
define make_host
.PHONY: $(1)
$(1):
	ansible-playbook $(DEBUG_FLAG) -i inventory.yml -l $(1) configure.yml
endef

$(foreach host,$(hosts),$(eval $(call make_host,$(host))))
