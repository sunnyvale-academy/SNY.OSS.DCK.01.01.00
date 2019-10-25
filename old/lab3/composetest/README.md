# Lab Day3 step by step
## Docker crash course v. 01.00

`$ git clone https://github.com/sunnyvale-academy/SNY.OSS.DCK.01.01.00.git`

###### Docker Compose

>Setup Environment

```
$ sudo adduser docker_lab3
$ sudo usermode -aG docker docker_lab3
$ mkdir composetest
$ cd composetest
$ touch app.py
$ touch requirements.txt

```
>Paste code into app.py

Nb. In this example, redis is the hostname of the redis container on the application’s network. We use the default port for Redis, 6379.

Create another file called requirements.txt in your project directory and paste the code.


>Create Dockerfile, that tells Docker to:

-Build an image starting with the Python 3.4 image.
-Add the current directory . into the path /code in the image.
-Set the working directory to /code.
-Install the Python dependencies.
-Set the default command for the container to python app.py

>Create docker-compose.yml


This Compose file defines two services, web and redis. 

The web service:

-Uses an image that’s built from the Dockerfile in the current directory.
-Forwards the exposed port 5000 on the container to port 5000 on the host machine. We use the default port for the Flask web server, 5000.
-The redis service uses a public Redis image pulled from the Docker Hub registry.

>Build and run app

`$ docker-compose up`

Compose pulls a Redis image, builds an image for your code, and starts the services you defined. In this case, the code is statically copied into the image at build time.

>Enter VM_IP:5000/ in a browser to see the application running.


You should see a message in your browser saying:

Hello World! I have been seen 1 times.

> Refresh the page.

The number should increment.


>Switch to another terminal window, and type 

`$ docker image ls`

to list local images.

You can inspect images with docker inspect <tag or id>.

Stop the application, either by running docker-compose down from within your project directory in the second terminal, or by hitting CTRL+C in the original terminal where you started the app.


###### ADD A BIND MOUNT 

Edit docker-compose.yml in your project directory to add a bind mount for the web service:

volumes:
   - .:/code

	
The new volumes key mounts the project directory (current directory) on the host to /code inside the container, allowing you to modify the code on the fly, without having to rebuild the image.

> Re-build and run the app with Compose

`$ docker-compose up`

Check the Hello World message in a web browser again, and refresh to see the count increment.


###### UPDATE APP

Because the application code is now mounted into the container using a volume, you can make changes to its code and see the changes instantly, without having to rebuild the image.

Inspect container and see the volumes mount (path)

```
$ docker container ls -a
$ docker container inspect <name_container>
```

Change the greeting in app.py and save it. For example, change the Hello World! message to Hello from Docker!:

Refresh the app in your browser. The greeting should be updated, and the counter should still be incrementing.

Experiment with some other commands
If you want to run your services in the background, you can pass the -d flag (for “detached” mode) to docker-compose up and use docker-compose ps to see what is currently running:

```
$ docker-compose up -d
$ docker-compose ps
$ docker-compose stop
$ docker-compose down --volumes
```