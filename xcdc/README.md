# LXC in a DC

An lxc setup in a data center.

# tl;dr

* Add lxc server to inventory.
* Add containers data to lxc's host_vars file.

# Inventory

The server should be added (IP or hostname) to the <code>lxcservers</code> group. That will automatically execute the installation of the lxc package on the server.

```
[lxcservers]
lxc1
```


# Containers

Each container will be defined in the <code>containers</code> variable in the lxc's variable file. That file should be named after the server's hostname and created inside the <code>host_vars</code> directory.

The <code>containers</code> section defines:

* name: the name of the vm
* ip: the ip address the vm will use. pay attention not to use an already defined one.
* status: whether the vm should start automatically at boot or manually. Available options: auto (automatic start), started (start the vm upon creation, no automatic startup)
* interfaces: list of key=values flags for the <code>lxc.network</code> section of the vm lxc config file (usually living in <code>/var/lib/lxc/<vm name>/config.xml</code>

```
containers:
  - { name: 'web2.dc-iris.acme.ir', status: 'started', interfaces: [{ 'flags':'up','link':'br0','name':'eth0','ipv4.gateway':'192.168.1.1','ipv4':'192.168.2.2/22'},{ 'flags':'up','link':'br2','name':'eth2','ipv4':'172.1.2.3/22'}] }
 ```



# Requirements

The <code>Makefile</code> script uses an environmental variable which must be already setup on the server.

Using the example from the <code>nms-iris</code> server we replicate it on the rls-jenkins server.

Create the <code>~/.bashrc</code> file with the following content

```
test -f /etc/bash.acme-env.sh && source /etc/bash.acme-env.sh
```

Then, create the script, taking into consideration to adjust accordingly the ENV

```
# Color Prompt for root & users
export ENV='PrivateCloud'
# use of environment before hostname in prompt is optional

if [ `id -un` = root ] ; then
        PS1='\[\033[1;94m\]\u@\h \[\033[0;90m\]\$\[\033[0m\] '
else
        # Prompt Common User
        #PS1="\e[0;33m\u@dc-privatecloud-\h \e[0;33m\$\[\033[0m\] "
        PS1='\[\033[1;31m\]\u@\h \$\[\033[0m\] '
fi
```

to use ssh_ansible_pass the <code>sshpass</code> package needs to be install

```
sudo apt-get install sshpass
```

# lxc version

The template for config file requires lxc 1.0 or better.

https://launchpad.net/~ubuntu-lxc/+archive/ubuntu/stable

This PPA contains backports of stable version of LXC for all supported Ubuntu releases.

Required and recomended dependencies are also included to provide an identical LXC experience on all supported Ubuntu releases.


```
sudo su - 
add-apt-repository -y ppa:ubuntu-lxc/stable

cat <<'_EOF_'>> /etc/apt/sources.list.d/ubuntu-lxc.list
deb http://ppa.launchpad.net/ubuntu-lxc/stable/ubuntu precise main 
deb-src http://ppa.launchpad.net/ubuntu-lxc/stable/ubuntu precise main 
_EOF_

apt-get update
apt-get install lxc
```

# lxc config

support for lxc config environment based



# lxc guests setup

Post creation of the lxc guest an initial setup is required.

* create users with proper permissions
* remove default user
* install standard set of packages

Default ubuntu image uses an standard user: "ubuntu" with password: "ubuntu". A new user account should be created which will be used for the server operations.

For security reasons default ubuntu user account should removed.

## playbook

The init.yml playbook  will apply the initial configuration for an lxc guest server after installation.


## ssh 

In order to setup ssh login into the newly created lxc guest do the following:

An <environment>/.ssh_config file should exists containing for each lxc guest two entries, one for logging in using the ubuntu user, the other one using the new user account.

## inventory 

Add the two entries to the <code><environment>/inventory</code> file.
The entry using the ubuntu user should be created under the <code>[setup]</code> group, in order to inherit ssh authentication credentials.

Run the playbook using the provided <code>Makefile</code> via the following command:

```
make initial target=<server-name>
```

## guest maintenance

When an lxc guest is no longer required, it can be destroyed by moving the item line from the <code>containers</code> variable to the <code>containers_trash</code> variable.

Next time the lxc.yml playbook runs, the lxc guest will be destroyed. 

Since this is a sensitive procedure (delete data might be unrecoverable) a safety measure was put in place. For this feature to work the <code>auto_removal</code> variable must be declared and set to <code>True</code> in the <code>group_vars/all</code> file.

macVagrant/group_vars/all
```
auto_removal: True
```

Example:

We have an lxc guest named siteadmin1:


```
root@lxc1:~# lxc-ls -f
NAME        STATE    IPV4       IPV6  AUTOSTART
-----------------------------------------------
server01    RUNNING  10.1.2.6  -     NO
server02    RUNNING  10.1.2.7  -     NO
siteadmin1  STOPPED  -          -     NO
ubuntu      STOPPED  -          -     NO
root@lxc1:~#
```

To remove it, move the corresponding item line in the host_vars file corresponding to the lxc server:

macVagrant/host_vars/lxc1
```
containers:
  - { name: 'server01', status: 'started', interfaces: [{ 'flags':'up', 'link':'lxcbr0','name':'eth0','ipv4':'10.1.2.6'}] }
    - { name: 'server02', status: 'started', interfaces: [{ 'flags':'up', 'link':'lxcbr0','name':'eth0','ipv4':'10.1.2.7'}] }
    containers_trash:
      - { name: 'siteadmin1'}
```

Run the playbook

```
TASK: [lxc | delete no longer used containers] ********************************
changed: [lxc1] => (item={'name': 'siteadmin1'})
```

The lxc guest vm was deleted.

```
root@lxc1:~# lxc-ls -f
NAME      STATE    IPV4       IPV6  AUTOSTART
---------------------------------------------
server01  RUNNING  10.1.2.6  -     NO
server02  RUNNING  10.1.2.7  -     NO
ubuntu    STOPPED  -          -     NO
root@lxc1:~#
```

### Troubleshooting

```
ansible-playbook -i PrivateCloud ping.yml -e "target=jenkins04-setup"
```


# TODO

* [x] lxc guests automatic removal
* [x] ~~lxc kickstart setup (post-install tasks: delete ubuntu user, install acme stuff)~~

