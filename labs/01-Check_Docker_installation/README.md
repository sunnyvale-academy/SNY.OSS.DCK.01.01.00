# Check Docker installation

## Prerequisites 

Having completed lab **00 - Setup lab environment**

## Connect to Sunnyvale's Ubuntu VM

```console
$ cd <GIT_REPO_NAME>/vagrant
$ vagrant up
$ vagrant ssh
vagrant@docker-vm:~$ 
```


## Checking Docker CLI to Docker Daemon communication
```console
vagrant@docker-vm:~$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```
You don't have any containers yet, but this is useful to prove the Docker CLI to Daemon communication.

## Inquiry the internal Docker registry for images (you should have none)

## Checking Docker internal registry

```console
vagrant@docker-vm:~$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
```

## Run your first container


```console
vagrant@docker-vm:~$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
1b930d010525: Pull complete 
Digest: sha256:c3b4ada4687bbaa170745b3e4dd8ac3f194ca95b2d0518b417fb47e5879d9b5f
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

If you see an output like this it means that:

- The Docker CLI contacted the Docker Daemon 
- The Docker Daemon searched for the **hello-world** image into the  internal registry (not finding it)
- The Docker Daemon pulled the image form the central Docker HUB registry
- Once the image has been pulled, the Docker Daemon created a new container, which in turn displayed the "Hello from Docker!" message


If you search the container

```console
vagrant@docker-vm:~$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```

Still no entries. It is because the container, once finished displaying the message, stopped running.

In this case, to see the stopped container use the ``-a`` flag

```console
vagrant@docker-vm:~$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
27a8a22cccf9        hello-world         "/hello"            5 minutes ago       Exited (0) 5 minutes ago                       gifted_dirac
```

What about the image just pulled? Finally, let's try to search for it

```console
vagrant@docker-vm:~$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
hello-world         latest              fce289e99eb9        9 months ago        1.84kB
```