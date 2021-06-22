# Java Docker awareness

## Prerequisites

Having completed lab **00 - Setup lab environment**


## Connect to Sunnyvale's Ubuntu VM

```console
$ cd <GIT_REPO_NAME>/vagrant
$ vagrant up
$ vagrant ssh
vagrant@docker-vm:~$ 
```

## Let's test:

### Machine setup

The host VM has been created with the following computing resources.

RAM:

```console
$ vagrant@docker-vm:~$ cat /proc/meminfo | grep MemTotal | awk '{print $2}' | echo $(</dev/stdin)/1000 | bc
1024
```

CPU:

```console
$ vagrant@docker-vm:~$ cat /proc/cpuinfo | grep processor | wc -l 
2
```

### Java 8

Build the Docker image:

```console
$ vagrant@docker-vm:~$ docker build \
                              -t docker-test:jdk8 \
                              -f Dockerfile.jdk8 .
Sending build context to Docker daemon  11.78kB
Step 1/4 : FROM openjdk:8u151
8u151: Pulling from library/openjdk
c73ab1c6897b: Pull complete 
1ab373b3deae: Pull complete 
b542772b4177: Pull complete 
57c8de432dbe: Pull complete 
da44f64ae999: Pull complete 
0bbc7b377a91: Pull complete 
1b6c70b3786f: Pull complete 
48010c1717c7: Pull complete 
7a6123cacadf: Pull complete 
Digest: sha256:07780244fce9b0a3b13a138adf45226372a80025c74bf81ce2bd509304d7a253
Status: Downloaded newer image for openjdk:8u151
 ---> a30a1e547e6d
Step 2/4 : COPY java/DockerTest.java /
 ---> 239a06680b29
Step 3/4 : RUN javac /DockerTest.java
 ---> Running in 723c632dcf88
Removing intermediate container 723c632dcf88
 ---> 049753418a49
Step 4/4 : CMD java ${JAVA_OPT} DockerTest ${APP_OPT}
 ---> Running in eaf49b8e9f2c
Removing intermediate container eaf49b8e9f2c
 ---> 4b6bd478bf76
Successfully built 4b6bd478bf76
Successfully tagged docker-test:jdk8
```

Now run the application:

```console
$ vagrant@docker-vm:~$ docker run \
                              --rm \
                              docker-test:jdk8
System properties
Cores       : 2
Memory (Max): 239
```

Initially, when the Java 8 container starts, it sees 2 cores and allocates 239MB of memory (1024/4=256). Now let’s try to limit the resources and see the results.

```
vagrant@docker-vm:~$ docker run \
                        --rm \
                        -c 512 \
                        -m 512MB \
                        docker-test:jdk8

System properties
Cores       : 2
Memory (Max): 239
```
Here the -c 512 sets the CPU Shares to 512, which advises using half of the available CPU time. And the -m 512MB limits the memory to given number. As expected, these arguments are not working in this Java version.

However, Java 8 update 151 has the CPU Sets improvement. This time let’s try with setting the --cpuset-cpus to a single core.

```
vagrant@docker-vm:~$ docker run \
                        --rm \
                        --cpuset-cpus 0 \
                        -m 512MB \
                        docker-test:jdk8

System properties
Cores       : 1
Memory (Max): 239
```
And it’s working. This version also allows us to use the -XX:+UseCGroupMemoryLimitForHeap option to get the correct memory limit.

```
vagrant@docker-vm:~$ docker run \
                        --rm \
                        --cpuset-cpus 0 \
                        -m 512MB \
                        -e JAVA_OPT="-XX:+UnlockExperimentalVMOptions \
                        -XX:+UseCGroupMemoryLimitForHeap" \
                        docker-test:jdk8

System properties
Cores       : 1
Memory (Max): 123
```
With the help of this options, finally, 123MB of heap space is allocated, which perfectly makes sense for the upper limit of 512MB.

### Java 9

Just build the Docker image with JDK9 runtime:


```console
$ vagrant@docker-vm:~$ docker build \
                              -t docker-test:jdk9 \
                              -f Dockerfile.jdk9 .
Sending build context to Docker daemon  15.36kB
Step 1/8 : FROM ubuntu:latest
 ---> 9873176a8ff5
Step 2/8 : RUN  apt-get update
 ---> Using cache
 ---> 16042bf9a0ad
Step 3/8 : RUN  apt-get --assume-yes install wget
 ---> Using cache
 ---> 15e5a3282647
Step 4/8 : RUN  wget https://download.java.net/java/GA/jdk9/9.0.4/binaries/openjdk-9.0.4_linux-x64_bin.tar.gz
 ---> Using cache
 ---> ec8ef5758ee9
Step 5/8 : RUN  tar -zxvf openjdk-9.0.4_linux-x64_bin.tar.gz
 ---> Using cache
 ---> 4be8b1a997d1
Step 6/8 : COPY java/DockerTest.java /
 ---> Using cache
 ---> 164077c2ec36
Step 7/8 : RUN /jdk-9.0.4/bin/javac /DockerTest.java
 ---> Running in 2a166b2f3175
Removing intermediate container 2a166b2f3175
 ---> d5ebfc0a09fe
Step 8/8 : CMD  /jdk-9.0.4/bin/java ${JAVA_OPT} DockerTest ${APP_OPT}
 ---> Running in e97db880d840
Removing intermediate container e97db880d840
 ---> 3e2ff7ba4360
Successfully built 3e2ff7ba4360
Successfully tagged docker-test:jdk9
```

