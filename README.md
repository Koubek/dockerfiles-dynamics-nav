# Dockerfiles for MS Dynamics NAV
[![Join the chat at https://gitter.im/dockerfiles-dynamics-nav/Lobby](https://badges.gitter.im/dockerfiles-dynamics-nav/Lobby.svg)](https://gitter.im/dockerfiles-dynamics-nav/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Dockerfiles for MS Dynamics NAV let you build and run MS Dynamics NAV (at least 2016 and 2017 but in some circumstances even older versions) via Docker and avoid so the problems related to the maintenance of multiple versions (and Cumulative Updates) in your DEV environment.

# **WORK IN PROGRESS!!!**

# **redesign** branch has been merged recently into **master** to achieve the following changes:
 * Change the whole structure of the project (separate **BUILD** and **RUN** / **COMPOSE UP** processes).
 * Migrate from BAT files to PS files.
 * Improve the efFiciency to be able user docker images in the compose files (swarm reasons).
 * Create several images for different purposes (win auth, sql auth, nav web server, sql server) and tag them correctly (specific NAV version).
 * And even more...

# Documentation will be updated soon.