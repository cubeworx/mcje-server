[![Docker Pulls](https://img.shields.io/docker/pulls/cubeworx/mcje-server.svg)](https://hub.docker.com/r/cubeworx/mcje-server)
[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/cubeworx/mcje-server/latest)](https://hub.docker.com/r/cubeworx/mcje-server)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/cubeworx/mcje-server/blob/master/LICENSE)
[![Twitter](https://img.shields.io/twitter/follow/cubeworx?label=Follow&style=social)](https://twitter.com/intent/follow?screen_name=cubeworx)

CubeWorx Minecraft Java Edition Server Image
==============

This image is a self-contained Minecraft Java Edition Server with support for add-ons. It is intended for use in the upcoming CubeWork ecosystem but is also being provided for use in the Minecraft community.

## Quickstart

```
docker run -d -it -p 25565:25565 -e EULA=true cubeworx/mcje-server
```

## Configuration

The image runs with default or recommended configurations but can be customized through environment variables. Changing any of the environment variables from their defaults will update the server.properties file as described here: https://minecraft.fandom.com/wiki/Server.properties#Java_Edition_3


### Customized Default Configuration

|                               |                                                                           |
|-------------------------------|---------------------------------------------------------------------------|
| `LEVEL_NAME="Bedrock-Level"`  | Default level name of world. Customized to remove space in default name   |
| `OPERATORS_LOOKUP="true"`     | Specify if player xuids get verified from online api or written as is     |
| `OPERATORS_MODE="static"`     | Specify if permissions file gets overwritten every time container starts  |
| `SERVER_NAME="CubeWorx-MCJE"` | Default server name that shows up when added to multiplayer server list   |
| `WHITELIST_ENABLE="false"`    | Specify if connected players must be listed in WHITELIST_USERS variable   |
| `WHITELIST_LOOKUP="true"`     | Specify if player usernames get verified from online api or written as is |
| `WHITELIST_MODE="static"`     | Specify if whitelist file gets overwritten every time container starts    |

## Volumes

The image utilizes a volume at the `/mcje/data` path for persistent storage. This path contains `addons`, `artifacts`, `backups`, `worlds` and other custom configuration files.

You can mount this volume on the host via docker-compose:
```
version: '3.8'
volumes:
  mcje-data:
    driver: local
services:
  mcje-server:
    volumes:
    - mcje-data:/mcje/data
```
or via the command line:

```
docker run -d -it -p 25565:25565 -v $(pwd):/mcje/data -e EULA=true cubeworx/mcje-server
```
```
docker volume create mcje-data
docker run -d -it -p 25565:25565 -v mcje-data:/mcje/data -e EULA=true cubeworx/mcje-server
```
## Whitelist

The whitelist is the list of player usernames that are allowed to connect to your server when `WHITELIST_ENABLE="true"` which should be set if your server is going to be publicly accessible. By default the whitelist file gets overwritten whenever the container starts/restarts to ensure that the usernames match what is in the config.
Setting `WHITELIST_MODE="dynamic"` will allow whitelist changes made in the game to be retained upon start/restart of the container. Since usernames are case-sensitive, they are verified against an API to make sure there aren't any mistakes. This lookup can be disabled by setting `WHITELIST_LOOKUP="false"`.
The whitelist file is generated from the names included in the `WHITELIST_USERS` or `OPERATORS`. It is not necessary to enter a username in more than one environment variable. The following example will result in four names being added to the whitelist.

```
-e WHITELIST_USERS=player1,player2,player3 -e OPERATORS=operator1
```

## Seeds
Seeds are special codes that can generate worlds in Minecraft when the server is launched. They cover a variety of places and provide new opportunites to build and explore. A seed can only be specified when first launching the server and once a world has been created then adding, changing, or removing the seed has no impact.
To specify a seed then use the `LEVEL_SEED` environment variable. You can search online to find seeds to play or you can set `LEVEL_SEED=random` and one will be pulled from the seeds.txt file included in the image.
