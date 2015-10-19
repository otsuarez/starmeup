dd := $(shell date +%s)
version := $(shell date +%s | rev | cut -c1-5 | rev)

all: octopush

first:
	ansible-playbook -i inventory first_main.yml

octopush:
	ansible-playbook -i inventory main.yml -e "component=octopush version=0.0.$(version) filename=octopush-1.0.269-master-646a561.zip branch=master sha=646a561" -vv

t:
	ansible-playbook techie.yml -i inventory -e "parent=parent1"

test:
	ansible-playbook -i inventory test.yml

elvira:
	ansible-playbook -i inventory.elvira test.yml
check:
	ansible-playbook -i inventory main.yml --syntax-check -e "component=smaug version=0.0.$(version) branch=master sha=973bc27" -vv
	#ansible-playbook -i inventory main.yml --syntax-check -e "component=foo version=0.0.$(version) branch=master sha=973bc27" -vv
