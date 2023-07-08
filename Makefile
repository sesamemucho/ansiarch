
DEBUG_FLAG ?=
KEYFILE := ./files/ansible_archlinux
HOST ?= unset
hosts := $(patsubst host_vars/%.yml,%,$(wildcard host_vars/*.yml))

gen:
	ansible-galaxy install -r requirements.yml

run:
	run_archiso -d -i $(shell ls archlinux-*.iso | sort | tail -1)

archiso:
	 ansible-playbook $(DEBUG_FLAG) -f 2 -i inventory.yml archiso-img.yml |& tee archiso.log

rpi-img:
	ansible-playbook $(DEBUG_FLAG) -i inventory.yml rpi-img.yml

rpi-test:
	@ set -e; \
	  if [[ $(HOST) == 'unset' ]]; \
	  then \
	    echo "HOST must be set on the command line:"; \
	    echo "make HOST=myhost load"; \
	    exit; \
	  fi; \
	  ansible-playbook $(DEBUG_FLAG) -i inventory.yml --extra-vars="base_host=gabriel aa_host=$(HOST)" rpi-test.yml

x86-test:
	@ set -e; \
	  if [[ $(HOST) == 'unset' ]]; \
	  then \
	    echo "HOST must be set on the command line:"; \
	    echo "make HOST=myhost load"; \
	    exit; \
	  fi; \
	  ansible-playbook $(DEBUG_FLAG) -i inventory.yml --extra-vars="base_host=gabriel aa_host=$(HOST)" x86-test.yml

# trans:
# 	@ set -e; \
# 	  if [[ $(HOST) == 'unset' ]]; \
# 	  then \
# 	    echo "HOST must be set on the command line:"; \
# 	    echo "make HOST=myhost load"; \
# 	    exit; \
# 	  fi; \
# 	  ansible-playbook $(DEBUG_FLAG) -i inventory.yml --extra-vars="base_host=gabriel aa_host=$(HOST)" trans.yml

load:
	@ set -e; \
	  if [[ $(HOST) == 'unset' ]]; \
	  then \
	    echo "HOST must be set on the command line:"; \
	    echo "make HOST=myhost load"; \
	    exit; \
	  fi; \
	  ansible-playbook $(DEBUG_FLAG) -i inventory.yml --extra-vars="aa_host=$(HOST)" -l gabriel load.yml

configure:
	@ set -e; \
	  if [[ $(HOST) == 'unset' ]]; \
	  then \
	    echo "HOST must be set on the command line:"; \
	    echo "make HOST=myhost configure"; \
	    exit; \
	  fi; \
	ansible-playbook $(DEBUG_FLAG) -i inventory.yml -l $(HOST) configure.yml

# Template to create rules for each VM host named in host_vars/
#
#
define make_host
.PHONY: $(1)
$(1):
	make DEBUG_FLAG=$(DEBUG_FLAG) HOST=$(1) load
	@read -p "Press Enter to continue"
	make DEBUG_FLAG=$(DEBUG_FLAG) HOST=$(1) configure
endef

$(foreach host,$(hosts),$(eval $(call make_host,$(host))))
