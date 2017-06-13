# Dockerfiles for MS Dynamics NAV - root directory

Instantiate single independent NAV container. The SQL must be already present somewhere and must be accessible.

 * ### <a name="runSqlAuth"></a> `_run.sqlAuth.ps1`
    * Creates an independent NAV container on the default network (we are considering to be a **nat** network).
    * This container requires an existing and accessible SQL server instance. The authentication between NAV and SQL service will be provided via **SQL login** so you have to enable **Mixed Mode** on the SQL server and create/know a *SQL server login* with *db_owner* privileges on the target database.
    * NAV user authentication uses **NavUserPassword**.
    * Please, just change all necessary parameters (*-e* values) in the script, eventually, you also change the network driver and remove port mappings etc.
    * On the `nat network` you have to map the ports (`-p` flag) to be able access them (then you access the host ports from the other machines).

 * ### <a name="runWinAuthTransparentNat"></a> `_run.winAuth.transparentNet.ps1`
    * **This demo requires gMSA to be active and properly configured!!!**
    * Creates an independent NAV container on a `transparent network`. This type of networking allows you to integrate the containers fully with your network. You can use `DHCP` to assign an IP address automatically or you can assign a static one. You can then access the container using its `--hostname` or the statically assigned `IP address` from any device on the same network. Please, read about [Docker Networking](https://docs.microsoft.com/cs-cz/virtualization/windowscontainers/manage-containers/container-networking) to understand all related details.    
    * You need to set `--hostname` parameter to match your `gMSA` account name (current limitation of the Docker).
    * This container requires an existing and accessible SQL server instance. The database already should be present on the instance. The authentication between NAV and SQL server will be provided via **Windows Authentication** so you have to create a *Windows login* on the SQL server with *db_owner* privileges on the target database.
    * NAV user authentication uses **Windows**. This must be properly created in the target database.
    * On the `transparent network` you don\`t map the ports, you just expose them (`--expose` flag).

 * ### <a name="runWinAuthTransparentNat"></a> `_run.winAuth.natNet.ps1`
    * Creates an independent NAV container on the default network (we are considering to be a **nat** network).
    * **This demo requires gMSA to be active and properly configured.**
    * You need to set `--hostname` parameter to match your `gMSA` account name (current limitation of the Docker).
    * This container requires an existing and accessible SQL server instance. The database already should be present on the instance. The authentication between NAV and SQL server will be provided via **Windows Authentication** so you have to create a *Windows login* on the SQL server with *db_owner* privileges on the target database.
    * NAV user authentication uses **Windows**. This must be properly created in the target database.
    * On the `nat network` you have to map the ports (`-p` flag) to be able access them (then you access the host ports from the other machines).
