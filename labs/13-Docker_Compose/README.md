# Docker Compose

Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application’s services. Then, with a single command, you create and start all the services from your configuration.

## Prerequisites

Having completed lab **00 - Setup lab environment**

## Connect to Sunnyvale's Ubuntu VM

```console
$ cd <GIT_REPO_NAME>/vagrant
$ vagrant up
$ vagrant ssh
vagrant@docker-vm:~$ 
```

## Instance a multi container application with Docker Compose

Start containers

```console
vagrant@docker-vm:~$ docker-compose -f /home/vagrant/$GIT_REPO_NAME/labs/13-Docker_compose/docker-compose.yml up -d
Recreating 13dockercompose_db_1 ... done
Recreating 13dockercompose_wordpress_1 ... done
```

If you point your browser to http://http://192.168.135.10:8000/ you should see the WordPress installation page.

Go ahead installing WordPress, you will see that MySQL container has been created too.

## Remove containers

Finally, remove the containers

```console
vagrant@docker-vm:~$ docker-compose -f /home/vagrant/$GIT_REPO_NAME/labs/13-Docker_compose/docker-compose.yml down -v
Removing network 13dockercompose_default
Removing volume 13dockercompose_db_data
```