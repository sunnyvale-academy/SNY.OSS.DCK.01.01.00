# Lab Day3 step by step
## Docker crash course v. 01.00

`$ git clone https://github.com/sunnyvale-academy/SNY.OSS.DCK.01.01.00.git`

###### Docker Compose

>Setup Environment

```
$ sudo adduser docker_lab3
$ sudo usermode -aG docker docker_lab3
$ mkdir my_wordpress
$ cd my_wordpress
$ touch docker-compose.yml

```

>Paste code docker-compose.yml

nb. The docker volume db_data persists any updates made by WordPress to the database. 
	WordPress Multisite works only on ports 80 and 443

>Build the project

`$ docker-compose up -d`

This runs docker-compose up in detached mode, pulls the needed Docker images, and starts the wordpress and database containers

At this point, WordPress should be running on port 8000 of your Docker Host, and you can complete the “famous five-minute installation” as a WordPress administrator.

Note: The WordPress site is not immediately available on port 8000 because the containers are still being initialized and may take a couple of minutes before the first load.


>Shutdown and cleanup

`$ docker-compose down `

removes the containers and default network, but preserves your WordPress database.

`$ docker-compose down --volumes`

removes the containers, default network, and the WordPress database.