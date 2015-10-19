## requirements

Edit <code>secrets</code> file according to the environment.

## list pools (service groups)

```

sysadmin@dc-iris-nms1 $ pwd
/usr/local/acme/startmeup/release/scripts
sysadmin@dc-iris-nms1 $
sysadmin@dc-iris-nms1 $ ./a10cmd.py list
app_tpl_dynamic_srvgrp
app_tpl_sal_srvgrp
app_tpl_abl_srvgrp
app_tpl_webapp_srvgrp
app_tpl_cal_srvgrp
sysadmin@dc-iris-nms1 $
```

## print members of a pool (service group)

```
sysadmin@dc-iris-nms1 $ ./a10cmd.py pool app_tpl_dynamic_srvgrp
web3
web2
web1
sysadmin@dc-iris-nms1 $ ./a10cmd.py pool app_tpl_webapp_srvgrp
webapp2
webapp1
sysadmin@dc-iris-nms1 $ 
```

## print pool status (service group)

```
sysadmin@dc-iris-nms1 # ./a10cmd_extend.py stats app_tpl_cal_srvgrp
All members Up! - cal2 up cal1 up
sysadmin@dc-iris-nms1 # ./a10cmd_extend.py stats app_tpl_dal_srvgrp
Functional Up - dal2 down dal1 up
```

## enable/disable servers in a pool

```
# listing active servers in the pool
sysadmin@dc-iris-nms1 $ ./a10cmd.py active app_tpl_dynamic_srvgrp
web2
web1
# let's disable web2 server in web pool
sysadmin@dc-iris-nms1 $ ./a10cmd.py disable app_tpl_dynamic_srvgrp web2
ok
# return status is printed
# now list active servers in the pool
sysadmin@dc-iris-nms1 $ ./a10cmd.py active app_tpl_dynamic_srvgrp
web1
# web2 is no more
# yet listing all servers in the pool show the whole bunch
sysadmin@dc-iris-nms1 $ ./a10cmd.py pool app_tpl_dynamic_srvgrp
web3
web2
web1
# enable web2 again
sysadmin@dc-iris-nms1 $ ./a10cmd.py enable app_tpl_dynamic_srvgrp web2
ok
# and it's active!
sysadmin@dc-iris-nms1 $ ./a10cmd.py active app_tpl_dynamic_srvgrp
web2
web1
sysadmin@dc-iris-nms1 $ 
```


## help

can be general

```
sysadmin@dc-iris-nms1 $ ./a10cmd.py -h
usage: a10cmd.py [-h] {list,pool,enable,disable} ...

A tool for interacting with A10.

positional arguments:
  {list,pool,enable,disable}
                        commands
    list                list the service groups
    pool                list servers in a service group
    enable              Enable a server in the pool
    disable             Disable a server in the pool

optional arguments:
  -h, --help            show this help message and exit
sysadmin@dc-iris-nms1 $ 
```

or specific for a subcommand with one argument ...

```
sysadmin@dc-iris-nms1 $ ./a10cmd.py pool -h
infr-macbook8:scripts osvaldo$ ./a10cmd.py pool -h
usage: a10cmd.py pool [-h] pool

positional arguments:
  pool        Pool Name

optional arguments:
  -h, --help  show this help message and exit
sysadmin@dc-iris-nms1 $ 
```

or two ...

```
sysadmin@dc-iris-nms1 $ ./a10cmd.py enable -h
usage: a10cmd.py enable [-h] pool server

positional arguments:
  pool        Pool Name
  server      Server Name

optional arguments:
  -h, --help  show this help message and exit
sysadmin@dc-iris-nms1 $
```


