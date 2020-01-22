# CEM / Ansible Tower Integration worked example

[Ansible Tower](https://fs20atsrv.169.62.229.236.nip.io/#/home)

admin / grey-hound-red-cardinal

Target Machine `ssh -i private_key root@169.62.229.200`

Ansible Users `user1` > `user50` password `alpine-has-acorn-valley`

[Cloud Event Manager](https://fs20icamlb.169.61.23.248.nip.io:8443)

admin / grey-hound-red-cardinal

## Setup and Ansible Project   

Link Project to Git Repository

![project to git](images/2020/01/project-to-git.png)

Add assets to Git

![sample git assets](images/2020/01/sample-git-assets.png)

Change `AnsibleTower/samples/nginx_container.yaml` to parameterise `port` and `container name`.

```
---
- hosts: all
  tasks:
    - name: check docker containers running before starting {{ nginxname }} container
      command: docker ps
      become: true
      register: out

    - debug: var=out.stdout_lines

    - name: Run a command to start docker nginx container
      command: docker run --name={{ nginxname }} -p {{ nginxport }}:80 -d nginx
      become: true

    - name: check {{ nginxname }} container status
      command: docker ps -f name={{ nginxname }}
      become: true
      register: finalout
```

Create or copy an Ansible Template

![ansible template](images/2020/01/ansible-template.png)

Complete details

NAME
PROJECT
PLAYBOOK
CREDENTIALS (prompt at launch check box)

![job details](images/2020/01/job-details.png)

MCM - `Monitor Health` > `Incidents` > `Administration` > `RunBooks Configured`

![runbooks configured](images/2020/01/runbooks-configured.png)

> `Automations`

![new automation](images/2020/01/new-automation.png)


![new ansible tower](images/2020/01/new-ansible-tower.png)

select `playbook` from Ansible `project`

![select playbook](images/2020/01/select-playbook.png)

Get Ansible `user` details

![ansible user](images/2020/01/ansible-user.png)

Get user index from web URL

`https://fs20atsrv.169.62.229.236.nip.io/#/credentials/3`

Note that the index for `user01` is `3`

From CEM `New Automation` you can provide default values or provide at runtime. I will provide a default value for the user but not the `port` or `container name`

![default values](images/2020/01/default-values.png)

![user01](images/2020/01/user01.png)

save away and see

![new automation created](images/2020/01/new-automation-created.png)

Select `test` against our new `automation`

![test new automation](images/2020/01/test-new-automation.png)

See we have one default value but others have to be completed

![default and to be completed](images/2020/01/default-and-to-be-completed.png)

value have to be valid json

`{ "nginxport" : "11033" , "nginxname" : "ACMEnginx" }`

Complete, apply and then run

![Apply and run](images/2020/01/apply-and-run.png)

![options](images/2020/01/options.png)

![run](images/2020/01/run.png)

Now look at the finished result

![finished result](images/2020/01/finished-result.png)

Here is our running containers

```
*** System restart required ***
Last login: Tue Jan 21 15:59:20 2020 from 169.62.229.236
root@fs20icamtest:~# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                   NAMES
2e5a2e47e0b3        nginx               "nginx -g 'daemon of…"   About a minute ago   Up About a minute   0.0.0.0:11033->80/tcp   ACMEnginx
ac0d4851025e        nginx               "nginx -g 'daemon of…"   43 minutes ago       Up 43 minutes       0.0.0.0:11122->80/tcp   user22-nginx
```

All done!
