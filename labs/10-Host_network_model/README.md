# Host network model


Host network model:

- Provides the minimum level of network protection/abstraction.
- No isolation on this type of open containers, thus leave the container widely unprotected.
- Containers running in the host network stack should see a higher level of performance than those traversing the **docker0** bridge and iptables port mappings

## Prerequisites

Having completed lab **00 - Setup lab environment**

## Connect to Sunnyvale's Ubuntu VM

```console
$ cd <GIT_REPO_NAME>/vagrant
$ vagrant up
$ vagrant ssh
vagrant@docker-vm:~$ 
```

## Test the **Host network model**

We run an **nginx** container with a host network, notice that we did not map any port with the `-p` flag.

```console
vagrant@docker-vm:~$ docker run \
    --rm \
    -it \
    --net host \
    nginx \
Unable to find image 'nginx:latest' locally
latest: Pulling from library/nginx
8d691f585fa8: Pull complete 
5b07f4e08ad0: Pull complete 
abc291867bca: Pull complete 
Digest: sha256:922c815aa4df050d4df476e92daed4231f466acc8ee90e0e774951b0fd7195a4
Status: Downloaded newer image for nginx:latest

2b12864becc0cb82761f78fe8ef77cfb8238add8935b5c2041ac8b1e91a8f00c
```

The command below will prove that the nginx container opened the 80 port directly on the host.

```console
vagrant@docker-vm:~$ curl http://localhost:80
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

This command would return an error in the case of bridge network.

Stop the running container.

```console
vagrant@docker-vm:~$ docker stop $(docker ps -q)
2b12864becc0
```