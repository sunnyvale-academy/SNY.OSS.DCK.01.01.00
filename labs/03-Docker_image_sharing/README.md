# Docker image sharing

## Prerequisites

Having completed labs:
-  **00 - Setup lab environment**
-  **02 - Build your image**

Having a valid DockerHUB account (https://hub.docker.com)

# Share your Docker image

First login to DockerHUB public registry

```console
vagrant@docker-vm:~$ docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: dennydgl1
Password: 
WARNING! Your password will be stored unencrypted in /home/vagrant/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```

Tag your image. Before the image name, you have to put your docker account as a prefix

```console
vagrant@docker-vm:~$ docker tag friendlyhello:1.0 dennydgl1/friendlyhello:1.0
```

Check if the image has been tagged

```console
vagrant@docker-vm:~$ docker images
REPOSITORY                TAG                 IMAGE ID            CREATED             SIZE
dennydgl1/friendlyhello   1.0                 776174b5910f        24 minutes ago      148MB
friendlyhello             1.0                 776174b5910f        24 minutes ago      148MB
python                    2.7-slim            fc113e78155c        47 hours ago        138MB
hello-world               latest              fce289e99eb9        9 months ago        1.84kB
```
Now push the image to DockerHUB

```console
vagrant@docker-vm:~$ docker push dennydgl1/friendlyhello:1.0
The push refers to repository [docker.io/dennydgl1/friendlyhello]
a5e4cdbead83: Pushing [===>                                               ]  764.9kB/10.79MB
28000d1148a0: Pushing [==================================================>]  4.096kB
6e00b42983dd: Pushing  1.536kB
6fb7ce0ece77: Preparing 
3e27dc6a2fe0: Mounted from library/python 
bb8510b5f598: Waiting 
b67d19e65ef6: Waiting 
...
1.0: digest: sha256:fac5f4fdd96e4b35baf4ef6502c47606141eeeaad75ab84ae49c0c97457d0d26 size: 1787
```

If everyone in the class has pushed his own image, try to pull the image of the person next to you. To do so, ask him what his the fully qualified image name (i.e. dennydgl1/friendlyhello:1.0), then type:

```console
vagrant@docker-vm:~$ docker run -p 4000:80 <DockerHUB account>/<Image name>:<image version>
```

Be sure to change the placeholder <> accordingly.

Try to access the Python application as you have done in the previous lab





