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