# Memory limits

By default, a container has no resource constraints and can use as much of a given resource as the host’s kernel scheduler allows. Docker provides ways to control how much memory a container can use, setting runtime configuration flags of the `docker run` command.

If a capability is disabled in your kernel, you may see a warning at the end of the output like the following:

```
WARNING: No swap limit support
```

## Prerequisites

Having completed lab **00 - Setup lab environment**


## Connect to Sunnyvale's Ubuntu VM

```console
$ cd <GIT_REPO_NAME>/vagrant
$ vagrant up
$ vagrant ssh
vagrant@docker-vm:~$ 
```

## Test Linux support for memory limits

Test Docker support for memory limits

```console
vagrant@docker-vm:~$ docker info
...
WARNING: No swap limit support
``` 

Edit file **/etc/default/grub.d/50-cloudimg-settings.cfg** to add **cgroup_enable=memory swapaccount=1** flags. This will enable Linux kernel to support memory limits imposed by Docker.

```console
vagrant@docker-vm:~$ echo GRUB_CMDLINE_LINUX_DEFAULT=\"console=tty1 console=ttyS0 cgroup_enable=memory swapaccount=1\" | sudo tee  /etc/default/grub.d/50-cloudimg-settings.cfg
``` 

Apply the change and reboot 

```console
vagrant@docker-vm:~$ sudo update-grub 
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-4.4.0-146-generic
Found initrd image: /boot/initrd.img-4.4.0-146-generic
done
``` 

Now exit from the docker-vm machine 

```console
vagrant@docker-vm:~$ exit
logout
Connection to 127.0.0.1 closed.
```
and restart it

```console
$ vagrant halt docker-vm
...
```


```console
$ vagrant up docker-vm
...
```

Test with docker info again

```console
vagrant@docker-vm:~$ docker info
...

``` 
No warning is displayed at the end of the output, Linux is supporting Docker limits on memory as expected.


## Use Docler memory limits

Get the Docker Host (Ubuntu VM in this case) total memory available:

```console
vagrant@docker-vm:~$ cat /proc/meminfo | grep MemTotal
MemTotal:        1015768 kB
```

Run a container to test the Max Memory seen by a Java application

```console
vagrant@docker-vm:~$ docker run \
    --rm \
    -v $(pwd)/app:/app/ \
    openjdk:11.0-jdk \
    /usr/local/openjdk-11/bin/java \
    -XX:MaxRAMFraction=1 \
    /app/MaxMemory.java
Max Memory: 958
``` 

Run a container with `--memory 500m` flag (1/2 of the host's memory)

```console
vagrant@docker-vm:~$ docker run \
    --rm \
    --memory 500m \
    -v $(pwd)/app:/app/ \
    openjdk:11.0-jdk \
    /usr/local/openjdk-11/bin/java \
    -XX:MaxRAMFraction=1 \
    /app/MaxMemory.java
Max Memory: 483
``` 



