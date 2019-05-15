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
$ sudo usermod -aG docker docker_lab2
$ su - docker_lab2
```

<!---
Create python app


```
$ mkdir py_app
$ cd py_app
$ touch Dockerfile
$ touch requirements.txt
$ touch app.py
$ copy and paste code inside file
```
-->

> Build app and creates Docker image

```
$ cd /vagrant/py_app
$ docker build -t nameimage .
$ docker image ls
# note there are two images, our "nameimage" and python, and note the tag:latest (default)
$ docker ps
$ docker ps -a
```

> Run the app

`$ docker run -p 4000:80 nameimage`

> Share Image (nb. Docker account needed)

```
$ docker login
$ docker tag nameimage username/newname

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
> Install Docker on Centos7

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

###### run our App, that was downloaded from Docker Hub

`$docker run -p 4000:80 michis/get_started:part1 `

Destroy VM






