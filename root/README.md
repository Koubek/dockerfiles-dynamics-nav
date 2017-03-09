# Dockerfiles for MS Dynamics NAV - root directory
The purpose of the sub-folders is following:
* **__content** - this is a folder where all required content should be placed into. You should: 
    * extract NAV DVD content into **\\__content\\NAV\\DynamicsNavDvd**,
    * place your database files that have to to be attached (right now the backup file is not supported) into **\\__content\\SQL\DB\\**. Those will be considered just when using **nav-sql-compose**.
* **nav** - the principal Dockerfile for MS Dynamics NAV. You can use this folder to build just NAV server. You need an existing SQL instance that is also accessible from the instantiated NAV container.
* **nav-sql-compose** - this folder contains docker-compose that will create two containers - NAV container and SQL container. Both of them will be connected via **nat** network.
* **sql** - this folder contains Dockerfile that will allow you to create your own version of MS SQL server image. This will be necessary for *docker-compose* because we will be using some enhancements.
---
* **nav-dbserver** - this folder stands a little bit aside as this is a solution to build the old *MS Dynamics NAV Database Server* (useful just for some old customers and their partners).


You can also find several files here in this directory:
* **__privatereponame.txt** - is useful when working with private Docker repository. 
In here I use a slightly different way I use in the production environment (this information is being distributed using GPOs of AD). 
Anyway, you can keep whatever there until you will try to push the image to your real private repository (right now in the parent directory to be able to group all required folders/solutions).
* **_presetvars.bat** - this *bat* file shouldn\`t be executed directly. 
It is being called from the sub-folders to preconfigure required parameters needed by Docker build or Docker run processes.

You can find more relevant details inside the sub-folders.
