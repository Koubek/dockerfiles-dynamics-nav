# Dockerfiles for MS Dynamics NAV - root directory
[![Join the chat at https://gitter.im/dockerfiles-dynamics-nav/Lobby](https://badges.gitter.im/dockerfiles-dynamics-nav/Lobby.svg)](https://gitter.im/dockerfiles-dynamics-nav/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Instantiate independent NAV containers (right now an example with SQL authentication between NAV and SQL as well on the client side). The SQL must be already present somewhere and must be accessible.

 * `_run.sqlAuth.ps1`
    * Creates an independent NAV container on the default network (we are considering to be a **nat** network).
    * This container requires an existing and accessible SQL server instance. The authentication between NAV and SQL service will be provided via **SQL login** so you have to enable **Mixed Mode** on the SQL server and create/know a *SQL server login* with *db_owner* privileges on the target database.
    * NAV user authentication uses **NavUserPassword**.
    * Please, just change all necessary parameters (*-e* values) in the script, eventually, you also change the network driver and remove port mappings etc.
 * `_run.winAuth.ps1`
    * Creates an independent NAV container on the default network (we are considering to be a **nat** network).
    * This container requires an existing and accessible SQL server instance. The authentication between NAV and SQL server will be provided via **Windows Authentication** so you have to create a *Windows login* on the SQL server with *db_owner* privileges on the target database.
    * NAV user authentication uses **Windows**. This must be properly created in the target database.
    * **This demo requires gMSA to be active and properly configured.**
