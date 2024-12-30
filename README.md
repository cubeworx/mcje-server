[![Build](https://img.shields.io/github/workflow/status/cubeworx/mcje-server/build-push-docker)](https://github.com/cubeworx/mcje-server/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/cubeworx/mcje-server.svg)](https://hub.docker.com/r/cubeworx/mcje-server)
[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/cubeworx/mcje-server?sort=semver)](https://hub.docker.com/r/cubeworx/mcje-server)
[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/cubeworx/mcje-server/latest)](https://hub.docker.com/r/cubeworx/mcje-server)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/cubeworx/mcje-server/blob/master/LICENSE)
[![Twitter](https://img.shields.io/twitter/follow/cubeworx?label=Follow&style=social)](https://twitter.com/intent/follow?screen_name=cubeworx)

CubeWorx Minecraft Java Edition Server Image
==============

This image is a self-contained Minecraft Java Edition Server. It is intended for use in the upcoming CubeWork ecosystem but is also being provided for use in the Minecraft community.

## Quickstart

```
docker run -d -it -p 25565:25565 -e EULA=true cubeworx/mcje-server
```

## Configuration

The image runs with default or recommended configurations but can be customized through environment variables. Changing any of the environment variables from their defaults will update the server.properties file as described here: https://minecraft.fandom.com/wiki/Server.properties#Java_Edition_3


### Customized Default Configuration

|                               |                                                                           |
|-------------------------------|---------------------------------------------------------------------------|
| `JVM_MAX_MEMORY="1024M"`      | the maximum memory allocation pool the Java executable may use            |
| `JVM_MIN_MEMORY="1024M"`      | the initial memory allocation pool the Java executable will use           |
| `LEVEL_NAME="Java-Level"`     | Default level name of world. Customized to remove space in default name   |
| `OPERATORS_LOOKUP="true"`     | Specify if player xuids get verified from online api or written as is     |
| `OPERATORS_MODE="static"`     | Specify if permissions file gets overwritten every time container starts  |
| `SERVER_NAME="CubeWorx-MCJE"` | Default MOTD that shows up when added to multiplayer server list          |
| `WHITELIST_ENABLE="false"`    | Specify if connected players must be listed in WHITELIST_USERS variable   |
| `WHITELIST_LOOKUP="true"`     | Specify if player usernames get verified from online api or written as is |
| `WHITELIST_MODE="static"`     | Specify if whitelist file gets overwritten every time container starts    |

The following environment variables are basic ones that you might want to change to customize the game play to your liking. 

- `ALLOW_NETHER`
- `DIFFICULTY`
- `GAME_MODE`
- `HARDCORE`
- `LEVEL_NAME`
- `LEVEL_SEED`
- `LEVEL_TYPE`
- `ONLINE_MODE`
- `PVP`
- `SERVER_NAME`
- `SERVER_PORT`
- `SPAWN_ANIMALS`
- `SPAWN_MONSTERS`
- `SPAWN_NPCS`


### Advanced Server Properties Environment Variables

The following environment variables are more advanced ones that you might want to change to optimize the management or performance of your server.

- `ALLOW_FLIGHT`
- `BROADCAST_CONSOLE_TO_OPS`
- `BROADCAST_RCON_TO_OPS`
- `ENABLE_COMMAND_BLOCK`
- `ENABLE_JMX_MONITORING`
- `ENABLE_QUERY`
- `ENABLE_RCON`
- `ENABLE_STATUS`
- `ENFORCE_WHITELIST`
- `ENTITY_BROADCAST_RANGE_PERCENTAGE`
- `FORCE_GAMEMODE`
- `FUNCTION_PERMISSION_LEVEL`
- `GENERATE_STRUCTURES`
- `MAX_PLAYERS`
- `MAX_TICK_TIME`
- `MAX_WORLD_SIZE`
- `NETWORK_COMPRESSION_THRESHOLD`
- `OP_PERMISSION_LEVEL`
- `PLAYER_IDLE_TIMEOUT`
- `PREVENT_PROXY_CONNECTIONS`
- `QUERY_PORT`
- `RATE_LIMIT`
- `RCON_PASSWORD`
- `RCON_PORT`
- `REQUIRE_RESOURCE_PACK`
- `RESOURCE_PACK`
- `RESOURCE_PACK_PROMPT`
- `RESOURCE_PACK_SHA1`
- `SNOOPER_ENABLED`
- `SPAWN_PROTECTION`
- `SYNC_CHUNK_WRITES`
- `TEXT_FILTERING_CONFIG`
- `USE_NATIVE_TRANSPORT`
- `VIEW_DISTANCE`

## Volumes

The image utilizes a volume at the `/mcje/data` path for persistent storage. This path contains `artifacts`, `backups`, `worlds` and other custom configuration files.

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

## Operators

The Operators variable can be a comma-sepearated list of usernames or UUIDs since the values are verified against a Mojang API when the container first starts. This lookup can be disabled by setting `OPERATORS_LOOKUP="false"` but then will require exact usernames to be entered for each user.
By default the operators file gets overwritten whenever the container starts/restarts to ensure that the operator permissions match what is in the config. Setting `OPERATORS_MODE="dynamic"` will allow operator changes made in the game to be retained upon start/restart of the container.
If `WHITELIST_ENABLE="true"` then players in the `OPERATORS` variable will automatically be added to the server whitelist.

To give operators a different permission level than what is set in `OP_PERMISSION_LEVEL` (default 4) put a pipe `|` after the name/uuid and the number of permission level (1-4) the operator should have.

```
-e OPERATORS=operator1,4566e69fc90748ee8d71d7ba5aa00d20,operator2|3,operator3|3
```

## Seeds
Seeds are special codes that can generate worlds in Minecraft when the server is launched. They cover a variety of places and provide new opportunites to build and explore. A seed can only be specified when first launching the server and once a world has been created then adding, changing, or removing the seed has no impact.
To specify a seed then use the `LEVEL_SEED` environment variable. You can search online to find seeds to play or you can set `LEVEL_SEED=random` and one will be pulled from the seeds.txt file included in the image.

## Thanks

This image was initially inspired by [itzg/docker-minecraft-server](https://github.com/itzg/docker-minecraft-server)! If you are looking to run Java servers other than the "Vanilla" version provided by Mojang or add lots of mods then we recommend you giving his image a try.