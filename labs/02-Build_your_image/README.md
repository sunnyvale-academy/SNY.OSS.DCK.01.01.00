# Build your image

## Prerequisites

Having completed lab **00 - Setup lab environment**

## Connect to Sunnyvale's Ubuntu VM

```console
$ cd <GIT_REPO_NAME>/vagrant
$ vagrant up
$ vagrant ssh
vagrant@docker-vm:~$ 
```


## Build the image

```console
vagrant@docker-vm:~$ cd ~/SNY.OSS.DCK.01.01.00/labs/02-Build_your_image
vagrant@docker-vm:~/SNY.OSS.DCK.01.01.00/labs/02-Build_your_image$ docker build -t friendlyhello:1.0 .
Sending build context to Docker daemon  6.144kB
Step 1/7 : FROM python:2.7-slim
2.7-slim: Pulling from library/python
8d691f585fa8: Downloading [=====>                                             ]  3.087MB/27.11MB
3fd6980f9df6: Download complete 
1d77ed441c32: Downloading [=======>                                           ]  2.857MB/18.03MB
435ec8f6812c: Download complete 
...
Successfully built 776174b5910f
Successfully tagged friendlyhello:1.0
```
Display the newly built image

```console
vagrant@docker-vm:~$ docker image ls

REPOSITORY            TAG                 IMAGE ID
friendlyhello         1.0                 776174b5910f
```

## Run a container

```console
vagrant@docker-vm:~$ docker run -p 4000:80 friendlyhello:1.0 
 * Serving Flask app "app" (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://0.0.0.0:80/ (Press CTRL+C to quit)
```

If you are using the Sunnyvale's Ubuntu VM, point your browser here: http://192.168.135.10:4000

If you are using Docker Desktop for Windows or MacOS as well as you are using Docker CE on Linux, point your browser here: http://localhost:4000

If you are using Docker Toolbox, point your browser to the IP address used by the Docker Toolbox VM (the Docker host).

```console
$ curl http://192.168.135.10:4000                        
<h3>Hello World!</h3><b>Hostname:</b> e37a0597be7d<br/><b>Visits:</b> <i>cannot connect to Redis, counter disabled</i>%
```

Press CTRL+C to quit the container

```console
vagrant@docker-vm:~$ docker run -p 4000:80 friendlyhello:1.0 
 * Serving Flask app "app" (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://0.0.0.0:80/ (Press CTRL+C to quit)
 192.168.135.1 - - [25/Oct/2019 22:34:50] "GET / HTTP/1.1" 200 -
^C
vagrant@docker-vm:~/SNY.OSS.DCK.01.01.00/labs/02-Build_your_image$
```
