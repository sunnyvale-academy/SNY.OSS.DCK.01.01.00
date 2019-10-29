# CPUs limits

By default, each container’s access to the host machine’s CPUs is unlimited. You can set various constraints to limit a given container’s access to the host machine’s CPUs.

## Prerequisites

Having completed lab **00 - Setup lab environment**


## Connect to Sunnyvale's Ubuntu VM

```console
$ cd <GIT_REPO_NAME>/vagrant
$ vagrant up
$ vagrant ssh
vagrant@docker-vm:~$ 
```


## Use Docler CPUs limits

Get the Docker Host (Ubuntu VM in this case) total CPUs available:

```console
vagrant@docker-vm:~$ cat /proc/cpuinfo | grep processor | wc -l 
2
```

Run a container to test the Max CPUs seen by a Java application

```console
vagrant@docker-vm:~$ docker run \
    --rm \
    -v /home/vagrant/$GIT_REPO_NAME/labs/16-CPU_limits/app:/app/ \
    openjdk:11.0-jdk \
    /usr/local/openjdk-11/bin/java \
    /app/MaxProcessors.java
Max Processors: 2
``` 

Run a container with `--cpus 1 flag (1/2 of the host's CPUs)

```console
vagrant@docker-vm:~$ docker run \
    --rm \
    --cpus 1 \
    -v /home/vagrant/$GIT_REPO_NAME/labs/16-CPU_limits/app:/app/ \
    openjdk:11.0-jdk \
    /usr/local/openjdk-11/bin/java \
    /app/MaxProcessors.java
Max Processors: 1
``` 



