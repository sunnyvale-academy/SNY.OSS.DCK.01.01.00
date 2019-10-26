# Bridge network model

In terms of Docker, a bridge network uses a software bridge which allows containers connected to the same bridge network to communicate, while providing isolation from containers which are not connected to that bridge network.

Bridge networks apply to containers running on the __same Docker daemon host__. 


## Prerequisites

Having completed labs **00 - Setup lab environment**

## Connect to Sunnyvale's Ubuntu VM

```console
$ cd <GIT_REPO_NAME>/vagrant
$ vagrant up
$ vagrant ssh
vagrant@docker-vm:~$ 
```

## Test the **Bridge network model**

 
```console
vagrant@docker-vm:~$ docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
8c46c98fe79a        bridge              bridge              local
3a6f3fe18c4f        host                host                local
fd80ced7cf5a        none                null                local
```

```console
vagrant@docker-vm:~$ docker network inspect bridge | grep Subnet
            "Subnet": "172.17.0.0/16"
```

The subnet 172.17.0.0/16 is allocated for this bridge network by default (IP Range: 172.17.0.0 – 172.17.255.255).

```console
vagrant@docker-vm:~$ docker run \
    --rm \
    -it \
    --net bridge \
    busybox \
    ifconfig
eth0      Link encap:Ethernet  HWaddr 02:42:AC:11:00:02  
          inet addr:172.17.0.2  Bcast:172.17.255.255  Mask:255.255.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:3 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:258 (258.0 B)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
```

```console
vagrant@docker-vm:~$ docker run \
    --rm \
    -it \
    --net bridge \
    busybox \
    ping 8.8.8.8
64 bytes from 8.8.8.8: seq=0 ttl=61 time=133.184 ms
64 bytes from 8.8.8.8: seq=1 ttl=61 time=14.080 ms
64 bytes from 8.8.8.8: seq=2 ttl=61 time=37.155 ms
64 bytes from 8.8.8.8: seq=3 ttl=61 time=122.273 ms
64 bytes from 8.8.8.8: seq=4 ttl=61 time=12.951 ms
64 bytes from 8.8.8.8: seq=5 ttl=61 time=30.468 ms
```

Let's create a new bridge network

```console
vagrant@docker-vm:~$ docker network create \
    --driver bridge \
    my_bridge_network
501a1068b17b08d9e96db8e905f559922f2d15730a9084dba9e97682f7925ac9
```

```console
vagrant@docker-vm:~$ docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
8c46c98fe79a        bridge              bridge              local
3a6f3fe18c4f        host                host                local
501a1068b17b        my_bridge_network   bridge              local
fd80ced7cf5a        none                null                local
```

```console
vagrant@docker-vm:~$ docker network inspect my_bridge_network | grep Subnet
                    "Subnet": "172.18.0.0/16",
```

Fire up a new container on the default bridge network

```console
vagrant@docker-vm:~$ docker run \
    --rm \
    -d \
    --name container_1  \
    --net bridge \
    busybox \
    sleep 1000
9bff97fe17619f01b8ab372f3e3715316409b446d1624aeafe74ec276a2bae84
```

Now  start a container (container_2) attached to the new my_bridge_network

```console
vagrant@docker-vm:~$ docker run \
    --rm \
    -d \
    --name container_2  \
    --net my_bridge_network \
    busybox \
    sleep 1000
1b3ec398c29c33046d01da35b55a557a407529a19870e0d1e623fd7b8d7bfd47
```

Let's start another container (container_3) attached to my_bridge_network

```console
vagrant@docker-vm:~$ docker run \
    --rm \
    -d \
    --name container_3  \
    --net my_bridge_network \
    busybox \
    sleep 1000
e2710a77347f9486c044585c8673a8ab1cf5f92d3bd2ef76cf50ae19b3447e4b
```
As you can see, only container_2 is visible from within container_3 (they share the same bridge network):

```console
vagrant@docker-vm:~$ docker exec -ti container_3 /bin/ash
/ # ping container_2
PING container_2 (172.18.0.2): 56 data bytes
64 bytes from 172.18.0.2: seq=0 ttl=64 time=0.058 ms
64 bytes from 172.18.0.2: seq=1 ttl=64 time=0.085 ms
64 bytes from 172.18.0.2: seq=2 ttl=64 time=0.136 ms
64 bytes from 172.18.0.2: seq=3 ttl=64 time=0.077 ms
/ # ping container_1
ping: bad address 'container_1'
```

Docker has a feature which allows us to connect a container to another network.

```console
vagrant@docker-vm:~$ docker network connect bridge container_3
```


```console
vagrant@docker-vm:~$ docker exec -it container_3 ifconfig
eth0      Link encap:Ethernet  HWaddr 02:42:AC:12:00:03  
          inet addr:172.18.0.3  Bcast:172.18.255.255  Mask:255.255.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:18 errors:0 dropped:0 overruns:0 frame:0
          TX packets:10 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:1500 (1.4 KiB)  TX bytes:702 (702.0 B)

eth1      Link encap:Ethernet  HWaddr 02:42:AC:11:00:03  
          inet addr:172.17.0.3  Bcast:172.17.255.255  Mask:255.255.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:8 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:648 (648.0 B)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:8 errors:0 dropped:0 overruns:0 frame:0
          TX packets:8 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1 
          RX bytes:633 (633.0 B)  TX bytes:633 (633.0 B)
```

We can see container_3 has one extra network interface which is exactly within the range of our old bridge network.

Search for the container_1 IP address

```console
docker inspect container_1 | grep -i IPAddress\" | sed -e "s/ //g" | uniq
"IPAddress":"172.17.0.2",
```

Try to ping container_1's IP address from the custom my_bridge_network

```console
vagrant@docker-vm:~$ docker exec -ti container_3 ping 172.17.0.2
PING 172.17.0.2 (172.17.0.2): 56 data bytes
64 bytes from 172.17.0.2: seq=0 ttl=64 time=0.089 ms
64 bytes from 172.17.0.2: seq=1 ttl=64 time=0.081 ms
64 bytes from 172.17.0.2: seq=2 ttl=64 time=0.166 ms
64 bytes from 172.17.0.2: seq=3 ttl=64 time=0.244 ms
```

It worked!

Dosconnect container_3 from the default bridge newtork

```console
vagrant@docker-vm:~$ docker network disconnect bridge container_3
```

Re-test the ping against container_1's ip address

```console
vagrant@docker-vm:~$ docker exec -ti container_3 ping 172.17.0.2
PING 172.17.0.2 (172.17.0.2): 56 data bytes
^C
--- 172.17.0.2 ping statistics ---
6 packets transmitted, 0 packets received, 100% packet loss
```

Now container_3 is unable to ping container_1 on the default bridge network.


