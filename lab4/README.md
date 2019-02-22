# Lab Day2 step by step
## Docker crash course v. 01.00

> First of all, check if node and postgres are installed, if yes, change the password for postgres user

```
$ which node
$ which psql
$ sudo passwd postgres

``` 

> Set a password for the postgres database user:

```
$ su - postgres
$ psql -d template1 -c "ALTER USER postgres WITH PASSWORD 'newpassword';"
``` 

> Create a database for the example app and connect to it:

``` 
$ createdb nodejs
$ psql nodejs
``` 
>Add “Hello world” to the database:

``` 
nodejs=# CREATE TABLE hello (message varchar);
nodejs=# INSERT INTO hello VALUES ('Hello world');
nodejs=# \q
``` 

>Create a dump of the database for later use:

``` 
$ pg_dumpall > backup.sql
``` 

Sign out as the postgres Linux user:

`$ exit` 

Copy the data dump to your home directory:

`sudo cp /var/lib/postgresql/backup.sql . `

Since you will be connecting to this database from a container (which will have an IP address other than locahost), you will need to edit the PostgreSQL config file to allow connections from remote addresses. 

> Open /etc/postgresql/9.5/main/postgresql.conf in a text editor. 

Uncomment the listen_addresses line and set it to ‘*’:

Enable and start the postgresql service:

``` 
sudo systemctl enable postgresql
sudo systemctl start postgresql
``` 

###### Create a Hello World App

Navigate to the home directory and create a directory:

`$ mkdir app && cd app`

Using a text editor, create app.js and add the following content:

const { Client } = require('pg')

const client = new Client({
  user: 'postgres',
  host: 'localhost',
  database: 'nodejs',
  password: 'newpassword',
  port: 5432
})

client.connect()

client.query('SELECT * FROM hello', (err, res) => {
  console.log(res.rows[0].message)
  client.end()
})


This app uses the pg NPM module (node-postgres) to connect to the database created in the previous section. 
It then queries the ‘hello’ table (which returns the “Hello world” message) and logs the response to the console. 

>NB. Replace 'newpassword' with the postgres database user password you set in the previous section.

>Install the pg module:

```
$ npm config set bin-links false
$ npm install pg
```

Test the app:

`$ node app.js`

If the database is configured correctly, “Hello world” will be displayed on the console.


###### Connect Container to Docker HostPermalink

This section illustrates a use case where the Node.js app is run from a Docker container, and connects to a database that is running on the Docker host.

>Set Up Docker ContainerPermalink

Return to your home directory and create a Dockerfile to run the Node.js app:

`$ touch Dockerfile`

and paste this code:

FROM debian

RUN apt update -y && apt install -y gnupg curl
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && apt install -y nodejs
COPY app/ /home/

ENTRYPOINT tail -F /dev/null


The image built from this Dockerfile will copy the app/ directory to the new image. 
>Edit app.js to allow the app to connect to the database host instead of localhost:

const client = new Client({
  user: 'postgres',
  host: 'database',
  database: 'nodejs',
  password: 'newpassword',
  port: 5432
})

>Build an image from the Dockerfile:

`$ docker build -t node_image . `

>Connect Container to DatabasePermalink

Docker automatically sets up a default bridge network, accessed through the docker0 network interface. 
Use ifconfig or ip to view this interface:

`$ ifconfig docker0`

The output will resemble the following:
  
docker0 Link encap:Ethernet HWaddr 02:42:1e:e8:39:54
inet addr:172.17.0.1 Bcast:0.0.0.0 Mask:255.255.0.0
inet6 addr: fe80::42:1eff:fee8:3954/64 Scope:Link
UP BROADCAST RUNNING MULTICAST MTU:1500 Metric:1
RX packets:3848 errors:0 dropped:0 overruns:0 frame:0
TX packets:5084 errors:0 dropped:0 overruns:0 carrier:0
collisions:0 txqueuelen:0
RX bytes:246416 (246.4 KB) TX bytes:94809688 (94.8 MB)

The internal IP address of the Docker host (your Linode) is 172.17.0.1.


>Allow PostgreSQL to accept connections from the Docker interface. 

Open /etc/postgresql/9.5/main/pg_hba.conf in a text editor and add the following line:

`$ vi /etc/postgresql/9.5/main/pg_hba.conf`

host    all             postgres        172.17.0.0/16           password

Since 172.17.0.1 is the IP of the Docker host, all of the containers on the host will have an IP address in the range 172.17.0.0/16.

> Restart the database:

`$ sudo systemctl restart postgresql`

>Start the container:

`$ docker run -d --add-host=database:172.17.0.1 --name node_container node_image`

The --add-host option defines a database host, which points to the IP address of the Docker host. Declaring the database host at runtime, 
rather than hard-coding the IP address in the app, helps keep the container reusable.

> From within the container, use ping to test the connection to the database host:

`$ docker exec -it node_container ping database`

Each Docker container is also assigned its own IP address from within the 172.17.0.0/16 block. 
Find the IP address of this container with ip:


`$ docker exec -it node_container ip addr show eth0`

You can test this connection by pinging this address from the Docker host.

>Run the app:

`$ docker exec -it node_container node home/app.js`

If the configuration was successful, the program should display the “Hello world” console output as before.


###### Connect Two ContainersPermalink

In this section, both the app and database will be running in separate containers. 
You can use the official postgres image from Docker Hub and load in the SQL dump created earlier.

!Caution!
You should not store production database data inside a Docker container. Containers should be treated as ephemeral entities: if a container unexpectedly crashes or is restarted, all data in the database will be lost.

> Stop and remove the Node.js container:

```
$ docker stop node_container
$ docker rm node_container
```

>Pull the postgres image:


`$ docker pull postgres`

Make sure your backup.sql file is in your current working directory, then run the postgres image:

`$ docker run -d -v `pwd`:/backup/ --name pg_container postgres`

The -v option mounts your current working directory to the /backup/ directory on the new container.

The new container will automatically start the postgres database and create the postgres user. Enter the container and load the SQL dump:

```
% docker exec -it pg_container bash
$ cd backup
$ psql -U postgres -f backup.sql postgres
exit
```

Run the node image again. This time, instead of --add-host, use the --link option to connect the container to pg_container:

`$ docker run -d --name node_container --link=pg_container:database node_image`

This will link the pg_container under the hostname database.

Open /etc/hosts in node_container to confirm that the link has been made:

`$ docker exec -it node_container cat /etc/hosts`

There should be a line similar to the following:

/etc/hosts
1
172.17.0.2  database  pg_container

This shows that pg_container has been assigned to the IP address 172.17.0.2, and is linked to this container via the hostname database, as expected.

Since the Node.js app is still expecting to connect to a PostgreSQL database on the database host, no further changes are necessary. 
You should be able to run the app as before:

`$ docker exec -it node_container node home/app.js`


