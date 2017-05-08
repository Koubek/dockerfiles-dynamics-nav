# Dockefile for native MS Dynamics NAV Database Server

This is a solution to build Docker image for **Microsoft Dynamics NAV Database Server** and then run derived containers. I have been testing it with NAV 2009 R2 and everything seems to be working correctly. Of course, you can try to build any of NAV 2009 versions (2009, 2009 SP1, 2009 R2 even with hotfixes - I suppose you should upload them into the installation folder to overwrite the existing ones). Any feedback is welcome.

## Prerequisites
Before you can start the build process you have to upload content of **Server** directory into **root\nav-dbserver\content\Server** directory.
Without this content, you can\`t build the image as the process depends on it. 

Also, you will need a database file (*database.fdb*) + your NAV license file (*yourlicense.flf*) ready. Please, put them into **root\nav-dbserver\share** folder. Just to understand, this is not necessary while building an image but will be required when starting a derived container.


## Getting started
Again, you can find several files that can be quite helpfull and could simplify whole Docker image and Docker container management process.
You can use **__imagename.txt** file to specify a name of the image.

Next and again, you can see a couple of *bat* files in here. 
These files consume the information from the previously configured files and build, run and clean images/containers. 
You can see all details in the **_run.detached.bat** file which is supposed to be the best way how to run the container. 
Of course, you can go even further, you can run your container and set for example restart policies, memory limitation, override ports etc.

## Build, push and run
* ### Build your own image / an image based on a NAV version
    During the first step, you will build an image based on a specific NAV version. You can simply run 
    ```
    _rebuild.bat
    ```
    and if everything was configured correctly you will obtain the image in several minutes.  
    There is nothing else for now. Of course, you can build the image on you own. To do so just have a look into the *_rebuild.bat* to understand what steps are there behind the scene.

* ### Push your image into docker registry
    This step is not really necessary to be able to instantiate later new containers based on the image. 
    But of course, in a real environment, you want to distribute the image you have created. 
    So this is the way how to do it and distribute the images to the audience... 
    Your colleagues don`t have to repeat the build process on their own machines. They will just reuse what you have already done.
    When using private registry you should also configure (probably add) **insecure-registries** parameter in your **C:\ProgramData\docker\config\daemon.json**.

    To push the image use the following file:
    ```
    _push.bat
    ```

* ### Instantiate your image / run new container
    This part will be a little bit more complicated comparing with those mentioned previously. 
    You are now about to start a new container based on the image you have created and therefore you need to specify some data that will describe our environment.

    Like said before, at this moment you need your database and license present in the **share** directory!!!
    
    Next, you need to pass these data into the container and this can be achieved using the ENV parameters defined in the Dockerfile.
    There are several parameters so let`s describe them right now:

    * *db_file* - full path and name of your database file.  
    *!!!RIGHT NOW ONLY ONE FILE IS SUPPORTED!!!*

    * *srv_name* - name of the NAV database server instance. You can place a name of your customer, for example.

    * *svc_port_proto* - '2407/tcp' - port and protocol that will be used on the server.
    If you change the default value, you need to expose/map this port later when running the container because the Dockerfile exposes just the default port.  
    *!!!ONLY TCP PROTOCOL IS SUPPORTED RIGHT NOW!!!*

    * *license_file* - your license file that will be uploaded into the server folder (name will be changed automatically on **fin.flf**).
    
    * *delete_license* - if true the license will be deleted automatically during the startup. So the license file will disappear from the **share** folder on the host but will remain just inside the container. If you need to change the license file in the future, you can just put your probably updated license file again into the folder (you need to maintain the path and the name of the file originally passed during the *docker run*) and restart the container (*docker restart [container_name]*).

    * *cache_size* - cache size in kB.
    
    * *use_commit_cache* - yes/no to specify if the server will be using commit cache or not. 

    An example of *docker run* - you can see a very similar one in the **_run.detached.bat**:
    ```
    docker run -d -v %cd%\share:c:\share --hostname=NAVSERVER -e "srv_name=CRONUS" -e "db_file=C:\share\database.fdb" -e "license_file=C:\share\nav_license.flf" -e "cache_size=50000" -e "use_commit_cache=yes" myprivaterepo/nav-dbserver:6.0.32012
    ```

    Use *docker logs [container_name]* to see the status of the MS Dynamics NAV Database Server.