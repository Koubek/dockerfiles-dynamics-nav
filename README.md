# Dockerfiles for MS Dynamics NAV
[![Join the chat at https://gitter.im/dockerfiles-dynamics-nav/Lobby](https://badges.gitter.im/dockerfiles-dynamics-nav/Lobby.svg)](https://gitter.im/dockerfiles-dynamics-nav/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Dockerfiles for MS Dynamics NAV let you build and run MS Dynamics NAV (at least 2016 and 2017 but in some circumstances, even older versions) via Docker and avoid so the problems related to the maintenance of multiple versions (and Cumulative Updates) in your DEV environment.

You need to consider purposes of your interest. It is important to differentiate the following reasons you would like to use MS Dynamics NAV on Docker:

 * ### You are just curious to try this possibility, you can\`t experiment on the domain level (you don\`t have privileges to do so) or/and you don\`t expect any further steps to use it in your environment. We can consider this approach as a demo approach. In this case:

   * Extract **NAVDVD** content into the following folder: [root/__content_user/NAVDVD]
   (root/__content_user/NAVDVD).
   * When running in the **docker compose** mode you also need to put your SQL db (backup or already extracted DB) here: [root/__content_user/SQLDB](root/__content_user/SQLDB).

   * Build your image. Details [here](root/build).
   * [Click here](root/run/nav#-_runsqlauthps1) to run just NAV container or [click here](root/run/nav-sql) to run NAV + SQL containers in the **docker compose** mode.
     

 * ### Maybe you have already tried the first option, maybe you haven\`t. Anyway, you consider Docker as a very promising way how to run some piece of software, in this case, MS Dynamics NAV. All we know that multiple versions combined with multiple Cumulative Updates make our lives sometimes difficult. I mean the lives of developers or administrators but generally, I am talking about the partners because they (and their employees) are facing these problems. I am talking about DEV environments, about DevOps. If you belong to this group and if you have a vision that Docker could help you solve those problems in DEV environment, please:

   * Extract **NAVDVD** content into the following folder: [root/__content_user/NAVDVD](root/__content_user/NAVDVD).
   * When running in the **docker compose** mode you also need to put your SQL db (backup or already extracted DB) here: [root/__content_user/SQLDB](root/__content_user/SQLDB).

   * Build your image. Details [here](root/build).
   * [Click here](root/run/nav#-_runwinauthtransparentnetps1) to run just one NAV container or eventually [click here](root/run/nav-sql-web) to run SQL + NAV + WEB containers in the **docker compose** mode.

 * ### The last group will reflect customers (end users) or situation when thinking about deployment in the production environment. There is nothing else to say but **DON\`T DO IT!!!** Microsoft does not provide MS Dynamics NAV with any kind of support when deployed via Docker. Of course, it`s a pity because our customer could benefit from, for example, running NAV on Docker Swarm (native cluster from Docker) and scale and balance NAV services dynamically.
