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
