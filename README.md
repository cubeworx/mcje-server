[![Docker Pulls](https://img.shields.io/docker/pulls/cubeworx/mcje-server.svg)](https://hub.docker.com/r/cubeworx/mcje-server)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/cubeworx/mcje-server/blob/master/LICENSE.md)

CubeWorx Minecraft Java Edition Server Image
==============

This image is a self-contained Minecraft Java Edition Server with support for add-ons. It is intended for use in the upcoming CubeWork ecosystem but is also being provided for use in the Minecraft community.



## Seeds
Seeds are special codes that can generate worlds in Minecraft when the server is launched. They cover a variety of places and provide new opportunites to build and explore. A seed can only be specified when first launching the server and once a world has been created then adding, changing, or removing the seed has no impact.
To specify a seed then use the `LEVEL_SEED` environment variable. You can search online to find seeds to play or you can set `LEVEL_SEED=random` and one will be pulled from the seeds.txt file included in the image.


## Add-Ons

Add-ons are ways of enhancing game play by adding custom code and features to the game. Presently supported add-ons are `behavior_packs` and `resource_packs` and end in one of these extensions: `.addons`, `.mcpack`, or `.zip`
To add an add-on to a server take the following steps:

1. Launch a new server with a volume mounted to the host.
2. Copy the compressed add-on file into the `addons` folder of the data directory on the host.
3. Restart the container for the startup script to detect the addons and add them to their respective directories.