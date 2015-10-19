all: apt

apt:
	sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/acme.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"
s3:
	sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/s3-c2c.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"
