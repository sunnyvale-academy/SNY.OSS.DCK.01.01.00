# Volumes

## Prerequisites

Having completed labs:
-  **00 - Setup lab environment**
-  **02 - Build your image**

## Create a volume

To create a volume type the following command

```console
vagrant@docker-vm:~$ docker volume create my-vol
my-vol
```

Now list the volumes, you should find yours

```console
vagrant@docker-vm:~$ docker volume ls
DRIVER              VOLUME NAME
local               my-vol
```

To gather informations about the volume:

```console
vagrant@docker-vm:~$ docker volume inspect my-vol
[
    {
        "CreatedAt": "2019-10-26T09:07:31Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/my-vol/_data",
        "Name": "my-vol",
        "Options": {},
        "Scope": "local"
    }
]
```

## Use the volume

If you wan to list the content of a volume, you have to mount the volume in a folder (in our case /app) of a busybox container and execute the `ls -l /app` command in it. 

```console
vagrant@docker-vm:~$ docker run --rm -v my-vol:/app busybox ls -l /app
Unable to find image 'busybox:latest' locally
latest: Pulling from library/busybox
7c9d20b9b6cd: Pull complete 
Digest: sha256:fe301db49df08c384001ed752dff6d52b4305a73a7f608f21528048e8a08b51e
Status: Downloaded newer image for busybox:latest
total 0
```

Since the volume has just been created, it is empty (total 0).

Now start a new **friendlyhello:1.0** container, mounting the volume in the path where we stored the Python application (/app)

```console
vagrant@docker-vm:~$ docker run -d \
	--name devtest \
	--mount source=my-vol,target=/app \
	friendlyhello:1.0
a52c0d80c11dc8d62f6abfcdb896714aaa05417a4163ce0e210bbcdd22c8657b
```

Doing this way, the container copied the content of /app folder into the volume.

If you list the content of the volume you can find the application's files now.

```console
vagrant@docker-vm:~$ docker run --rm -v my-vol:/app busybox ls -l /app

docker run --rm -v my-vol:/app busybox ls -l /app
total 8
-rw-r--r--    1 root     root           659 Oct 25 22:20 app.py
-rw-r--r--    1 root     root            11 Oct 25 22:20 requirements.txt
```

## Delete the volume

Try to delete the volume

```console
vagrant@docker-vm:~$ docker volume rm my-vol
Error response from daemon: remove my-vol: volume is in use - [a52c0d80c11dc8d62f6abfcdb896714aaa05417a4163ce0e210bbcdd22c8657b]
```

Stop the container

```console
vagrant@docker-vm:~$ docker stop a52c0d80c11dc8d62f6abfcdb896714aaa05417a4163ce0e210bbcdd22c8657b
a52c0d80c11dc8d62f6abfcdb896714aaa05417a4163ce0e210bbcdd22c8657b
```

Delete the container

```console
vagrant@docker-vm:~$ docker rm a52c0d80c11dc8d62f6abfcdb896714aaa05417a4163ce0e210bbcdd22c8657b
a52c0d80c11dc8d62f6abfcdb896714aaa05417a4163ce0e210bbcdd22c8657b
```

Try to remove the volume again

```console
vagrant@docker-vm:~$ docker volume rm my-vol
my-vol
```


