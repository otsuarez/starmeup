HOSTNAME=$(shell echo `hostname` | cut -f1 -d\.)
ENV=$(shell cat /etc/bash.acme-env.sh | grep ENV | cut -f2 -d\')
GROUP=$(shell echo $(target) |  sed 's/\([a-z]\+\)\([1-9].*\)/\1/')
SSH_CONFIG_FILE:= $(ENV)/.ssh_config
ANSIBLE_SSH_ARGS := -F  $(SSH_CONFIG_FILE)
name := acme-frontend-iris
#all: help
all: zero

whoami:
	@echo hostname: $(HOSTNAME)
	@echo env: $(ENV)
	@echo "Usage: make help"

help:
	@echo make deploy name=acme-web-core version=3.33.206-master-00f271e

deploy: 
	#echo deploy.yml -e '{ "packages" : [{"name":"$(name)","version":"$(version)"}]}'
	ansible-playbook deploy.yml -e '{ "packages" : [{"name":"$(name)","version":"$(version)"}]}'

latest:
	#echo deploy.yml -e '{ "packages" : [{"name":"$(name)"}]}'
	ansible-playbook deploy.yml -e '{ "packages" : [{"name":"$(name)"}]}'

zero:
	ansible-playbook -i $(ENV) zero.yml -e '{ "packages" : [{"name":"$(name)"}]}'
unodedos:
	ansible-playbook -i IRIS zero.yml -e '{ "packages" : [{"name":"acme-frontend-iris","version":"1"},{"name":"acme-web-core","version":"3.33.229-master-66abfb1-880"}]}'
canary:
	ansible-playbook -i $(ENV) zero.yml -e '{ "packages" : [{"name":"$(name)"}]}' -t canary
rollback:
	ansible-playbook -i $(ENV) zero.yml -e '{ "packages" : [{"name":"$(name)"}]}' -t rollback
