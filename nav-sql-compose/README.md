# Docker-compose based on an existing NAV docker image and the official SQL image from MS (trial).
**Work in progress... Will be updated soon.**

The current folder contains *docker-compose.yml* which is the core of the docker compose process. 
This will allow you to instantiate both, NAV and also SQL container on the same network. 

There are also another files (and will be more I hope) that will simplify the process. 
Also is possible that all folders will be redesigned to achieve a better optimization for both solutions (pure NAV container; NAV with SQL via docker compose).

Right now the process is not so straightforward so please, be patient.


## Prerequisites
Before you can start the *docker compose up* you should build some NAV image using [this](https://github.com/Koubek/dockerfiles-dynamics-nav/tree/master/nav-authsql).
Then you have to change the image name and tag in *docker compose up* (there is a comment in the file to identify correctly the place of the change).

The next you need to place your DB files in the folder **SQL\DB** and reference those files inside *docker compose up*.


## Docker compose up
And now you can just run *compose.up.bat* and wait :) After all, you should see two IPs - one for each container (SQL, NAV). 
It is quite possible that NAV will need some time to configure all settings so won`t be responding.
You can check the output of the container using this command:
```docker
docker logs navsqlcompose_nav_1
```
To remove both containers you can just run *compose.cleanup.bat*. This will remove the containers with force.