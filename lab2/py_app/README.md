# Lab Day2 step by step
## Docker crash course v. 01.00

>download project from repository

`$ git clone https://github.com/sunnyvale-academy/SNY.OSS.DCK.01.01.00.git`

###### PYTHON APP

>Initialize VM with Vagrant

```
$ cd /lab2
$ vagrant up
$ vagrant ssh
$ cd /vagrant
$ sudo adduser docker_lab2
$ sudo usermode -aG docker docker_lab2
```

> Build app and creates Docker image

```
$ docker build -t nameimage:1.0 .
$ docker image ls
$ docker ps
$ docker ps -aG
```

> Run the app

`$ docker run -p 4000:80 nameimage:tag`

> Share Image (nb. Docker account needed)

```
$ docker login
$ docker tag imagename:tag username/newname:tag

# docker tag friendlyhello:1.0 michis/get_started:part1
```
Check that the image is correcly saved

```
$ docker image ls
$ docker push michis/get_started:part1
```

Check on Docker Hub it the image is present on your repository

[Docker Hub] (https://hub.docker.com)

Destroy VM and recreated a new one changing OS

```
$ vagrant destroy
$ mkdir new_vm && cd new_vm
$ cp ../lab2/Vagrantfile .
$ vi Vagrantfile # change config.vm.box ="ubuntu/xenial64" to config.vm.box ="centos/7" and IP and vm name
$ vagrant up
```
###### install Docker on Centos7

#Install needed packages:

`$ sudo yum install -y yum-utils device-mapper-persistent-data lvm2`

#Configure the docker-ce repo:

`$ sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo`

#Install docker-ce:

`$ sudo yum -y install docker-ce`

Set Docker to start automatically at boot time:

`$ sudo systemctl enable docker.service`

Finally, start the Docker service:

`$ sudo systemctl start docker.service`

###### run our App from Docker Hub

```
$docker run -p 4000:80 michis/get_started:part1
vagrant 
```





