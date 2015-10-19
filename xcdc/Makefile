HOSTNAME=$(shell echo `hostname` | cut -f1 -d\.)
ENV=$(shell cat /etc/bash.acme-env.sh | grep ENV | cut -f2 -d\')
GROUP=$(shell echo $(target) |  sed 's/\([a-z]\+\)\([1-9].*\)/\1/')
SSH_CONFIG_FILE:= $(ENV)/.ssh_config
ANSIBLE_SSH_ARGS := -F  $(SSH_CONFIG_FILE)

#ifeq (,$(wildcard $(SSH_CONFIG_FILE)))
#	@echo "NO existe $(SSH_CONFIG_FILE)"
#else
#	@echo "existe $(SSH_CONFIG_FILE)"
#endif

.PHONY: local pc PrivateCloud macVagrant IRIS

all: whoami
# alias
lxpc: PrivateCloud
iris: IRIS

help:
	@echo "Usage:"
	@echo "deploy lxc in env"
	@echo "make <env>"
	@echo "----"
	@echo "post-create lxc guest install puppet client on a server"
	@echo "make puppet target=web1"
	@echo "----"
	@echo "post-create lxc guest apply standard acme server config removing default guest setup"
	@echo "make init target=web1"
	@echo "----"
	@echo "setup lxc guest "
	@echo "make setup target=web1"

whoami:
	@echo hostname: $(HOSTNAME)
	@echo env: $(ENV)
	@echo "Usage: make help"

iris:
	ansible-playbook -i $(ENV) lxc.yml --limit lxcservers

PrivateCloud:
	ansible-playbook -i $(ENV) lxc.yml --limit lxcservers
local:
	ansible-playbook -i $(HOSTNAME) lxc.yml --limit lxcservers[0]

puppet-setup: 
	ansible-playbook puppet-setup.yml -i inventory-setup -e 'target=$(GROUP)' --limit $(target).dc-iris.acme.ir  --skip-tags "cleanup"
	#ansible-playbook puppet-setup.yml -i $(ENV)/inventory -e 'target=$(GROUP)' --limit $(target).dc-iris.acme.ir
puppet-cleanup: 
	ansible-playbook puppet-setup.yml -i $(ENV)/inventory -e 'target=$(GROUP)' --limit $(target).dc-iris.acme.ir --tags "cleanup"
ping:
	ansible-playbook ping.yml -i inventory-setup -e 'target=$(GROUP)' --limit $(target).dc-iris.acme.ir 
lxcssh:
	ansible-playbook -i $(ENV) lxc.yml --limit lxcservers -t lxcssh
# first run make init then run make cleanup, there are two playbooks because we need to use two remote users
# make init target=jenkins-smaug
# make cleanup target=jenkins-smaug
# first playbook is executed via the ubuntu user, you can not delete the user the playbook is being executed under so the second playbook is required
# second playbook removes the ubuntu user
init: 
	export ANSIBLE_SSH_ARGS="-F  $(SSH_CONFIG_FILE)"
	#@echo env: $(SSH_CONFIG_FILE)
	ansible-playbook -i $(ENV) init.yml --limit '$(target)-setup'
	ansible-playbook -i $(ENV) cleanup.yml --limit '$(target)'
	#ansible-playbook -i $(ENV) cleanup.yml -e 'target=$(target)'
# running only cleanup
cleanup: 
	export ANSIBLE_SSH_ARGS="-F  $(SSH_CONFIG_FILE)"
	ansible-playbook -i $(ENV) cleanup.yml --limit '$(target)'
	#ansible-playbook -i $(ENV) cleanup.yml -e 'target=$(target)'
# let's setup that lxc guest
setup: 
	#export ANSIBLE_SSH_ARGS="-F  $(SSH_CONFIG_FILE)"
	ansible-playbook -i $(ENV) setup.yml --limit '$(target)' 
	#ansible-playbook -i $(ENV) setup.yml -e 'target=$(target)'

# ansible-playbook -i PrivateCloud setup.yml --limit 'jenkins-smaug' -t timezone
macVagrant:
	ansible-playbook -i $(ENV) lxc.yml --limit lxc1
	#ansible-playbook -i $(ENV) lxc.yml --limit lxcservers
