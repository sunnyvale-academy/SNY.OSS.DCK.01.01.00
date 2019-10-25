# Setup the lab environment (a.k.a. install Docker)

## Sunnyvale's Ubuntu VM with Docker (labs are targeted to this environment)

Please refer to installation steps [here](../../vagrant/README.md)

Some additional installation methods are available (at your own risk ;-))

## Docker Desktop for Windows (Windows 10 Professional only)

Please refer to installation steps [here](https://hub.docker.com/editions/community/docker-ce-desktop-windows) (requires DockerHUB registration)

## Docker Desktop for MacOS (MacOS 10.12 or newer)

Please refer to installation steps [here](https://hub.docker.com/editions/community/docker-ce-desktop-mac) (requires DockerHUB registration)

## Docker toolbox (Windows 8 or 8.1 or 10 Home Edition)

Please refer to installation steps [here](https://docs.docker.com/toolbox/toolbox_install_windows/)

## Docker CE for Linux 

### Ubuntu

```console
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
$ sudo apt-get update
$ sudo apt-get install docker-ce docker-ce-cli containerd.io
```

### CentOS

```console
$ sudo yum install docker-ce docker-ce-cli containerd.io
$ sudo systemctl start docker
```

More about docker installation at [Docker website](https://docs.docker.com).