# File System layering

A Docker image is built up from a series of layers. Each layer represents an instruction in the image’s Dockerfile. Each layer except the very last one is read-only.

The major difference between a container and an image is the top writable layer.

To view the approximate size of a running container, you can use the `docker ps -s` command. Two different columns relate to size.

- **size**: the amount of data (on disk) that is used for the writable layer of each container.

- **virtual size**: the amount of data used for the read-only image data used by the container plus the container’s writable layer size. Multiple containers may share some or all read-only image data. Two containers started from the same image share 100% of the read-only data, while two containers with different images which have layers in common share those common layers. Therefore, you can’t just total the virtual sizes. This over-estimates the total disk usage by a potentially non-trivial amount.

The total disk space used by all of the running containers on disk is some combination of each container’s size and the virtual size values. If multiple containers started from the same exact image, the total size on disk for these containers would be SUM (size of containers) plus one image size (virtual size- size).

These advantages are explained in more depth below.

## Prerequisites

Having completed lab **00 - Setup lab environment**

## Connect to Sunnyvale's Ubuntu VM

```console
$ cd <GIT_REPO_NAME>/vagrant
$ vagrant up
$ vagrant ssh
vagrant@docker-vm:~$ 
```

## Start the lab

When you use `docker pull` to pull down an image from a repository, or when you create a container from an image that does not yet exist locally, each layer is pulled down separately, and stored in Docker’s local storage area, which is usually `/var/lib/docker/` on Linux hosts. You can see these layers being pulled in this example:

```console
vagrant@docker-vm:~$ docker pull ubuntu:18.04
18.04: Pulling from library/ubuntu
22e816666fd6: Pull complete 
079b6d2a1e53: Pull complete 
11048ebae908: Pull complete 
c58094023a2e: Pull complete 
Digest: sha256:sha256:a7b8b7b33e44b123d7f997bd4d3d0a59fafc63e203d17efedf09ff3f6f516152
Status: Downloaded newer image for ubuntu:18.04
docker.io/library/ubuntu:18.04
```

Each of these layers is stored in its own directory inside the Docker host’s local storage area. To examine the layers on the filesystem, list the contents of /var/lib/docker/\<storage-driver\>. This example uses the overlay2 storage driver:

```console
vagrant@docker-vm:~$ sudo ls -l /var/lib/docker/overlay2
total 20
drwx------ 4 root root 4096 Oct 26 16:34 0c361d3cbfabcf112a9938ee1778fe48a8d7f9bee328ca923f1cea654fa096a6
drwx------ 3 root root 4096 Oct 26 16:34 289688776eedbf96f7453fe5b4a2fe38e480b37b56443bc0fbac05f128515d70
drwx------ 4 root root 4096 Oct 26 16:34 2d7cd4a4e238260dcb2e616c4431e0c41fd1e0e366704016cd04c87e887bf5e9
drwx------ 4 root root 4096 Oct 26 16:34 43ec209c341d03161fc9c5f6bc509cd3097e4e2bb6211fbda34bf1581e8465e6
drwx------ 2 root root 4096 Oct 26 16:34 l
```

Now imagine that you have two different Dockerfiles. You use the first one to create an image called acme/my-base-image:1.0.

```Dockerfile
FROM ubuntu:18.04
COPY . /app
```

Let's build the image

```console
vagrant@docker-vm:~$ docker build \
    -f /home/vagrant/$GIT_REPO_NAME/labs/07-FS_layering/Dockerfile-my-base-image \
    -t my-base-image:1.0 \
    /home/vagrant/$GIT_REPO_NAME/labs/07-FS_layering/
Sending build context to Docker daemon  9.728kB
Step 1/2 : FROM ubuntu:18.04
 ---> cf0f3ca922e0
Step 2/2 : COPY . /app
 ---> a41573846e14
Successfully built a41573846e14
Successfully tagged my-base-image:1.0
```

The second one is based on acme/my-base-image:1.0, but has some additional layers:

```Dockerfile
FROM ubuntu:18.04
COPY . /app
```

The second image contains all the layers from the first image, plus a new layer with the `CMD` instruction, and a read-write container layer. Docker already has all the layers from the first image, so it does not need to pull them again. The two images share any layers they have in common.

```Dockerfile
FROM my-base-image:1.0
CMD /app/hello.sh
```

Let's build the image:

```console
vagrant@docker-vm:~$ docker build \
    -f /home/vagrant/$GIT_REPO_NAME/labs/07-FS_layering/Dockerfile-my-image \
    -t my-image:1.0 \
    /home/vagrant/$GIT_REPO_NAME/labs/07-FS_layering/ 
Sending build context to Docker daemon  9.728kB
Step 1/2 : FROM my-base-image:1.0
 ---> a41573846e14
Step 2/2 : CMD /app/hello.sh
 ---> Running in 64a2bd915065
Removing intermediate container 64a2bd915065
 ---> bf4a122d437a
Successfully built bf4a122d437a
Successfully tagged my-image:1.0
```

If you build images from the two Dockerfiles, you can use `docker image ls` and `docker history` commands to verify that the cryptographic IDs of the shared layers are the same.

```console
vagrant@docker-vm:~$ docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
my-image            1.0                 bf4a122d437a        About a minute ago   64.2MB
my-base-image       1.0                 a41573846e14        2 minutes ago        64.2MB
ubuntu              18.04               cf0f3ca922e0        7 days ago           64.2MB
```

