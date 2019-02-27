# Lab Day5 step by step
## Docker crash course v. 01.00



###### Swarms

Download lab5 from github repository.

First of all, install Docker, then install Docker Machine

```
$ docker run docker/whalesay cowsay lol

on linux

$ base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  sudo install /tmp/docker-machine /usr/local/bin/docker-machine
  
on windows using git bash, otherwise download one of the releases from the docker/machine release page directly 

$ base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  mkdir -p "$HOME/bin" &&
  curl -L $base/docker-machine-Windows-x86_64.exe > "$HOME/bin/docker-machine.exe" &&
  chmod +x "$HOME/bin/docker-machine.exe"
  
$ docker-machine version
```

Create a couple of VMs using docker-machine, using the VirtualBox driver, then list the VMS and get their IP address

```
$ docker-machine create --driver virtualbox myvm1
$ docker-machine create --driver virtualbox myvm2
$ docker-machine ls
``` 
>Ports 2377 and 2376

Always run docker swarm init and docker swarm join with port 2377 (the swarm management port), or no port at all and let it take the default.

The machine IP addresses returned by docker-machine ls include port 2376, which is the Docker daemon port. Do not use this port or you may experience errors.

INITIALIZE THE SWARM AND ADD NODES
The first machine acts as the manager, which executes management commands and authenticates workers to join the swarm, and the second is a worker.

You can send commands to your VMs using docker-machine ssh. Instruct myvm1 to become a swarm manager with docker swarm init and look for output like this:

`$ docker-machine ssh myvm1 "docker swarm init --advertise-addr <myvm1 ip>"`

To add a worker to this swarm, run the commands 
>NB put myvm1 ip address!

```
$ docker-machine ssh myvm2 "docker swarm join \
--token <token> \
<myvm1 ip>:2377"
```

Run docker node ls on the manager to view the nodes in this swarm:

`$ docker-machine ssh myvm1 "docker node ls"`

Deploy your app on the swarm cluster

Configure a docker-machine shell to the swarm manager
So far, you’ve been wrapping Docker commands in docker-machine ssh to talk to the VMs. Another option is to run docker-machine env <machine> to get and run a command that configures your current shell to talk to the Docker daemon on the VM. This method works better for the next step because it allows you to use your local docker-compose.yml file to deploy the app “remotely” without having to copy it anywhere.

Type docker-machine env myvm1, then copy-paste and run the command provided as the last line of the output to configure your shell to talk to myvm1, the swarm manager.

The commands to configure your shell differ depending on whether you are Mac, Linux, or Windows.

`$ docker-machine env myvm1`

and check if myvm1 is active

`$ docker-machine ls`

Deploy the app on the swarm manager
Now that you have myvm1, you can use its powers as a swarm manager to deploy your app by using the same docker stack deploy command you used in part 3 to myvm1, and your local copy of docker-compose.yml.. This command may take a few seconds to complete and the deployment takes some time to be available. Use the docker service ps <service_name> command on a swarm manager to verify that all services have been redeployed.

You are connected to myvm1 by means of the docker-machine shell configuration, and you still have access to the files on your local host. Make sure you are in the same directory as before, which includes the docker-compose.yml file you created in part 3.

Just like before, run the following command to deploy the app on myvm1.

`$ docker stack deploy -c docker-compose.yml getstartedlab`

And that’s it, the app is deployed on a swarm cluster!

Note: If your image is stored on a private registry instead of Docker Hub, you need to be logged in using docker login <your-registry> and then you need to add the --with-registry-auth flag to the above command. For example:

``` 
$ docker login registry.example.com
$ docker stack deploy --with-registry-auth -c docker-compose.yml getstartedlab
```

This passes the login token from your local client to the swarm nodes where the service is deployed, using the encrypted WAL logs. With this information, the nodes are able to log into the registry and pull the image.

Only this time notice that the services (and associated containers) have been distributed between both myvm1 and myvm2.

`$ docker stack ps getstartedlab`

Accessing your cluster
You can access your app from the IP address of either myvm1 or myvm2.

The network you created is shared between them and load-balancing. Run docker-machine ls to get your VMs’ IP addresses and visit either of them on a browser, hitting refresh (or just curl them).

There are five possible container IDs all cycling by randomly, demonstrating the load-balancing.

The reason both IP addresses work is that nodes in a swarm participate in an ingress routing mesh. This ensures that a service deployed at a certain port within your swarm always has that port reserved to itself, no matter what node is actually running the container. Here’s a diagram of how a routing mesh for a service called my-web published at port 8080 on a three-node swarm would look:



Portainer installation using Docker
Portainer is comprised of two elements, the Portainer Server, and the Portainer Agent. Both elements run as lightweight Docker containers on a Docker engine or within a Swarm cluster. Due to the nature of Docker, there are many possible deployment scenarios, however, we have detailed the most common below. Please use the scenario that matches your configuration (or if your configuration is not listed, see portainer.readthedocs.io for additional options).

Note that the recommended deployment mode when using Swarm is using the Portainer Agent.

Deploy Portainer Server on a standalone LINUX Docker host/single node swarm cluster (or Windows 10 Docker Host running in “Linux containers” mode).
Use the following Docker commands to deploy the Portainer Server; note the agent is not needed on standalone hosts, however it does provide additional functionality if used (see portainer and agent scenario below):

```
$ docker volume create portainer_data
$ docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
```

You'll just need to access the port 9000 of the Docker engine where portainer is running using your browser.