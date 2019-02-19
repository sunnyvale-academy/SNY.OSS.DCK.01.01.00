# Lab Day2 step by step
## Docker crash course v. 01.00

>download project from repository

`$ git clone https://github.com/sunnyvale-academy/SNY.OSS.DCK.01.01.00.git`

###### CREATE NODE APP FOR DOCKER

>Create folder Nodeapp
`$ touch package.json`

Paste content in file
{
  "name": "docker_web_app",
  "version": "1.0.0",
  "description": "Node.js on Docker",
  "author": "First Last <first.last@example.com>",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.16.1"
  }
}

>Run npm install
`$ npm install`

>Create server.js file that defines a web app using the Express.js framework:
Paste content in file

'use strict';

const express = require('express');

// Constants
const PORT = 8080;
const HOST = '0.0.0.0';

// App
const app = express();
app.get('/', (req, res) => {
  res.send('Hello world\n');
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);

###### CREATE DOCKERFILE

`$ touch Dockerfile`

FROM node:8

'# Create app directory
WORKDIR /usr/src/app

'# Install app dependencies
'# A wildcard is used to ensure both package.json AND package-lock.json are copied
'# where available (npm@5+)
COPY package*.json ./

RUN npm install
'# If you are building your code for production
'# RUN npm ci --only=production

'# Bundle app source
COPY . .

EXPOSE 8080
CMD [ "npm", "start" ]

> Build Image
`$ docker build -t username/nodeapp .`

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
`$ docker container stop`