It would be enough to repeat the last step from the previous section since the functionality is same.

```
vagrant@docker-vm:~$ docker run \
                        --rm \
                        --cpuset-cpus 0 \
                        -m 512MB \
                        -e JAVA_OPT="-XX:+UnlockExperimentalVMOptions \
                        -XX:+UseCGroupMemoryLimitForHeap" \
                        docker-test:jdk9

System properties
Cores       : 1
Memory (Max): 123
```

As expected, Java 9 recognized the CPU Sets and the memory limits when -XX:+UseCGroupMemoryLimitForHeap is used.

### Java 10


Build the Docker image with JDK 10 in it:

```
vagrant@docker-vm:~$ docker build \
                        -t docker-test:jdk10 \
                        -f Dockerfile.jdk10 \
                        .
Sending build context to Docker daemon  19.97kB
Step 1/8 : FROM ubuntu:latest
 ---> 9873176a8ff5
Step 2/8 : RUN  apt-get update
 ---> Using cache
 ---> 16042bf9a0ad
Step 3/8 : RUN  apt-get --assume-yes install wget
 ---> Using cache
 ---> 15e5a3282647
Step 4/8 : RUN  wget https://download.java.net/java/GA/jdk10/10/binaries/openjdk-10_linux-x64_bin.tar.gz
 ---> Using cache
 ---> 4a1b1b94b533
Step 5/8 : RUN  tar -zxf openjdk-10_linux-x64_bin.tar.gz
 ---> Running in 751cfee80128
Removing intermediate container 751cfee80128
 ---> 153b61a8a2c0
Step 6/8 : COPY java/DockerTest.java /
 ---> b262cc3163d8
Step 7/8 : RUN /jdk-10/bin/javac /DockerTest.java
 ---> Running in 12e2b9c5e10d
Removing intermediate container 12e2b9c5e10d
 ---> 4f85b574e47c
Step 8/8 : CMD  /jdk-10/bin/java ${JAVA_OPT} DockerTest ${APP_OPT}
 ---> Running in 5e6836724d80
Removing intermediate container 5e6836724d80
 ---> cf5d8a050f98
Successfully built cf5d8a050f98
Successfully tagged docker-test:jdk10
```

Since Java 10 is the Docker-aware version, resource limits should have taken effect without any explicit configuration.

```
vagrant@docker-vm:~$ docker run \
                        --rm \
                        --cpuset-cpus 0 \
                        -m 512MB \
                        docker-test:jdk10

System properties
Cores       : 1
Memory (Max): 123
```

The previous snippet shows that CPU Sets are handled correctly. Now let’s try with setting CPU Shares:

```
vagrant@docker-vm:~$ docker run \
                        --rm \
                        -c 512 \
                        -m 512MB \
                        docker-test:jdk10

System properties
Cores       : 1
Memory (Max): 123
```

It’s working as expected. Also, it’s worth to see this feature can be disabled via the -XX:-UseContainerSupport option (note that it starts with - after the -XX: prefix):

```
vagrant@docker-vm:~$ docker run \
                        --rm \
                        -c 512 \
                        -m 512MB \
                        -e JAVA_OPT=-XX:-UseContainerSupport \
                        docker-test:jdk10

System properties
Cores       : 2
Memory (Max): 239
```

This time JVM reads the configuration from the Docker machine. So these outputs show how the resource limits are correctly handled in Java 10. This Java version also includes changes in Attach API. To demonstrate this, first, let’s start the DockerTest container using JDK 10 in loop mode

```
vagrant@docker-vm:~$ docker run \
                        --rm \
                        -ti \
                        -e JAVA_OPT=-Dloop=true \
                        docker-test:jdk10

System properties
Cores       : 2
Memory (Max): 239

```

```
vagrant@docker-vm:~$ ps -ef | grep DockerTest

root     23778  0.6  2.6 2505204 26620 ?       Sl+  03:35   0:00 /jdk-10/bin/java -Dloop=true DockerTest

vagrant@docker-vm:~$ sudo jstack 23778

2019-05-04 03:36:42
Full thread dump OpenJDK 64-Bit Server VM (10+46 mixed mode):

Threads class SMR info:
_java_thread_list=0x00007f0ab80028e0, length=10, elements={
0x00007f0ae8010800, 0x00007f0ae8089800, 0x00007f0ae808b800, 0x00007f0ae80a4800,
0x00007f0ae80a6800, 0x00007f0ae80a8800, 0x00007f0ae80aa800, 0x00007f0ae8124800,
0x00007f0ae8132800, 0x00007f0ab8001000
}

"main" #1 prio=5 os_prio=0 tid=0x00007f0ae8010800 nid=0x7 waiting on condition  [0x00007f0af0fe1000]
   java.lang.Thread.State: TIMED_WAITING (sleeping)
        at java.lang.Thread.sleep(java.base@10/Native Method)
        at DockerTest.main(DockerTest.java:10)

```

It’s important to mention that 23778 is the PID visible on the host machine. For example, below output shows the actual PID inside of the container, which is different as expected (6).


```
vagrant@docker-vm:~$ docker exec \
                        -ti 0e336e755f70 \
                        /jdk-10/bin/jps

6 DockerTest
```

## Conclusion
Even though there’re a couple of features added prior to Java 10, the newest Java release is the most container ready version experienced so far. This example  solely focused on single Docker containers. It would be good to experiment how Java 10 plays under orchestration frameworks as well (ie: Kubernetes).