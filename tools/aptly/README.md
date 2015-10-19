# installing aptly

* edit inventory file
* execute <code> ansible-playbook aptly.yml -i inventory </code>


aptly in deviris1

```
connect-mecca
connect-office-iris-rls-1
# rls@deviris1
cd /home/local/git/playbooks/tools 
ansible-playbook -i inventory aptly.yml --limit deviris1
```