```console
vagrant@docker-vm:~$ docker history my-base-image:1.0
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
a41573846e14        3 minutes ago       /bin/sh -c #(nop) COPY dir:4173b2c77bbf93ad8…   4.74kB              
cf0f3ca922e0        7 days ago          /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B                  
<missing>           7 days ago          /bin/sh -c mkdir -p /run/systemd && echo 'do…   7B                  
<missing>           7 days ago          /bin/sh -c set -xe   && echo '#!/bin/sh' > /…   745B                
<missing>           7 days ago          /bin/sh -c [ -z "$(apt-get indextargets)" ]     987kB               
<missing>           7 days ago          /bin/sh -c #(nop) ADD file:d13b09e8b3cc98bf0…   63.2MB 
```

```console
vagrant@docker-vm:~$ docker history my-image:1.0
 docker history my-image:1.0
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
bf4a122d437a        3 minutes ago       /bin/sh -c #(nop)  CMD ["/bin/sh" "-c" "/app…   0B                  
a41573846e14        3 minutes ago       /bin/sh -c #(nop) COPY dir:4173b2c77bbf93ad8…   4.74kB              
cf0f3ca922e0        7 days ago          /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B                  
<missing>           7 days ago          /bin/sh -c mkdir -p /run/systemd && echo 'do…   7B                  
<missing>           7 days ago          /bin/sh -c set -xe   && echo '#!/bin/sh' > /…   745B                
<missing>           7 days ago          /bin/sh -c [ -z "$(apt-get indextargets)" ]     987kB               
<missing>           7 days ago          /bin/sh -c #(nop) ADD file:d13b09e8b3cc98bf0…   63.2MB     
```

Notice that all the layers are identical except the top layer of the second image. All the other layers are shared between the two images, and are only stored once in /var/lib/docker/. The new layer actually doesn’t take any room at all, because it is not changing any files, but only running a command.

When you start a container, a thin writable container layer is added on top of the other layers.

From a terminal on your Docker host, run the following docker run commands. The strings at the end are the IDs of each container.

```console
vagrant@docker-vm:~$ docker run --rm -dit --name my_container_1 my-image:1.0 bash \
  && docker run --rm -dit --name my_container_2 my-image:1.0 bash \
  && docker run --rm -dit --name my_container_3 my-image:1.0 bash \
  && docker run --rm -dit --name my_container_4 my-image:1.0 bash \
  && docker run --rm -dit --name my_container_5 my-image:1.0 bash
8c5e8475f2847ae5dad57aade17e2f37f1609a780336a944881a8312d4c351cc
a017a517da7422b98f7d442fc93bc35fbe18158d991a0b979ac8d4eff9232d3c
42c94dfa4cc22c0efa33a65c18f4e870c829f83f2a23ce56c7a87c134df18fc3
cad7c25ccb2ac3b02c7df7482a22ce2e4316b8fe040832e8874450e16843ed04
10f4fa2ca2e9881574259f47b84f094e07e79c0c1dc7bf3ec71fc49b09328509
``` 

Run the `docker ps` command to verify the 5 containers are running.

```console
vagrant@docker-vm:~$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS               NAMES
10f4fa2ca2e9        my-image:1.0        "bash"              About a minute ago   Up About a minute                       my_container_5
cad7c25ccb2a        my-image:1.0        "bash"              About a minute ago   Up About a minute                       my_container_4
42c94dfa4cc2        my-image:1.0        "bash"              About a minute ago   Up About a minute                       my_container_3
a017a517da74        my-image:1.0        "bash"              About a minute ago   Up About a minute                       my_container_2
8c5e8475f284        my-image:1.0        "bash"              About a minute ago   Up About a minute                       my_container_1
``` 

List the contents of the local storage area.

```console
vagrant@docker-vm:~$ sudo ls -l /var/lib/docker/containers
total 20
drwx------ 4 root root 4096 Oct 26 21:37 10f4fa2ca2e9881574259f47b84f094e07e79c0c1dc7bf3ec71fc49b09328509
drwx------ 4 root root 4096 Oct 26 21:37 42c94dfa4cc22c0efa33a65c18f4e870c829f83f2a23ce56c7a87c134df18fc3
drwx------ 4 root root 4096 Oct 26 21:37 8c5e8475f2847ae5dad57aade17e2f37f1609a780336a944881a8312d4c351cc
drwx------ 4 root root 4096 Oct 26 21:37 a017a517da7422b98f7d442fc93bc35fbe18158d991a0b979ac8d4eff9232d3c
drwx------ 4 root root 4096 Oct 26 21:37 cad7c25ccb2ac3b02c7df7482a22ce2e4316b8fe040832e8874450e16843ed04
``` 

```console
vagrant@docker-vm:~$ vagrant@docker-vm:~$ sudo su
root@docker-vm:/home/vagrant# du -sh  /var/lib/docker/containers/*
36K     /var/lib/docker/containers/10f4fa2ca2e9881574259f47b84f094e07e79c0c1dc7bf3ec71fc49b09328509
36K     /var/lib/docker/containers/42c94dfa4cc22c0efa33a65c18f4e870c829f83f2a23ce56c7a87c134df18fc3
36K     /var/lib/docker/containers/8c5e8475f2847ae5dad57aade17e2f37f1609a780336a944881a8312d4c351cc
36K     /var/lib/docker/containers/a017a517da7422b98f7d442fc93bc35fbe18158d991a0b979ac8d4eff9232d3c
36K     /var/lib/docker/containers/cad7c25ccb2ac3b02c7df7482a22ce2e4316b8fe040832e8874450e16843ed04
``` 
Each of these containers only takes up 36K of space on the filesystem.

Stop all containers

```console
vagrant@docker-vm:~$ docker stop $(docker ps -q)
10f4fa2ca2e9
cad7c25ccb2a
42c94dfa4cc2
a017a517da74
8c5e8475f284
``` 

