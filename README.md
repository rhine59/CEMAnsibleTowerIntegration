# CEM / Ansible Tower Integration worked example

[Ansible Tower](https://fs20atsrv.169.62.229.236.nip.io/#/home)

credentials `admin / grey-hound-red-cardinal`

Target Machine `ssh -i private_key root@169.62.229.200`

Ansible Users `user1` > `user50` password `alpine-has-acorn-valley`

`user1` > `user50` password `alpine-has-acorn-valley`

[ICP Login](https://icp-console.apps.169.61.23.248.nip.io/oidc/login.jsp)

credentials `admin / grey-hound-red-cardinal`

[Cloud Event Manager](https://icp-console.apps.169.61.23.248.nip.io/cemui/administration)

## Setup and Ansible Project   

## Ansible Tower Configuration - Step by Step

1. Create an Inventory - “Demo Setup” Inventory is already created
2. Create a Host - “169.62.229.200” target host is already created.
3. Create a Credential - “root” credential is already created.
4. Setting up a Project
5. Create a Job Template
6. Trigger the Job

### 1. Setting up a Project

Link Project to Git Repository

![project to git](images/2020/01/project-to-git.png)

Add assets to Git

![sample git assets](images/2020/01/sample-git-assets.png)

Change `AnsibleTower/samples/nginx_container.yaml` to parameterise `port` and `container name`.

```
---
- hosts: all
  tasks:
    - name: Run a command to start nginx container
      command: docker run --name={{ nginxname }} -p {{ nginxport }}:80 -d nginx
      become: true

    - name: check {{ nginxname }} container status running on {{ nginxport }}
      command: docker ps -f name={{ nginxname }}
      become: true
      register: finalout
    - debug: var=finalout.stdout_lines

    - debug:
        msg: Access Nginx using http://169.62.229.200:{{ nginxport }}
```

### 2. Create or copy an Ansible Template

![ansible template](images/2020/01/ansible-template.png)

Complete details

NAME
PROJECT
PLAYBOOK
CREDENTIALS (prompt at launch check box)

![job details](images/2020/01/job-details.png)

### 3. Trigger the Job from MCM RunBook

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

Make sure you add a `PASSWORD` for your user

![user password](images/2020/01/user-password.png)

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
