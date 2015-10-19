# tl;dr

* the team jenkins server [build component job (http://jenkins-rls.acme.com/job/Build\_Octopush\_Artifact/)](http://jenkins-rls.acme.com/job/Build_Octopush_Artifact/)
* will triggers the [push artifact job (http://jenkins-rls.acme.com/job/Push\_Artifact/)](http://jenkins-rls.acme.com/job/Push_Artifact/)
* which triggers the main jenkins server [create package job (http://jenkins.acme.com/job/Create\_Package/)](http://jenkins.acme.com/job/Create_Package/)
* which create the package using the ansible playbook [package (https://github.com/acme-dot-io/playbooks/tree/master/package)](https://github.com/acme-dot-io/playbooks/tree/master/package)
* and also publish it package on the [apt repository](http://jenkins.acme.com/apt/)

so servers can install the package using an ansible playbook ... to be continued ... (check ../release folder ;)

# Naming Schema

Package names used the following schema:

~~~
<company>-<package-name>-<semver = major.minor.jenkins_job_package_create_build_number>-<branch>-<commit sha>
~~~

That convention allows us to quickly identify which build the package was created on the jenkins server as well as the commit in the repository.

A simple <code>rpm -ql | grep <company-name></code> will show installed packages (dpkg -l for debian/ubuntu users).

# Plugin architecture

The source and the output are declared as plugins. Examples of sources are svn and git repositories, an artifactory repository. Output are native packages, for now, deb or rpm (as supported by aptly).

# Native packages

The packages were composed by diverse kind of filetypes. A package could contained a single jar file, or a bunch of php files. Any combination was possible via the configuration files for the components.

# Variables

Variables are defined in yaml files inside the <strong>group_vars</strong> directory. The <strong>group_vars/all</strong> contains the global variables while on <strong>group_vars/"component"</strong> files will be the configuracion for each component.

Variables are stored under the <code>group\_vars</code> folder.

## group\_vars/*

Usually several components belongs to the same project. That information can be grouped in a <code>common-\*</code> file. Then, individual files for each component will exist.

The actual content (files, etc)  of the component can be retrieved from diferent sources. The information about those sources in variables stored in the <code>input-\*</code> files.

Example of input files are <code>input-github.yml </code> and <code>input-main\_jfrog.yml</code>.


The resulting output (a native package) will be stored somethere. The information about those places is stored in the <code>input-\*</code> files.


|variable|defined in|description|
|--------|----------|-----------|
|component_input_type|all,common-,component|define the input-* file to be used|
|input_type|input-|define the task file to be used for processing the source of the code|


```
# before
   get\_url: url=http://admin:secret@jfrog.acme.com/artifactory/simple/{{ component }}/{{ component }}-{{ version }}.zip dest=/var/tmp/{{ component }}/ mode=0440
# after
   get\_url: url=http://{{ jfrog_admin_user }}:{{ jfrog_admin_password }}@{{ jfrog_url }}/{{ component_uri }}/{{ artifact_filename }} dest={{ pkg_tmp_dir }}/{{ component }}/ mode=0440
```

# Workflow

## Components

* @team jenkins server
  * Build_"component" job
  * Push_Artifact_"component" job
* @main jenkins server
  * Create_Package job
  * ansible playbook

Current workflow starts at the jenkins Team server which have a job which downloads the code, proccess it, creates an artifact and triggers another job, called Push_Artifact_"component" which takes care of the artifacts deployment.

The Push_Artifact job pulls the [jenkins-scripts](https://github.com/acme-dot-io/jenkins-scripts) repository and executes an script from the repository.

Proposed workflow does the same, only executing a different script: [push_artifact.sh](https://github.com/acme-dot-io/jenkins-scripts/blob/master/push_artifact.sh). This scripts will trigger a job on the main jenkins server: [Create_Package](jenkins.acme.com/job/Create_Package/).

The Create_Package job follows the same standard downloading the jenkins-scripts repository executing the [create_package.sh](https://github.com/acme-dot-io/jenkins-scripts/blob/master/create_package.sh) script.

The create_package.sh script is executed on the main jenkins server's node named jenkins-rls-as-rls-user which does as its name implies. Execute commands on the jenkins server as the rls user. This was done in order to simplify configuration and avoid loops of su's and sudo's. Sources the __.bash_profile__ file in order to be able to execute the fpm gem and executes the playbook defined in [package](https://github.com/acme-dot-io/playbooks/tree/master/package) on the __/home/local/git/playbooks__ directory.

# apt repository



The octopush package versions can be found [here: http://jenkins.acme.com/apt/pool/main/o/octopush/](http://jenkins.acme.com/apt/pool/main/o/octopush/).


# installing the package on a server

Example source list file for using the apt repository

```
#/etc/apt/sources.list.d/acme-rls.list
deb http://jenkins.acme.com/apt acme main
```

Example output showing available versions of octopush package

```
$ sudo apt-get update
$ apt-cache madison octopush
  octopush | 1.0.277-master-646a561 | http://jenkins.acme.com/apt/ acme/main all Packages
  octopush | 1.0.275-master-646a561 | http://jenkins.acme.com/apt/ acme/main all Packages
  octopush | 1.0.274-master-646a561 | http://jenkins.acme.com/apt/ acme/main all Packages
  octopush | 1.0.273-master-646a561 | http://jenkins.acme.com/apt/ acme/main all Packages
  octopush | 1.0.270-master-646a561 | http://jenkins.acme.com/apt/ acme/main all Packages
  octopush | 0.0.47139-master-646a561 | http://jenkins.acme.com/apt/ acme/main all Packages
  octopush | 0.0.1-master-b803df7 | s3://s3-us-west-2.amazonaws.com/c2c-rls-deploy-packages/ stable/main all Packages
$
```

# S3 Apt repository

Install s3 tools and configure with provided credentials.

```
sudo apt-get install s3cmd
s3cmd --configure
s3cmd ls s3://c2c-rls-deploy-packages
```

When executing the <code>ls</code> command the bucket should be specified since the credentials has only access to that bucket.


The <code>[deb-s3](https://github.com/krobertson/deb-s3)</code> was checked but it won't allow for having multiple versions available on the s3 repository. The chosen solution was to use the <code>[aptly](aptly.info)</code> tool (which does permits having multiple versions of a package in a repository) and the <code>[s3 tools](http://s3tools.org/s3cmd)</code> for syncn'ing the aptly published repository to s3.

Since we we're already using aptly the same set of commands can used. Besides, S3 storage is scheduled to be available on the next release of aptly.

For uploading the new package a sync is done

```
s3cmd sync /var/lib/aptly/public s3://c2c-rls-deploy-packages
```

File <code>/etc/apt/sources.list.d/s3-c2c.list</code>

```
deb [arch=all] s3://AKGAJCKYAPJUGOCUTW5A:[Dz36H0rs8dLSSNmsgj6YoY7k1BwDh4Ug8WU44ZnW]@s3-us-west-2.amazonaws.com/c2c-rls-deploy-packages stable main
deb [arch=all] s3://AKGAJCKYAPJUGOCUTW5A:[Dz36H0rs8dLSSNmsgj6YoY7k1BwDh4Ug8WU44ZnW]@s3-us-west-2.amazonaws.com/c2c-rls-deploy-packages/public acme main
```

update only s3 repository package listing and check versions

```
sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/s3-c2c.list" -o Dir::Etc::sourceparts="-" \
-o APT::Get::List-Cleanup="0"
apt-cache madison octopush
```

# package scripts

Native packages allows for the execution of scripts on four events:

* before package installation is finished
* after package installation begins
* before package removal is finished
* after package removal begins

## playbook task

<code>roles/packaging/tasks/init-scripts.yml</code>

## variables

```
pkg_use_init_scripts: false
init_scripts_rootdir: /home/local/git/init-scripts/
pkg_script_opts: --template-scripts
pkg_script_files_opt: { preinst: '--before-install', postinst: '--after-install ', prerm: '--before-remove ', postrm: '--after-remove ' }
```

In order to execute commands during a package operation the following variable should be setup:

```
pkg_scripts_setup: true
```

If the package will include the init script, the following variable should be declared as:

```
pkg_conffiles_setup
```

## workflow

*  Declare the component package will use scripts

Set the variable <code>pkg_use_init_scripts: true</code> in <code>group_vars/common-<component></code> file.

# Package Role

## scripts

There are two different set of scripts. The scripts executed by the package during the installation or removal and the scripts which are installed on the server to provide funcionality like start/stop the service.

Not all packages will require both set of scripts. Configuracion packages will require the restart of the service (a reload might be enough) but would not require to install the init script for the service.

Since the package scripts are native to the system (redhat - rpm, debian -deb) a different file will be used on each case. For files which are going to be deployed, the task file will be shared.

The scripts are stored in the [pkg-scripts](https://github.com/acme-dot-io/pkg-scripts) github repository.

```
- include: pkg-scripts.yml
  when: pkg_scripts_setup

- include: pkg-conffiles.yml
  when: pkg_conffiles_setup
```

# Publishing to repositories

The repository

Each branch can be deployed to one or more repositories and will be defined under the key <code>component_package_publish</code> and the subkey <code>branch</code>.

The following example is for the <code>master</code> branch.

```
component_output: deb
component_publish_target: main_apt

# jfrog
component_jfrog_uri: infra-dc

component_deploy_dir: puppet

component_package_publish:
  branch:
    master:
      aptly:
        - { "repo" : "staging", "distribution": "acme-staging", "endpoint" : "staging" }
        - { "repo" : "static-images", "distribution": "acme-static-images", "endpoint" : "s3:static-images:" }
```

      Important: If the branch names contains any dash character: "-", it should be replace with underscore when declaring it on the <code>component_package_publish.branch</code> key name. 

## IRC notifications

```
component_notification_irc_room:
```


# Repository
# workflow

```
aptly repo create -architectures="amd64,i386,noarch" -comment="Staging Env Repository" -component="acme" -distribution="acme-staging" staging
aptly repo add staging <filename>
aptly publish repo staging staging
```

# scripts

```
scripts/create_repo.sh
```

# commands

```
aptly repo create -architectures="amd64,i386,noarch" -comment="Testing Environment Repository" -component="acme" -distribution="acme-testing" testing
aptly repo create -architectures="amd64,i386,noarch" -comment="Staging Environment Repository" -component="acme" -distribution="acme-staging" staging
aptly repo create -architectures="amd64,i386,noarch" -comment="Production Environment Repository" -component="acme" -distribution="acme-prod" prod
aptly repo create -architectures="amd64,i386,noarch" -comment="Testing Environment Repository" -component="acme" -distribution="acme-testing" testing-conf
aptly repo create -architectures="amd64,i386,noarch" -comment="Staging Environment Repository" -component="acme" -distribution="acme-staging" staging-conf
aptly repo create -architectures="amd64,i386,noarch" -comment="Production Environment Repository" -component="acme" -distribution="acme-prod" prod-conf

#aptly publish drop acme-staging staging
#aptly publish -architectures="amd64,i386,noarch" repo staging staging
#aptly publish -architectures="amd64,i386,noarch" repo staging-conf staging-conf
for env in testing staging prod
do
  aptly publish -architectures="amd64,i386,noarch" repo ${env} ${env}
  aptly publish -architectures="amd64,i386,noarch" repo ${env}-conf ${env}-conf
done

```

# stdout

```
osvaldo@laptop-laptop8:~$ aptly repo create -architectures="noarch" -comment="Staging Env Repository" -component="acme" -distribution="acme-staging" staging

Local repo [staging]: Staging Env Repository successfully added.
You can run 'aptly repo add staging ...' to add packages to repository.
osvaldo@laptop:~$
osvaldo@laptop:~$ aptly repo add staging /var/tmp/fpm/infr8app_0.0.1_i386.deb
Loading packages...
[+] infr8app_0.0.1_i386 added
osvaldo@laptop:~$
osvaldo@laptop:~$ aptly publish repo staging staging
Loading packages...
Generating metadata files and linking package files...
Signing file 'Release' with gpg, please enter your passphrase when prompted:
Clearsigning file 'Release' with gpg, please enter your passphrase when prompted:

Local repo staging has been successfully published.
Please setup your webserver to serve directory '/var/lib/aptly/public' with autoindexing.
Now you can add following line to apt sources:
  deb http://your-server/staging/ acme-staging acme
Don't forget to add your GPG key to apt with apt-key.

You can also use `aptly serve` to publish your repositories over HTTP quickly.
osvaldo@laptop:~$
````


# Targets

Each branch has a target repository by default. If a server in an environment installs a package from another environment, that will be considered an exception and treated it as such on that server side, not on the repository side. 

A package with two branches: master and develop will generally be installed on testing the develop branch code and in staging the master branch code. The octopush project, an rls team tool runs on a server located in the testing environment and it's development server is also located on the same environment. Besides, the code from the master branch is deployed directly into production and the code from develop is pushed to what would be considered the staging environment server.

In any case, packages will be created on the corresponding repository (testing for develop and staging for master). Each server will use then the right repository to install the code from.


