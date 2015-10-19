# create\_repo.sh

    ./create_repo.sh <repository-name>

This script will check if a repo exists and creates it if not.

A repository for each environment will be created:

* testing
* staging
* prod

The new repositories will have support for 3 architectures:

* i386
* amd64
* noarch

It will also create a dummy package for each architecture and upload it to the repo. 


# create\_pkgs.sh

```
$ sudo dpkg -i dummy-package_0.0.2_all.deb
$ tail -f /var/log/syslog | grep "acme package"
```

```
Sep 11 16:45:47 infr-laptop8 osvaldo: acme package installation about to begin for dummy-package version 0.0.2 iteration
Sep 11 16:45:48 infr-laptop8 osvaldo: acme package installation finished for dummy-package version 0.0.2 iteration
```

```
$ sudo apt-get remove dummy-package
$ tail -f /var/log/syslog | grep "acme package"
```

```
Sep 11 16:47:18 infr-laptop8 logger: acme package files removal about to begin for dummy-package version 0.0.2 iteration
Sep 11 16:47:18 infr-laptop8 logger: acme package files removal finished for dummy-package version 0.0.2 iteration
```

