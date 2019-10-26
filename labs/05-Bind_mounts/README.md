# Bind mounts

We will use a bind mount to compile a Java application, even without having a JDK installed!

## Prerequisites

Having completed labs **00 - Setup lab environment**

## Connect to Sunnyvale's Ubuntu VM

```console
$ cd <GIT_REPO_NAME>/vagrant
$ vagrant up
$ vagrant ssh
vagrant@docker-vm:~$ 
```

## Create a container to compile the source code

Here we create a container used to compile the Java source code (Main.java). 
Note the `-v` flag used to mount a host's directory with the source code into the container.

```console
vagrant@docker-vm:~$ docker run \
    --rm \
    -v /home/vagrant/$GIT_REPO_NAME/labs/05-Bind_mounts/app:/app/ \
    openjdk:7 javac -cp /app /app/Main.java
```

Now, if you list the host's directory content, you will see the Java compiled bytecode.

```console
vagrant@docker-vm:~$ ls -l /home/vagrant/$GIT_REPO_NAME/labs/05-Bind_mounts/app | grep class
-rw-r--r-- 1 vagrant vagrant 428 Oct 26 13:06 Main.class
```

## Create a container to run the byte code

We can also run the Java class using the same image, but with a different container

```console
vagrant@docker-vm:~$ docker run \
    --rm \
    -v /home/vagrant/$GIT_REPO_NAME/labs/05-Bind_mounts/app:/app/ \
    openjdk:7 java -cp / app.Main
Hello from a Java app!
```

NOTE: We do not have any JDK or JVM installed on the Docker Host (docker-vm)!

We used a bind mount to perform some operation with the container on a directory coming from the Docker host.

PAY ATTENTION when using bind mounts, if you perform a bad operation within the mount point, you can affect data on your Docker Host machine.

# RedOnly bind mounts

To make the bind mount read-only, 

```console
vagrant@docker-vm:~$ docker run \
    --rm \
    --mount type=bind,source=/home/vagrant/$GIT_REPO_NAME/labs/05-Bind_mounts/app,target=/app/,readonly \
    openjdk:7 java -cp / app.Main
Hello from a Java app!
```



