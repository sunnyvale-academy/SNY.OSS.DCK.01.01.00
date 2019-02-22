# Lab Day2 step by step
## Docker crash course v. 01.00

>download project from repository

`$ git clone https://github.com/sunnyvale-academy/SNY.OSS.DCK.01.01.00.git`



```
$ cd /vagrant
$ mkdir lab2node
$ cd lab2node
# Copy scripts folder and Vagrantfile from downloaded lab2 folder
$ vagrant up
```
###### CREATE NODE APP FOR DOCKER


Check if docker and nodejs are correctly installed
```
$ which node
$ which docker
```

>Create folder Nodeapp

```
$ cd /vagrant
$ mkdir nodeapp
$ cd nodeapp
$ touch package.json
```
Paste code from downloaded file

>Run npm install

```
$ npm config set bin-links false
$ npm install
```
if npm install fails, uncomment the configuration row in vagrantfile

>Create server.js file that defines a web app using the Express.js framework:

`$ touch server.js`

Paste code from downloaded file

###### CREATE DOCKERFILE

`$ touch Dockerfile`

Paste code from downloaded file

> Build Image

`$ docker build -t username/nodeapp:1.0 .`

> Check image are correctly build and saved and run it

```
$ docker image ls
$ docker run -d -p 49160:8080 username/nodeapp
```

> Print the output of your app

```
$ docker ps
$ docker logs <container id>
```

> Go inside the container you can use

`$ docker exec -it <container id> /bin/bash`

> Test

`$ curl -i localhost:49160`

>Stop container

`$ docker container stop {idcontainer}`

>Make a change adding a new route (paste code from new_route.txt) to server.js file

> Build New Image of app

`$ docker build -t username/nodeapp:1.1 .`

> Check image are correctly build and saved and run it, then check if the new route work

```
$ docker image ls
$ docker run -d -p 49160:8080 username/nodeapp:1.1
# browse IP:49160/foo
```
