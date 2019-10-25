# Lab VM setup

## Prerequisites

The following softwares have to be installed on you host machine (laptop)

- Git client [download here](https://git-scm.com/downloads)
- Virtualbox [download here](https://www.virtualbox.org/wiki/Downloads)
- Vagrant [download here](https://www.vagrantup.com/downloads.html)
- Bash command line (Git bash, Moba or Cygwin if you are on Windows) 

Some public services free subscriptions are needed 

- A GitHub account (https://github.com)
- A DockerHUB account (https://hub.docker.com)


## VM provisioning

Install Vagrant plugins

```console
$ vagrant plugin install vagrant-vbguest
$ vagrant plugin install vagrant-hostmanager
```

## Fork GitHub repo 

Fork the https://github.com/sunnyvale-academy/SNY.OSS.DCK.01.01.00 repo to your Github account.

Then clone the repo you forked (change <YOUR_GITHUB_USERNAME> and <GIT_REPO_NAME> placeholders accordingly)

```console
$ git clone https://github.com/<YOUR_GITHUB_USERNAME>/<GIT_REPO_NAME>.git
```

```console
$ cd <GIT_REPO_NAME>/vagrant/scripts
$ vi .env
```

Change the following variables into the file (GCP_SA_CREDENTIALS_FILENAME is the GCP json filename):

```console
export GIT_USERNAME=
export GIT_REPO_NAME=
```

Start the VM provisioning process

```console
$ cd <GIT_REPO_NAME>/vagrant
$ vagrant up
```

Enter into the newly born VM

```console
$ vagrant ssh
vagrant@docker-vm:~$ 
```

You are now ready for the next labs