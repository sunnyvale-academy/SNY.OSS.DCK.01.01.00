# Lab Day1 step by step
## Docker crash course v. 01.00

###### VAGRANT INSTALLATION & OVERVIEW

Install vagrant
```
vagrant version
mkdir vagrant-quickstart
cd vagrant-quickstart
vagrant init
```
>Vagrantfile is added in folder -> Analyze Vagrantgile
[Vagrant boxes repository] (https://app.vagrantup.com/boxes/search)

```
rm Vagrantfile
vagrant init hashicorp/precise64
```
>note vagrant ssh 22 guest => 2222 host
```
vagrant status
vagrant ssh
```
>note information about VM and user: vagrant
```
cd /vagrant
touch new-file.txt
vagrant exit
```
>shared folder with host, you can see the created file in local folder

Command to stop, suspend, reload, remove VM
```
vagrant halt /vagrant suspend
vagrant reload (halt + up)
vagrant destroy
```

###### UPDATE BOXES

```
vagrant init ubuntu/trusty64
vagrant up && vagrant ssh
which git
sudo apt-get install git
```
>create custom Vagrant box using package command
```
vagrant package --output custom-trusty.box
vagrant box add Custom-Trusty custom-trusty.box
vagrant box list
```
>edit Vagrantfile changing box to Custom-Trusty
```
vagrant up
which git
```

###### PROVISIONING WITH VAGRANT

> git clone Lab1

```
cd prov_example
vagrant up
vagrant ssh
apache2 -v
curl -i http://127.0.0.1:80
```

###### DOCKER: OVERVIEW AND 'HELLO WORLD'

>check for docker installation by vagrant provisioning_apache2, add docker user

```
docker
sudo adduser docker_user
sudo usermod -aG docker docker_user
su docker_user
sudo systemctl start docker 
docker run hello-world
docker image ls
docker ps
docker ps -a
docker container ls
docker container ls -a
docker container inspect {ID}
```
