# Dockefile for MS Dynamics NAV with SQL Authentication
This a simple and experimental Dockerfile for MS Dynamics NAV Server. Microsoft doesn\`t provide an official support for NAV containerization because of several OS dependencies. 
The Dockerfile is trying to avoid them installing just a Service Tier and not the whole package.
You can find more details on the [Tobias Fenster`s blog](http://navblog.infoma.de/index.php/2016/11/18/dynamics-nav-2017-in-a-windows-container-with-docker/). 
Thanks again to Tobias as he was very helpful and made it possible to run NAV container correctly.

## Prerequisites
Before you can start the build process you have to upload unpacked content of NAV installation DVD (could be working with 2016 and 2017) into **DynamicsNavDvd** directory included in **content** directory.
Without this content, you can\`t build the image as it depends on DVD content.

Also, as this is a solution based on SQL authentication, you need a SQL server login and provide those credentials during the *docker run* process.

## Getting started
This simple and maybe not very well made solution has several files that help me to simplify build process and container management process.
You can find two basic configuration files in the main directories:
* **__imagename.txt** - specify name of the image (in this directory),
* **..\\__privatereponame.txt** - is useful when working with private Docker repository. In here I use a slightly different way I use in the production environment (this information is being distributed using GPOs of AD). Anyway, you can keep whatever there until you will try to push the image to your real private repository (right now in the parent directory to be able to group all required folders/solutions).

Next, you can find there are several *bat* files. Those files consume the information from the previously configured files and build, run and clean images/containers. You can see all details in the **_run.detached.bat** file which is supposed to be the best way how to run the container.

## Build, push and run (aka DOCKER`s motto BUILD, SHIP, RUN)
* ### Build your own image / an image based on a NAV version
    During the first step, we will build an image based on a specific NAV version. You can simply run 
    ```
    _rebuild.bat
    ```
    and do the rest. There is nothing else for now. Of course, you can build the image on you own. To do so just have a look into the *_rebuild.bat* to understand what steps are there behind the scene.

* ### Push your image into docker registry
    This step is not really necessary to be able to instantiate later new containers based on the image. 
    But of course, in a real environment, you want to distribute those image you have created. So this is the way how to do it and distribute the images to the audience... 
    Your colleagues don`t have to repeat the build process on their own machines. They will just reuse what you have already done.

    To push the image use the following file:
    ```
    _push.bat
    ```

* ### Instantiate your image / run new container
    This part will be a little bit more complicated comparing with those mentioned previously. 
    You are now about to start a new container based on the image you have created and therefore you need to specify some data that will describe our environment.
    
    You need to pass these data into the container and this can be achieved using the ENV parameters defined in the Dockerfile.
    There are several parameters so let`s describe them right now:
    * *nav_instance* - name of the NAV instance that will be created. This parameter is being used also during the build process to provide the name of the default instance.
    Exactly for this reasons the parameter has a default value as you can see in the Dockerfile.
    * *sql_server* - name (and instance) of the SQL server that is the host the DB you want to connect to.
    * *sql_db* - name of the DB.
    * *sql_user* - name of the SQL user you are going to use to establish the connection between NAV service and SQL server.
    SQL login must already be present on SQL server and must have required permissions.
    * *sql_pwd* - password of the SQL user.
    *!!! PLEASE, BE AWARE THAT **ENV** PARAMETERS CAN BE REVEALED USING DOCKER INSPECT AND FOR THIS REASONS THIS IS A SECURITY ISSUE WE WILL TRY TO SOLVE TO IN THE FUTURE !!!*
    * *nav_user* - name of the NAV user (will be created when doesn`t exist).
    * *nav_user_pwd* - password of the NAV user.
    *!!! PLEASE, BE AWARE THAT **ENV** PARAMETERS CAN BE REVEALED USING DOCKER INSPECT AND FOR THIS REASONS THIS IS A SECURITY ISSUE WE WILL TRY TO SOLVE TO IN THE FUTURE !!!*
    * *import_cronus_license* - true/false - if true, the Cronus license will be imported from the installation DVD.
    * *config_instance* - true/false - if the specified instance already exists (e.g. DynamicsNAV) you can change the behaviour of the startup script to reconfigure or don`t the existing instance.

    You can see some of the parameters in the *_***.bat* scripts but let`s see some examples here:
    ```docker
    # This is the most trivial docker run. As you can see we are going to run the container in the detached mode.
    # Detached mode is ideal for a regular use (long time runs).
    docker run -d --hostname=NAVSERVER -e "sql_server=sql_ip\sql_instance" -e "sql_db=navdbname" -e "sql_user=user" -e "sql_pwd=pwd" -e "nav_user=navuser" -e "nav_user_pwd=pwd" my-nav-image

    # If you have any problems to make a connection from NAV against the container you can add port mapping which will also expose the internal ports.
    # In this case, we map the port 1:1 but you can also map the private ports to different public ports.
    # In my case I don`t need it, everything works as supposed even without the port mapping as Dockerfile includes EXPOSE instruction for these ports.
    # But tfenster had problems on Azure to access the container without these mappings.
    docker run -d -p 7045-7048:7045-7048 --hostname=NAVSERVER -e "sql_server=sql_ip\sql_instance" -e "sql_db=navdbname" -e "sql_user=user" -e "sql_pwd=pwd" -e "nav_user=navuser" -e "nav_user_pwd=pwd" my-nav-image

    # You can also specify the name of the created container. It is simple, just use --name parameter.
    # This could be helpful when referencing the container later in some scripts.
    docker run -d --name=my_new_container --hostname=NAVSERVER -e "sql_server=sql_ip\sql_instance" -e "sql_db=navdbname" -e "sql_user=user" -e "sql_pwd=pwd" -e "nav_user=navuser" -e "nav_user_pwd=pwd" my-nav-image

    # You can also run the container in the interactive mode. You would use it especially during the tests and debugging.
    # Just add -ti parameters instead of -d parameter. 
    # Specially useful for testing and debugging - you can also add --rm, this will remove the container when existted. You don`t need to delete it later.
    docker run -ti --rm --hostname=NAVSERVER -e "sql_server=sql_ip\sql_instance" -e "sql_db=navdbname" -e "sql_user=user" -e "sql_pwd=pwd" -e "nav_user=navuser" -e "nav_user_pwd=pwd" my-nav-image

    # And for purposes of the pure debugging you can use the following example which will just create the container based on the image.
    # It will also override the startup script - in this case just powershell will be executed and you can run whatever you want inside the container.
    # You can also see the volume mapping. In this way you can optimize scripts outside the container and those will be able in c:\scripts inside
    # of the container. Then you can execute those scripts. In the same way you can also redirect outputs from the container.
    docker run -ti --rm --hostname=NAVSERVER -v %cd%\content\scripts:c:\scripts my-nav-image powershell
    ```

    I would strongly recommend reading at least something about [docker run](https://docs.docker.com/engine/reference/run/) and [docker build](https://docs.docker.com/engine/reference/commandline/build/) to understand the basics of the technology.
    If you are interested even more you can see also something about [dockerfiles](https://docs.docker.com/engine/reference/builder/).

    As we are working on the windows platform you should also [Windows Containers on MSDN](https://docs.microsoft.com/virtualization/windowscontainers/about/).
