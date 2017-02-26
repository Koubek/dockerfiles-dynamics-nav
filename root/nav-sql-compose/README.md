# Docker-compose based on an existing NAV docker image and the official SQL image from MS (trial).
This folder contains **docker-compose.yml** and some other files with very similar names. 
Those files form the core of the docker compose process. 
We can say this directory allows you to instantiate both, NAV and also SQL container on the same network. 

And again, there are also another files that will simplify the compose process for you.

## Prerequisites
Before you can start the *docker compose up* you should extract NAV DVD content into **root\\__content\\NAV\\DynamicsNavDvd** directory.
When working with docker compose to build both NAV and SQL container you will need to save you DB into **root\\__content\\SQL\DB**. 
It is important to leave DB files (mdf, ndf, ldf) that will be attached automatically.
You can`t use a SQL backup file right now. I hope this feature will be introduced soon.
Finally, you need to reference those files inside *docker-compose.configs.yml*.

## Multiple **docker-compose.configs.yml** files
As mention before, there is one **docker-compose.yml** and some derived files with very similar names.
The idea is to utilize the feature of docker compose to join multiple files during the *docker compose up* process.
You should focus just on **docker-compose.configs.yml** which is the place where only the most important configurations should be made.

You can see several parameters and again, please focus only on the minimum of them:
* *services: sql: environment:* **attach_db** - just change the names of the DB files (*NAVDB_Data.mdf* => *your_data_filename.mdf*; *NAVDB_Log.ldf* => *your_log_filename.ldf*), don`t change the paths. Of course, you can add more files but again, respect the existing path.
* *services: nav: environment:* **nav_user** - your NAV user you will use to authenticate to NAV.
* *services: nav: environment:* **nav_user_pwd** - your NAV user\`s password you will use to authenticate to NAV.
* *services: sql: environment:* **sa_password** must match with *services: nav: environment:* **sql_pwd**.
* *services: sql: environment:* **attach_db[0].dbName** must match with *services: nav: environment:* **sql_db**.


## Docker compose up
Now you have to make a decision. Right now, using the current version you can run docker compose using:
* An existing NAV image + an existing SQL image.
    * In this case, you need to know the name of the NAV image you want to use and configure it in **docker-compose.nav-image.yml** file.
    Then just run **_compose.up.nav-image.bat**.
    I can see this form as the most efficient for an environment with Docker registry and prebuilt NAV images.
    You can save a lot of time and resources when working in this way.
* Build dynamically NAV image + use an existing SQL image.
    * This a very straightforward manner how to start using docker compose. 
    You don\`t need any prebuilt NAV image. You can just put the prerequisites, configure DB filenames and run **_compose.up.nav-build.bat**.
    This form is suitable for ad hoc cases when you need for example test something very specific, temporarily work with a customer DB and you don\`t have the image ready and won\`t considering you will use it (this current NAV version + CU) again in the future.

After all, when your particular *docker compose up* process is over you should see two IPs - one for each container (SQL, NAV). 
It is quite possible that NAV will need some time to configure all settings so won`t be responding.
You can check the output of the container using this command:
```docker
# Please, consider the name of your particular NAV container!!!
docker logs navsqlcompose_nav_1
```


## What`s next...?
To remove both containers you can just run *compose.cleanup.bat*. This will remove the containers with force.

And that`s all, right now there is almost nothing else :) There are some ideas and I hope I will find some time to implement them.