# Lab Day5 step by step
## Docker crash course v. 01.00

`$ git clone https://github.com/sunnyvale-academy/SNY.OSS.DCK.01.01.00.git`

###### Docker Swarm

>Install Docker

Check Docker is correctly installed

`$ docker run docker/whalesay cowsay hellooo`

>Install Docker MACHINE_VM


If you are running macOS:

```
$ base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/usr/local/bin/docker-machine &&
  chmod +x /usr/local/bin/docker-machine
  
```
If you are running Linux:

```
$ base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  sudo install /tmp/docker-machine /usr/local/bin/docker-machine
```
  
If you are running Windows with Git BASH:

```
$ base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  mkdir -p "$HOME/bin" &&
  curl -L $base/docker-machine-Windows-x86_64.exe > "$HOME/bin/docker-machine.exe" &&
  chmod +x "$HOME/bin/docker-machine.exe"
```

The above command works on Windows only if you use a terminal emulator such as Git BASH, which supports Linux commands like chmod.

Otherwise, download one of the releases from the docker/machine release page directly.

Check the installation by displaying the Machine version:

`$ docker-machine version`

Now, create a couple of VMs using docker-machine, using the VirtualBox driver, then list the machines and get their IP addresses:


```
$ docker-machine create --driver virtualbox myvm1
$ docker-machine create --driver virtualbox myvm2
docker-machine ls
```

INITIALIZE THE SWARM AND ADD NODES
The first machine acts as the manager, which executes management commands and authenticates workers to join the swarm, and the second is a worker.

Always run docker swarm init and docker swarm join with port 2377 (the swarm management port), or no port at all and let it take the default.

The machine IP addresses returned by docker-machine ls include port 2376, which is the Docker daemon port. Do not use this port

You can send commands to your VMs using docker-machine ssh. Instruct myvm1 to become a swarm manager with docker swarm init and look for output like this:


`$ docker-machine ssh myvm1 "docker swarm init --advertise-addr <myvm1 ip>:2377"`

Having trouble using SSH? Try the --native-ssh flag

`$ docker-machine --native-ssh ssh myvm1 ... `

As you can see, the response to docker swarm init contains a pre-configured docker swarm join command for you to run on any nodes you want to add. Copy this command, and send it to myvm2 via docker-machine ssh to have myvm2 join your new swarm as a worker:

```
$ docker-machine ssh myvm2 "docker swarm join \
--token <token> \
<ip myvm1>:2377"
```

Run docker node ls on the manager to view the nodes in this swarm:

`$ docker node ls`

>Configure a docker-machine shell to the swarm manager

So far, you’ve been wrapping Docker commands in docker-machine ssh to talk to the VMs. Another option is to run docker-machine env <machine> to get and run a command that configures your current shell to talk to the Docker daemon on the VM. This method works better for the next step because it allows you to use your local docker-compose.yml file to deploy the app “remotely” without having to copy it anywhere.

Type docker-machine env myvm1, then copy-paste and run the command provided as the last line of the output to configure your shell to talk to myvm1, the swarm manager.

` $ docker-machine env myvm1`

So,

` $ eval $(docker-machine env myvm1)`

Run docker-machine ls to verify that myvm1 is now the active machine, as indicated by the asterisk next to it.

` $ docker-machine ls`


###### DEPLOY APP

Now that you have myvm1, you can use its powers as a swarm manager to deploy your app by using the same docker stack deploy command you used in part 3 to myvm1, and your local copy of docker-compose.yml. This command may take a few seconds to complete and the deployment takes some time to be available. Use the docker service ps <service_name> command on a swarm manager to verify that all services have been redeployed.

You are connected to myvm1 by means of the docker-machine shell configuration, and you still have access to the files on your local host. Make sure you are in the same directory as before, which includes the docker-compose.yml file you created.

Just like before, run the following command to deploy the app on myvm1.

`$ docker stack deploy -c docker-compose.yml getstartedlab`

And that’s it, the app is deployed on a swarm cluster!

Now you can use the same docker commands you used in part 3. Only this time notice that the services (and associated containers) have been distributed between both myvm1 and myvm2.

`$ docker stack ps getstartedlab`

Accessing your cluster
You can access your app from the IP address of either myvm1 or myvm2.

The network you created is shared between them and load-balancing. Run docker-machine ls to get your VMs’ IP addresses and visit either of them on a browser, hitting refresh (or just curl them).

There are five possible container IDs all cycling by randomly, demonstrating the load-balancing.

The reason both IP addresses work is that nodes in a swarm participate in an ingress routing mesh. This ensures that a service deployed at a certain port within your swarm always has that port reserved to itself, no matter what node is actually running the container. Here’s a diagram of how a routing mesh for a service called my-web published at port 8080 on a three-node swarm would look.

![alt text](https://github.com/sunnyvale-academy/SNY.OSS.DCK.01.01.00/blob/master/docker_swarm/img/ingress-routing-mesh.png)

Iterating and scaling your app

Scale the app by changing the docker-compose.yml file.

Change the app behavior by editing code, then rebuild, and push the new image. (To do this, follow the same steps you took earlier to build the app and publish the image).

In either case, simply run docker stack deploy again to deploy these changes.

You can join any machine, physical or virtual, to this swarm, using the same docker swarm join command you used on myvm2, and capacity is added to your cluster. Just run docker stack deploy afterwards, and your app can take advantage of the new resources.


Cleanup and reboot

Stacks and swarms
You can tear down the stack with docker stack rm. For example:

` $ docker stack rm getstartedlab`