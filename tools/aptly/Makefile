HOSTNAME := $(shell hostname)

all: aptly

aptly:
	ansible-playbook -i inventory aptly.yml --limit $(HOSTNAME)
