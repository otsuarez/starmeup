
this playbook supports a multi-dc configuration.

to enable it, please, create a file on the conf/ folder named like the output of the hostname command for the nms of the datacenter.


installing lb script

```
cd /usr/local/bin
sudo ln -s /home/local/git/startmeup/release/scripts/a10cmd.py .
sudo ln -s /home/local/git/startmeup/release/scripts/secrets .
```


### known issues

On a multi-package installation, all the packages will be installed on the server pool corresponding to the pool of the first package on the list.

```
ansible-playbook -i IRIS zero.yml -e '{ "packages" : [{"name":"acme-event-handler","version":"1"},{"name":"acme-web-core","version":"1"}]}'
```

will install both packages on the dal pool since that's the acme-event-handler declared <code>pool_name</code>.
