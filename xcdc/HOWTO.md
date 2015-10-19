#  lxc guest

lxc guests are created on lxc servers


## define lxc guest

add the container definition on the corresponding lxc server

PrivateCloud/host_vars/dev6-core

under

```
containers:
  - { name: 'jenkins-dev', status: 'started', interfaces: [{ 'flags':'up', 'link':'lxcbr0','name':'eth0','ipv4':'10.1.2.3'}] }
```


## create lxc guest

```
make lxpc
```


# ssh config

vi <enviroment>/.ssh_cofig
add two entries, one for the setup and the second for deploy of the server
or ...
add one entry with <servername>* using (ssh config file patterns](http://linux.die.net/man/5/ssh_config)


```
Host jenkins-dev*
  Hostname 10.1.2.3
  ServerAliveInterval 300
  ServerAliveCountMax 60
  StrictHostKeyChecking no
  ProxyCommand ssh dev6-core-server nc %h %p -w 10 2> /dev/null
```


# inventory

add the host to the inventory

``` PrivateCloud/inventory
[jenkins]
jenkins04
jenkins-dev

[setup]
jenkins04-setup
jenkins-dev-setup
```

two entries are required, one for initial setup, another for host setup

make init target=jenkins-dev
make cleanup target=jenkins-dev

# init

```
make init target=jenkins-dev
```


# cleanup


```
make cleanup target=jenkins-dev
```

# install server's stuff

## server host file

PrivateCloud/host_vars/jenkins-dev

```
roles:
 - infr-common
 - infr-jenkins
 - jenkins
```


# varnish

PrivateCloud/host_vars/dev6-core
```
# varnish
backends:
  - { name: 'jenkins_dev', host: '10.1.2.3', port: '8080' }

http_hosts:
  - {url: 'jenkins-dev.acme.com', backend: 'jenkins_dev'}
```

## install/update varnish config

```
make setup target=dev6-core
```

# workstation


add to <code>/etc/hosts</code> file the ip and the hostname.

the ip should be the one from the server the varnish daemon is running.

```
192.168.1.2 jenkins-dev.acme.com
```

browser

http://jenkins-dev.acme.com/


sbt

gradle

https://services.gradle.org/distributions/gradle-2.2.1-bin.zip

me faltaba esto, las key y el alias del ssh


rls/.bash_aliases
alias connect-acme='ssh rls@10.1.2.3'


make lxcssh








# nice ascii art

````



                                                              smtp (25)
                                                               __  _   
                                                              [__]|=|  
                                                              /::/|_|  
 laptop          .-,(  ),-.         Ext. Host      Int. Host      ^
  (22)        .-(          )-.         (22)           (22)        |
  __  _ ---->(    internet    )----> __  _   -----> __  _   ------.
 [__]|=|      '-(          ).-'     [__]|=|        [__]|=|        |
 /::/|_|          '-.( ).-'         /::/|_|        /::/|_|        v
                                                             imap (143)
                                                              __  _    
                                                             [__]|=|   
                                                             /::/|_| 
```



# stdout




```
rls@rls-jenkins:/home/local/git/startmeup/xcdc$ make lxpc
ansible-playbook -i PrivateCloud main.yml --limit lxcservers

PLAY [lxcservers] *************************************************************

TASK: [lxc | check lxc base dir status] ***************************************
ok: [dev6-core]

TASK: [lxc | storing lxc base dir status] *************************************
ok: [dev6-core]

TASK: [lxc | directories | check mount dir status] ****************************
ok: [dev6-core]

TASK: [lxc | directories | create mount dir] **********************************
skipping: [dev6-core]

TASK: [lxc | directories | rename original lib dir] ***************************
ok: [dev6-core]

TASK: [lxc | directories | create symlink] ************************************
skipping: [dev6-core]

TASK: [lxc | install lxc] *****************************************************
ok: [dev6-core] => (item=lxc)

TASK: [lxc | checking for clone template] *************************************
ok: [dev6-core]

TASK: [lxc | template ||  create clone container] *****************************
skipping: [dev6-core]

TASK: [lxc | create containers] ***********************************************
ok: [dev6-core] => (item={'status': 'started', 'interfaces': [{'link': 'lxcbr0', 'flags': 'up', 'name': 'eth0', 'ipv4': '10.1.2.186'}], 'name': 'jenkins03'})
ok: [dev6-core] => (item={'status': 'started', 'interfaces': [{'link': 'lxcbr0', 'flags': 'up', 'name': 'eth0', 'ipv4': '10.1.2.187'}], 'name': 'jenkins04'})
changed: [dev6-core] => (item={'status': 'started', 'interfaces': [{'link': 'lxcbr0', 'flags': 'up', 'name': 'eth0', 'ipv4': '10.1.2.188'}], 'name': 'jenkins-dev'})

TASK: [lxc | get running containers] ******************************************
ok: [dev6-core]

TASK: [lxc | set default template filename var] *******************************
ok: [dev6-core]

TASK: [lxc | set template filename var] ***************************************
ok: [dev6-core]

TASK: [lxc | set container networking config file] ****************************
ok: [dev6-core] => (item={'status': 'started', 'interfaces': [{'link': 'lxcbr0', 'flags': 'up', 'name': 'eth0', 'ipv4': '10.1.2.186'}], 'name': 'jenkins03'})
ok: [dev6-core] => (item={'status': 'started', 'interfaces': [{'link': 'lxcbr0', 'flags': 'up', 'name': 'eth0', 'ipv4': '10.1.2.187'}], 'name': 'jenkins04'})
changed: [dev6-core] => (item={'status': 'started', 'interfaces': [{'link': 'lxcbr0', 'flags': 'up', 'name': 'eth0', 'ipv4': '10.1.2.188'}], 'name': 'jenkins-dev'})

TASK: [lxc | set container to autostart] **************************************
skipping: [dev6-core] => (item={'status': 'started', 'interfaces': [{'link': 'lxcbr0', 'flags': 'up', 'name': 'eth0', 'ipv4': '10.1.2.186'}], 'name': 'jenkins03'})
skipping: [dev6-core] => (item={'status': 'started', 'interfaces': [{'link': 'lxcbr0', 'flags': 'up', 'name': 'eth0', 'ipv4': '10.1.2.187'}], 'name': 'jenkins04'})
skipping: [dev6-core] => (item={'status': 'started', 'interfaces': [{'link': 'lxcbr0', 'flags': 'up', 'name': 'eth0', 'ipv4': '10.1.2.188'}], 'name': 'jenkins-dev'})

TASK: [lxc | start new containers] ********************************************
skipping: [dev6-core] => (item={'status': 'started', 'interfaces': [{'link': 'lxcbr0', 'flags': 'up', 'name': 'eth0', 'ipv4': '10.1.2.186'}], 'name': 'jenkins03'})
skipping: [dev6-core] => (item={'status': 'started', 'interfaces': [{'link': 'lxcbr0', 'flags': 'up', 'name': 'eth0', 'ipv4': '10.1.2.187'}], 'name': 'jenkins04'})
changed: [dev6-core] => (item={'status': 'started', 'interfaces': [{'link': 'lxcbr0', 'flags': 'up', 'name': 'eth0', 'ipv4': '10.1.2.188'}], 'name': 'jenkins-dev'})

PLAY RECAP ********************************************************************
dev6-core                  : ok=13   changed=3    unreachable=0    failed=0

rls@rls-jenkins:/home/local/git/startmeup/xcdc$
```



```
rls@rls-jenkins:/home/local/git/startmeup/xcdc$ time make setup target=jenkins-dev
export ANSIBLE_SSH_ARGS="-F  PrivateCloud/.ssh_config"
ansible-playbook -i PrivateCloud setup.yml --limit 'jenkins-dev'

PLAY [lxc guest setup] ********************************************************

TASK: [infr-common | installing packages] *************************************
ok: [jenkins-dev] => (item=zip,wget)

TASK: [infr-jenkins | ensure user jenkins exists] *****************************
ok: [jenkins-dev]

TASK: [infr-jenkins | ensure ssh directory for user jenkins exists] ***********
ok: [jenkins-dev] => (item=/var/lib/jenkins/.ssh)

TASK: [infr-jenkins | Copy ssh files for jenkins user access to github] *******
ok: [jenkins-dev] => (item=config)
ok: [jenkins-dev] => (item=id_rsa)
ok: [jenkins-dev] => (item=id_rsa.pub)
ok: [jenkins-dev] => (item=known_hosts)

TASK: [jenkins | add jenkins apt repository key] ******************************
ok: [jenkins-dev]

TASK: [jenkins | installing jenkins repository] *******************************
ok: [jenkins-dev]

TASK: [jenkins | installing packages - jenkins] *******************************
changed: [jenkins-dev] => (item=git,curl,jenkins)

TASK: [jenkins | be sure services are running and enabled] ********************
ok: [jenkins-dev] => (item=jenkins)

TASK: [jenkins | Create Jenkins CLI destination directory] ********************
ok: [jenkins-dev]

TASK: [jenkins | wait 60 seconds for port 8080 to become open on the host, do not start checking for 10 seconds] ***
ok: [jenkins-dev]

TASK: [jenkins | Get Jenkins CLI] *********************************************
changed: [jenkins-dev]

TASK: [jenkins | Get Jenkins CLI] *********************************************
ok: [jenkins-dev]

TASK: [jenkins | Get Jenkins updates] *****************************************
changed: [jenkins-dev]

TASK: [jenkins | Update-center Jenkins] ***************************************
changed: [jenkins-dev]

TASK: [jenkins | 10s delay while installing plugins] **************************
ok: [jenkins-dev]

TASK: [jenkins | Install/update plugins] **************************************
changed: [jenkins-dev] => (item=ansicolor)
changed: [jenkins-dev] => (item=ant)
changed: [jenkins-dev] => (item=artifactory)
changed: [jenkins-dev] => (item=backup)
changed: [jenkins-dev] => (item=build-pipeline-plugin)
changed: [jenkins-dev] => (item=copy-project-link)
changed: [jenkins-dev] => (item=copy-to-slave)
changed: [jenkins-dev] => (item=cvs)
changed: [jenkins-dev] => (item=description-setter)
changed: [jenkins-dev] => (item=email-ext)
changed: [jenkins-dev] => (item=embeddable-build-status)
changed: [jenkins-dev] => (item=external-monitor-job)
changed: [jenkins-dev] => (item=git)
changed: [jenkins-dev] => (item=git-client)
changed: [jenkins-dev] => (item=github)
changed: [jenkins-dev] => (item=github-api)
changed: [jenkins-dev] => (item=greenballs)
changed: [jenkins-dev] => (item=instant-messaging)
changed: [jenkins-dev] => (item=ircbot)
changed: [jenkins-dev] => (item=javadoc)
changed: [jenkins-dev] => (item=jenkins-jira-issue-updater)
changed: [jenkins-dev] => (item=jira)
changed: [jenkins-dev] => (item=ldap)
changed: [jenkins-dev] => (item=maven-plugin)
changed: [jenkins-dev] => (item=mysql-auth)
changed: [jenkins-dev] => (item=next-build-number)
changed: [jenkins-dev] => (item=pam-auth)
changed: [jenkins-dev] => (item=parameterized-trigger)
changed: [jenkins-dev] => (item=phing)
changed: [jenkins-dev] => (item=rebuild)
changed: [jenkins-dev] => (item=seleniumhq)
changed: [jenkins-dev] => (item=skip-certificate-check)
changed: [jenkins-dev] => (item=ssh-slaves)
changed: [jenkins-dev] => (item=subversion)
changed: [jenkins-dev] => (item=svn-release-mgr)
changed: [jenkins-dev] => (item=svn-tag)
changed: [jenkins-dev] => (item=translation)
changed: [jenkins-dev] => (item=viewVC)
changed: [jenkins-dev] => (item=javadoc)
changed: [jenkins-dev] => (item=translation)

TASK: [jenkins | ensure app directory] ****************************************
changed: [jenkins-dev]

TASK: [jenkins | copying ssh config for jenkins  user] ************************
ok: [jenkins-dev]

TASK: [jenkins | copying github keys for jenkins  user] ***********************
changed: [jenkins-dev]

TASK: [jenkins | ssh know_hosts file for jenkins  user] ***********************
ok: [jenkins-dev]

PLAY RECAP ********************************************************************
jenkins-dev              : ok=20   changed=7    unreachable=0    failed=0

#ansible-playbook -i PrivateCloud setup.yml -e 'target=jenkins-dev'

real  10m52.645s
user  0m6.608s
sys 0m5.352s
rls@rls-jenkins:/home/local/git/startmeup/xcdc$
```


```
rls@rls-jenkins:/home/local/git/startmeup/xcdc$ time make setup target=dev6-core
export ANSIBLE_SSH_ARGS="-F  PrivateCloud/.ssh_config"
ansible-playbook -i PrivateCloud setup.yml --limit 'dev6-core'

PLAY [server setup] ***********************************************************

TASK: [infr-common | installing packages] *************************************
skipping: [dev6-core]

TASK: [infr-jenkins | ensure user jenkins exists] *****************************
skipping: [dev6-core]

TASK: [infr-jenkins | ensure ssh directory for user jenkins exists] ***********
skipping: [dev6-core] => (item=/var/lib/jenkins/.ssh)

TASK: [infr-jenkins | Copy ssh files for jenkins user access to github] *******
skipping: [dev6-core] => (item=config)
skipping: [dev6-core] => (item=id_rsa)
skipping: [dev6-core] => (item=id_rsa.pub)
skipping: [dev6-core] => (item=known_hosts)

TASK: [jenkins | add jenkins apt repository key] ******************************
skipping: [dev6-core]

TASK: [jenkins | installing jenkins repository] *******************************
skipping: [dev6-core]

TASK: [jenkins | installing packages - jenkins] *******************************
skipping: [dev6-core]

TASK: [jenkins | be sure services are running and enabled] ********************
skipping: [dev6-core] => (item=jenkins)

TASK: [jenkins | Create Jenkins CLI destination directory] ********************
skipping: [dev6-core]

TASK: [jenkins | wait 60 seconds for port 8080 to become open on the host, do not start checking for 10 seconds] ***
skipping: [dev6-core]

TASK: [jenkins | Get Jenkins CLI] *********************************************
skipping: [dev6-core]

TASK: [jenkins | Get Jenkins CLI] *********************************************
skipping: [dev6-core]

TASK: [jenkins | Get Jenkins updates] *****************************************
skipping: [dev6-core]

TASK: [jenkins | Update-center Jenkins] ***************************************
skipping: [dev6-core]

TASK: [jenkins | 10s delay while installing plugins] **************************
skipping: [dev6-core]

TASK: [jenkins | Install/update plugins] **************************************
skipping: [dev6-core] => (item=ansicolor)
skipping: [dev6-core] => (item=ant)
skipping: [dev6-core] => (item=artifactory)
skipping: [dev6-core] => (item=backup)
skipping: [dev6-core] => (item=build-pipeline-plugin)
skipping: [dev6-core] => (item=copy-project-link)
skipping: [dev6-core] => (item=copy-to-slave)
skipping: [dev6-core] => (item=cvs)
skipping: [dev6-core] => (item=description-setter)
skipping: [dev6-core] => (item=email-ext)
skipping: [dev6-core] => (item=embeddable-build-status)
skipping: [dev6-core] => (item=external-monitor-job)
skipping: [dev6-core] => (item=git)
skipping: [dev6-core] => (item=git-client)
skipping: [dev6-core] => (item=github)
skipping: [dev6-core] => (item=github-api)
skipping: [dev6-core] => (item=greenballs)
skipping: [dev6-core] => (item=instant-messaging)
skipping: [dev6-core] => (item=ircbot)
skipping: [dev6-core] => (item=javadoc)
skipping: [dev6-core] => (item=jenkins-jira-issue-updater)
skipping: [dev6-core] => (item=jira)
skipping: [dev6-core] => (item=ldap)
skipping: [dev6-core] => (item=maven-plugin)
skipping: [dev6-core] => (item=mysql-auth)
skipping: [dev6-core] => (item=next-build-number)
skipping: [dev6-core] => (item=pam-auth)
skipping: [dev6-core] => (item=parameterized-trigger)
skipping: [dev6-core] => (item=phing)
skipping: [dev6-core] => (item=rebuild)
skipping: [dev6-core] => (item=seleniumhq)
skipping: [dev6-core] => (item=skip-certificate-check)
skipping: [dev6-core] => (item=ssh-slaves)
skipping: [dev6-core] => (item=subversion)
skipping: [dev6-core] => (item=svn-release-mgr)
skipping: [dev6-core] => (item=svn-tag)
skipping: [dev6-core] => (item=translation)
skipping: [dev6-core] => (item=viewVC)
skipping: [dev6-core] => (item=javadoc)
skipping: [dev6-core] => (item=translation)

TASK: [jenkins | ensure app directory] ****************************************
skipping: [dev6-core]

TASK: [jenkins | copying ssh config for jenkins  user] ************************
skipping: [dev6-core]

TASK: [jenkins | copying github keys for jenkins  user] ***********************
skipping: [dev6-core]

TASK: [jenkins | ssh know_hosts file for jenkins  user] ***********************
skipping: [dev6-core]

TASK: [varnish | installing package requirements] *****************************
ok: [dev6-core] => (item=varnish)

TASK: [varnish | create config script] ****************************************
ok: [dev6-core]

TASK: [varnish | create default script] ***************************************
changed: [dev6-core]

TASK: [varnish | setup  service] **********************************************
ok: [dev6-core]

NOTIFIED: [varnish | restart varnish] *****************************************
changed: [dev6-core]

PLAY RECAP ********************************************************************
dev6-core                  : ok=9    changed=2    unreachable=0    failed=0

#ansible-playbook -i PrivateCloud setup.yml -e 'target=dev6-core'

real  0m10.622s
user  0m0.876s
sys 0m0.644s
```
