# None network model


None network model:

- Provides the maximum level of network protection.
- Not a good choice if network or Internet connection is required.
- Suites well where the container require the maximum level of network security and network access is not necessary.

## Prerequisites

Having completed labs **00 - Setup lab environment**

## Connect to Sunnyvale's Ubuntu VM

```console
$ cd <GIT_REPO_NAME>/vagrant
$ vagrant up
$ vagrant ssh
vagrant@docker-vm:~$ 
```

Test the **None network model**

 
```console
vagrant@docker-vm:~$ docker run \
    --rm \
    -it \
    --net none \
    busybox \
    ifconfig
Unable to find image 'busybox:latest' locally
latest: Pulling from library/busybox
7c9d20b9b6cd: Pull complete 
Digest: sha256:fe301db49df08c384001ed752dff6d52b4305a73a7f608f21528048e8a08b51e
Status: Downloaded newer image for busybox:latest
lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
```

Test to reach internet

```console
vagrant@docker-vm:~$ docker run \
    --rm \
    -it \
    --net none \
    busybox \
    ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8): 56 data bytes
ping: sendto: Network is unreachable
```

There is only one network interface called Loopback. It is not connected to any networks.