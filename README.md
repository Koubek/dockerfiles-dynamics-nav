# Dockerfiles for MS Dynamics NAV
At the first moment the idea of this repository was to confirm that MS Dynamics NAV server could be serverd via [Docker](https://www.docker.com) container.
At this moment I had a Dockerfile ready and some docker-compose files as well. I was able to build related containers with all services but there was an issue when starting NAV services inside the container.
The problem was caused by some missing dependencies (DLLs) and this problem was solved by [Tobias Fenster](https://github.com/tfenster).
Tobias, again, thank you so much for your help.

Right now we already know that it is really possible to run NAV via Docker containers. We have tried NAV 2016 and NAV 2017 both of them were working *correctly* (I am still not using them in the DEV environment so this statement is quite relative).

I was able to build NAV 2015 image and run a derivated container. The problem is that NAV 2015 and older do not permit to configure SQL/Database credentials on NAV service so I wasn`t able to confirm it yet as we are right now upgrading our AD forest and functional level to 2012 R2 to be able to start using [gMSA](https://docs.microsoft.com/virtualization/windowscontainers/manage-containers/manage-serviceaccounts).
I personally hope that older NAV version will work on containers as well.


## Repository structure
The main content of the repository is located inside **root** folder.
This principal folder contains another sub-folders and some additional files. 
The purpose of the sub-folders is following:
* **__content** - this is a folder where all required content should be placed into. You should: 
    * extract NAV DVD content into **\\__content\\NAV\\DynamicsNavDvd**,
    * place your database files that have to to be attached (right now the backup file is not supported) into **\\__content\\SQL\DB\\**. Those will be considered just when using **nav-sql-compose**.
* **nav** - the principal Dockerfile for MS Dynamics NAV. You can use this folder to build just NAV server. You need an existing SQL instance that is also accessible from the instantiated NAV container.
* **nav-sql-compose** - this folder contains docker-compose that will create two containers - NAV container and SQL container. Both of them will be connected via **nat** network.
* **sql** - this folder contains Dockerfile that will allow you to create your own version of MS SQL server image. This will be necessary for *docker-compose* because we will be using some enhancements.
---
* **nav-dbserver** - this folder stands a little bit aside as this is a solution to build the old *MS Dynamics NAV Database Server* (useful just for some old customers and their partners).


You can find more details inside a specific folder.


## Prerequisites
It is strongly recommended to read something about [Docker](https://www.docker.com) and even more about the [Windows containers](https://docs.microsoft.com/virtualization/windowscontainers/about/).
Of course, you need Docker to be present and correctly working on your PC. To install Docker (aka Windows containers) on:
* **Win10** - read [Windows Containers on Windows 10](https://docs.microsoft.com/virtualization/windowscontainers/quick-start/quick-start-windows-10)
* **WinServer2016** - read [Windows Containers on Windows Server](https://docs.microsoft.com/virtualization/windowscontainers/quick-start/quick-start-windows-server)


## Getting started
Of course, you can experiment with the Dockerfiles, you can use the existing solution to build your own solution which will fit better your requirements. Anyway, if your are not familiar with Docker and want to see the benefits of the idea behind I would recommend the following scenario:
* Install Docker (for Windows containers) as mentioned before.
* Download content of the repository. We can extract it into **C:\\temp\\dockerfiles-dynamics-nav**.
* Take MS Dynamics NAV DVD and extract the content of the DVD into **C:\\temp\\dockerfiles-dynamics-nav\\root\\__content\\NAV\\DynamicsNavDvd** folder.
* Now, you will need a corresponding DB (version of the DB should match NAV version, of course). And this needs to be already extracted as well, the **bak** won`t work right now.
Place the DB files into **C:\\temp\\dockerfiles-dynamics-nav\\root\\__content\\SQL\\DB** folder.
* Now, edit the following file **C:\\temp\\dockerfiles-dynamics-nav\\root\\nav-sql-compose\\docker-compose.configs.yml** and focus on the following parameter(s):
    * **attach_dbs** - just change the names of the DB files (*NAVDB_Data.mdf* => *your_data_filename.mdf*; *NAVDB_Log.ldf* => *your_log_filename.ldf*), don`t change the paths. Of course, you can add more files but have to respect the path.
    * You can change also other parameters but I would recommend to leave them untouched for the first run.
* Run the following script: **C:\\temp\\dockerfiles-dynamics-nav\\root\\nav-sql-compose\\_compose.up.nav-build.bat**.
* This will take a while to build NAV image but after all, you should see two IPs. Take that one corresponding with NAV instance, open RTC and connect to that service (IP:7046/NAVSERVICE).
* It is quite possible that the service won`t be responding immediately, you can wait a minute or watch the log using **docker logs navsqlcompose_nav_1** (**navsqlcompose_nav_1** is NAV container name so if your container name has a different name, please, use the name of your container).
* To stop and remove the containers execute **C:\\temp\\dockerfiles-dynamics-nav\\root\\nav-sql-compose\\_compose.cleanup.bat**
