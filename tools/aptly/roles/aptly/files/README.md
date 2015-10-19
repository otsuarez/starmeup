

```
rls@rls-jenkins:~$ gpg --list-keys
/home/rls/.gnupg/pubring.gpg
----------------------------
pub   2048R/AB6A68AF 2014-05-05
uid                  ACMEs RLS Team <rls-team@acme.com>

rls@rls-jenkins:~$
```


```
mkdir gpg-keys ; cd $_
gpg --export-secret-key -a AB6A68AF >RLS-TEAM-GPG-KEY.private
gpg --export -a AB6A68AF >RLS-TEAM-GPG-KEY.public
```


# Importing a Private Key

If you wish to import your Private key to another server, or to restore from backup, the following imports your key:

```
gpg --import RLS-TEAM-GPG-KEY.private
```


```
root@infr-laptop8:/home/osvaldo/src/acme/servers/rls-jenkins/gpg-keys# gpg --import RLS-TEAM-GPG-KEY.private
gpg: key AB6A68AF: secret key imported
gpg: key AB6A68AF: public key "ACMEs RLS Team <rls-team@acme.com>" imported
gpg: Total number processed: 1
gpg:               imported: 1  (RSA: 1)
gpg:       secret keys read: 1
gpg:   secret keys imported: 1
root@infr-laptop8:/home/osvaldo/src/acme/servers/rls-jenkins/gpg-keys#
```

