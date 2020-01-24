# Walkthrough of Ansible Tower.

We will not provide direct access to Ansible Tower here, but rtaher, we will show you what we have set up to use from CEM

We have a `project` that is linked to a Git Repository

![ansible project](images/2020/01/ansible-project.png)

Create a new project

![create new project](images/2020/01/create-new-project.png)

The `https://github.com/rhine59/CEMAnsibleTowerIntegration.git` Git Repo contains Ansible `playbooks` in the `samples` directory.

```
.
├── README.md
├── nginx_container_start.yaml
├── nginx_container_stop.yaml
├── nginx_install.yaml
└── nginx_uninstall.yaml
```
We create a new Ansible `Job Template`

![job template](images/2020/01/job-template.png)

Complete the details

![template details](images/2020/01/template-details.png)

and then save it away.

So we now have two job `templates` in Ansible Tower that we can run under `root`. They each execute a `playbook`

![two job templates](images/2020/01/two-job-templates.png)

If you look at the playbooks, you will see that they are parameterised with values expected for `nginxname` and `nginxport`.

```
nginx_container_start.yaml

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

If you look again at the Ansible `template` you see that we have default values for these `playbook` variables at the end of the definition.

![default playbook variables](images/2020/01/default-playbook-variables.png)

Also the right of the template definition we ask to prompt for these values.

![prompt for values](images/2020/01/prompt-for-values.png)

So we are going run these templates.

![template list](images/2020/01/template-list.png)

To the right of the `template`, select the rocket.

![rocket](images/2020/01/rocket.png)

We are prompted to override the variable values.

![change values](images/2020/01/change-values.png)

next ...

![next](images/2020/01/next.png)

STDOUT from the running of the job shows success (EXTRACT)

```

PLAY [all] *********************************************************************
TASK [Run a command to start nginx container] **********************************
TASK [check acmenginx container status running on 11013] ***********************
TASK [debug] *******************************************************************
ok: [169.62.229.200] => {
    "finalout.stdout_lines": [
        "CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                  PORTS                   NAMES",
        "1cd2eab239db        nginx               \"nginx -g 'daemon of…\"   1 second ago        Up Less than a second   0.0.0.0:11013->80/tcp   acmenginx"
TASK [debug] *******************************************************************
ok: [169.62.229.200] => {
    "msg": "Access Nginx using http://169.62.229.200:11013"
PLAY RECAP *********************************************************************
169.62.229.200             : ok=5    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

a quick look at the target machines shows the running container.

```
root@fs20icamtest:~# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                   NAMES
1cd2eab239db        nginx               "nginx -g 'daemon of…"   2 minutes ago       Up 2 minutes        0.0.0.0:11013->80/tcp   acmenginx
```

So from the CEM console from the ICP console.

`Monitor Health` > `Incidents` > `Administration`

![CEM launch](images/2020/01/cem-launch.png)

takes you to

![administration](images/2020/01/administration.png)

The go to `runbooks`

Check out that under `Connections` we have a valid connection to `Ansible Tower`

![good connection](images/2020/01/good-connection.png)

Go to `Automations` and create a `New Automation`

![new automation1](images/2020/01/new-automation1.png)

Note that we coule edit the `extraVariables` to provide some defaults for what comes

![edit defaults](images/2020/01/edit-defaults.png)

Complete the details for both start and stop activities

![start and stop](images/2020/01/start-and-stop.png)

So let's now execute this `runbook` from CEM.

![runbook run](images/2020/01/runbook-run.png)

Select the `test` icon to right of the `nginx_container_start` automation.

This is where we have to provide the variable for this Job

![provide variables](images/2020/01/provide-variables.png)

we will provide variable values to this job

```
{ "nginxport" : "11003" , "nginxname" : "acmenginx" }
```

![apply and run nginx](images/2020/01/apply-and-run-nginx.png)

and then finally ...

from the coloured icon

![coloured](images/2020/01/coloured.png)

we select `run`

![run final](images/2020/01/run-final.png)

The automation runs to completion OK

![start ok](images/2020/01/start-ok.png)

```
root@fs20icamtest:~# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                   NAMES
1ddaaef79229        nginx               "nginx -g 'daemon of…"   2 minutes ago       Up 2 minutes        0.0.0.0:11003->80/tcp   acmenginx
root@fs20icamtest:~#
```
