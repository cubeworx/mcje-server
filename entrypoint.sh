#!/bin/bash

set -e

EULA=$EULA
MCJE_HOME=${MCJE_HOME:-"/mcbe"}
ADDONS_PATH=${ADDONS_PATH:-"/mcje/data/addons"}
ARTIFACTS_PATH=${ARTIFACTS_PATH:-"/mcje/data/artifacts"}
DATA_PATH=${DATA_PATH:-"/mcje/data"}
SEEDS_FILE=${SEEDS_FILE:-"/mcje/seeds.txt"}
SERVER_PATH=${SERVER_PATH:-"/mcje/server"}
SERVER_PERMISSIONS=${SERVER_WHITELIST:-"/mcje/server/permissions.json"}
SERVER_PROPERTIES=${SERVER_PROPERTIES:-"/mcje/server/server.properties"}
SERVER_WHITELIST=${SERVER_WHITELIST:-"/mcje/server/whitelist.json"}
VERSION=${VERSION:-"LATEST"}
VERSIONS_FILE=${VERSIONS_FILE:-"/mcje/versions.txt"}
VERSIONS_URL=${VERSIONS_URL:-"https://launchermeta.mojang.com/mc/game/version_manifest.json"}

check_data_dir() {
  DIR_NAME=$1
  if [ ! -d "${DATA_PATH}/${DIR_NAME}" ]; then
    echo "Creating directory: ${DATA_PATH}/${DIR_NAME}"
    mkdir -p $DATA_PATH/$DIR_NAME
  fi
}

get_latest_version() {
  LATEST_VERSION=$(echo $VERSIONS_DATA | jq -r '.latest.release')
  #Check if website curl worked, if not default to latest from versions.txt
  if [[ "x${LATEST_VERSION}" != "x" ]]; then
    echo "Latest version available is: ${LATEST_VERSION}"
    VERSION=$LATEST_VERSION
  else
    echo "ERROR: Unable to determine latest version, defaulting to latest in ${VERSIONS_FILE}!"
    VERSION=$(head -n 1 $VERSIONS_FILE)
  fi
  if [ ! -f "${ARTIFACTS_PATH}/minecraft_server.${VERSION}.jar" ]; then
    get_version_info $VERSION
  fi
}

get_version_info() {
  VERSION=$1
  SPECIFIC_VERSION_DATA_URL=$(echo $VERSIONS_DATA | jq --arg VERSION "${VERSION}" -r '.versions[]|select(.id == $VERSION).url')
  if [[ "x${SPECIFIC_VERSION_DATA_URL}" != "x" ]]; then
    SPECIFIC_VERSION_DATA=$(curl -fsSL -A "cubeworx/mcje-server" -H "accept-language:*" $SPECIFIC_VERSION_DATA_URL)
    if [[ "x${SPECIFIC_VERSION_DATA}" != "x" ]]; then
      VERSION_DOWNLOAD_URL=$(echo $SPECIFIC_VERSION_DATA | jq -r '.downloads.server.url')
      VERSION_HASH=$(echo $SPECIFIC_VERSION_DATA | jq -r '.downloads.server.sha1')
      download_file $VERSION_DOWNLOAD_URL $ARTIFACTS_PATH/minecraft_server.$VERSION.jar $VERSION_HASH
    else
      echo "ERROR: Unable to determine download url for version ${VERSION}!"
      exit 1
    fi
  else
    echo "ERROR: Unable to download manifest file for version ${VERSION}!"
    exit 1
  fi
}

download_file(){
  DOWNLOAD_URL=$1
  DOWNLOAD_FILE=$2
  DOWNLOAD_SHA1=$3
  echo "Downloading ${DOWNLOAD_URL} to ${DOWNLOAD_FILE}"
  curl -Ss $DOWNLOAD_URL -o $DOWNLOAD_FILE
  if [ ! -f $DOWNLOAD_FILE ]; then
    echo "ERROR: File failed to download!"
    exit 1
  elif [[ "x${DOWNLOAD_SHA1}" != "x" ]]; then
    FILE_SHA1=$(sha1sum $DOWNLOAD_FILE | cut -d" " -f1)
    echo "Verifying SHA-1."
    echo "Expected SHA-1: ${DOWNLOAD_SHA1}"
    echo "File SHA-1: ${FILE_SHA1}"
    if [[ "x${DOWNLOAD_SHA1}" == "x${FILE_SHA1}" ]]; then
      echo "Success! Expected SHA-1 and file SHA-1 match!"
    else
      echo "ERROR: Expected SHA-1 and file SHA-1 do not match!"
      exit 1
    fi
  fi
}

prepare_server_path() {
  if [ ! -d "${SERVER_PATH}" ]; then
    mkdir -p $SERVER_PATH
  fi
  compare_version
  echo $VERSION > $DATA_PATH/version.txt
}

compare_version() {
  if [ -f "${DATA_PATH}/version.txt" ]; then
    OLD_VER=$(cat $DATA_PATH/version.txt)
    if [[ "x${OLD_VER}" != "x${VERSION}" ]]; then
      DATE_TIME=$(date +%Y%m%d%H%M%S)
      echo "Previous version was ${OLD_VER}, current version is ${VERSION}"
      echo "Creating backup of data before version change."
      echo "Backup file: ${DATA_PATH}/backups/${DATE_TIME}_${OLD_VER}_to_${VERSION}.mcworld"
      zip -r $DATA_PATH/backups/${DATE_TIME}_${OLD_VER}_to_${VERSION}.mcworld $DATA_PATH/worlds
    fi
  fi
}

check_symlinks() {
  LINK_NAME=$1
  if [ ! -L "${SERVER_PATH}/${LINK_NAME}" ]; then
    echo "Creating symlink ${SERVER_PATH}/${LINK_NAME} to ${DATA_PATH}/${LINK_NAME}"
    ln -s $DATA_PATH/$LINK_NAME $SERVER_PATH/$LINK_NAME
  fi
}

check_addons() {
  echo "Checking for .mcaddon, .mcpack, or .zip files in ${ADDONS_PATH}."
  if [ ! -d "${ADDONS_PATH}" ]; then
    mkdir -p $ADDONS_PATH
  fi
  if [ ! -f "${ADDONS_PATH}/readme.txt" ]; then
    echo "Place .mcaddon, .mcpack, or .zip files here for them to be added to the server" > $ADDONS_PATH/readme.txt
  fi
  for EXT_TYPE in mcaddon mcpack zip ; do
    EXT_CHECK=$(ls -alh $ADDONS_PATH 2> /dev/null | grep ".${EXT_TYPE}" | wc -l)
    if [[ $EXT_CHECK -ne 0 ]]; then
      for FNAME in $ADDONS_PATH/*.$EXT_TYPE ; do
        echo "Unzipping ${FNAME}"
        unzip -q $FNAME -d $ADDONS_PATH/unzipped
        #If manifest.json exists then file is a pack
        if [ -f "${ADDONS_PATH}/unzipped/manifest.json" ]; then
          move_pack "${ADDONS_PATH}/unzipped"
        else
          #If folders exist, loop through looking for manifest.json
          for DIR in $ADDONS_PATH/unzipped/*/ ; do
            if [ -f "${DIR}/manifest.json" ]; then
              move_pack "${DIR}"
            fi
          done
        fi
        #Delete temporary directory if it exists
        if [ -d "${ADDONS_PATH}/unzipped" ]; then
          rm -rf $ADDONS_PATH/unzipped
        fi
        rm -rf $FNAME
      done
    fi
  done
}

move_pack() {
  PACK_TMP_PATH=$1
  PACK_UUID=$(cat $PACK_TMP_PATH/manifest.json | jq -cr '.header.uuid')
  PACK_TYPE=$(cat $PACK_TMP_PATH/manifest.json | jq -cr '.modules[].type')
  if [[ "x${PACK_TYPE,,}" == "xdata" ]] || [[ "x${PACK_TYPE,,}" == "xresources" ]]; then
    if [[ "x${PACK_TYPE,,}" == "xdata" ]]; then
      PACK_TYPE_FOLDER="behavior_packs"
    elif [[ "x${PACK_TYPE,,}" == "xresources" ]]; then
      PACK_TYPE_FOLDER="resource_packs"
    fi
    if [ ! -d "${ADDONS_PATH}/${PACK_TYPE_FOLDER}" ]; then
      echo "Creating directory ${ADDONS_PATH}/${PACK_TYPE_FOLDER}"
      mkdir $ADDONS_PATH/$PACK_TYPE_FOLDER
    fi
    mv "${PACK_TMP_PATH}" "${ADDONS_PATH}/${PACK_TYPE_FOLDER}/${PACK_UUID}"
  fi
}

check_pack_type() {
  PACK_TYPE=$1
  echo "Checking ${ADDONS_PATH} for ${PACK_TYPE}."
  if [ -d "${ADDONS_PATH}/${PACK_TYPE}" ]; then
    #Get world name
    LEVEL_NAME=$(cat $SERVER_PROPERTIES | grep "^level-name=" | awk -F 'level-name=' '{print $2}')
    WORLD_PATH=$DATA_PATH/worlds/$LEVEL_NAME
    if [ ! -d "${WORLD_PATH}" ]; then
      echo "Creating directory ${WORLD_PATH}"
      mkdir -p "${WORLD_PATH}"
    fi
    echo "Creating ${WORLD_PATH}/world_${PACK_TYPE}.json"
    echo "[]" > "${WORLD_PATH}/world_${PACK_TYPE}.json"
    #If folders exist, loop through looking for manifest.json
    for PACK_DIR in $ADDONS_PATH/$PACK_TYPE/*/ ; do
      if [ -f "${PACK_DIR}/manifest.json" ]; then
        PACK_NAME=$(cat $PACK_DIR/manifest.json | jq -cr '.header.name')
        PACK_UUID=$(basename $PACK_DIR)
        PACK_VERSION=$(cat $PACK_DIR/manifest.json | jq -cr '.header.version')
        PACK_SERVER_PATH=$SERVER_PATH/$PACK_TYPE/$PACK_UUID
        #Create symlink if not exists
        if [ ! -L "${SERVER_PATH}/${PACK_TYPE}/${PACK_UUID}" ]; then
          echo "Creating symlink ${PACK_SERVER_PATH} to ${PACK_DIR}"
          ln -s $PACK_DIR $PACK_SERVER_PATH
        fi
        #Add uuid & version to world pack
        echo "Adding ${PACK_NAME} uuid & version to ${WORLD_PATH}/world_${PACK_TYPE}.json"
        PACK_INFO="{\"pack_id\": \"${PACK_UUID}\", \"version\": ${PACK_VERSION} }"
        jq ". |= . + [${PACK_INFO}]" "${WORLD_PATH}/world_${PACK_TYPE}.json" > "${WORLD_PATH}/world_${PACK_TYPE}.tmp"
        mv "${WORLD_PATH}/world_${PACK_TYPE}.tmp" "${WORLD_PATH}/world_${PACK_TYPE}.json"
      fi
    done
  fi
}

init_server_properties() {
  if [ ! -f "${SERVER_PROPERTIES}" ]; then
    cd $SERVER_PATH
    java -jar $ARTIFACTS_PATH/minecraft_server.$VERSION.jar nogui --initSettings
    cd $MCJE_HOME
  fi
}

update_server_properties() {
  #ALLOW_FLIGHT
  if [[ "x${ALLOW_FLIGHT}" != "x" ]]; then
    if [[ "x${ALLOW_FLIGHT,,}" == "xtrue" ]] || [[ "x${ALLOW_FLIGHT,,}" == "xfalse" ]]; then
      sed -i "s/allow-flight=.*/allow-flight=${ALLOW_FLIGHT}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for ALLOW_FLIGHT!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #ALLOW_NETHER
  if [[ "x${ALLOW_NETHER}" != "x" ]]; then
    if [[ "x${ALLOW_NETHER,,}" == "xtrue" ]] || [[ "x${ALLOW_NETHER,,}" == "xfalse" ]]; then
      sed -i "s/allow-nether=.*/allow-nether=${ALLOW_NETHER}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for ALLOW_NETHER!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #BROADCAST_CONSOLE_TO_OPS
  if [[ "x${BROADCAST_CONSOLE_TO_OPS}" != "x" ]]; then
    if [[ "x${BROADCAST_CONSOLE_TO_OPS,,}" == "xtrue" ]] || [[ "x${BROADCAST_CONSOLE_TO_OPS,,}" == "xfalse" ]]; then
      sed -i "s/broadcast-console-to-ops=.*/broadcast-console-to-ops=${BROADCAST_CONSOLE_TO_OPS}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for BROADCAST_CONSOLE_TO_OPS!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #BROADCAST_RCON_TO_OPS
  if [[ "x${BROADCAST_RCON_TO_OPS}" != "x" ]]; then
    if [[ "x${BROADCAST_RCON_TO_OPS,,}" == "xtrue" ]] || [[ "x${BROADCAST_RCON_TO_OPS,,}" == "xfalse" ]]; then
      sed -i "s/broadcast-rcon-to-ops=.*/broadcast-rcon-to-ops=${BROADCAST_RCON_TO_OPS}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for BROADCAST_RCON_TO_OPS!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #DIFFICULTY
  if [[ "x${DIFFICULTY}" != "x" ]]; then
    if [[ "x${DIFFICULTY,,}" == "xpeaceful" ]] || [[ "x${DIFFICULTY,,}" == "xeasy" ]] || [[ "x${DIFFICULTY,,}" == "xnormal" ]] || [[ "x${DIFFICULTY,,}" == "xhard" ]]; then
      sed -i "s/difficulty=.*/difficulty=${DIFFICULTY}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for DIFFICULTY!"
      echo "Options are: 'peaceful', 'easy', 'normal', or 'hard'"
      exit 1
    fi
  fi
  #ENABLE_COMMAND_BLOCK
  if [[ "x${ENABLE_COMMAND_BLOCK}" != "x" ]]; then
    if [[ "x${ENABLE_COMMAND_BLOCK,,}" == "xtrue" ]] || [[ "x${ENABLE_COMMAND_BLOCK,,}" == "xfalse" ]]; then
      sed -i "s/enable-command-block=.*/enable-command-block=${ENABLE_COMMAND_BLOCK}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for ENABLE_COMMAND_BLOCK!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #ENABLE_JMX_MONITORING
  if [[ "x${ENABLE_JMX_MONITORING}" != "x" ]]; then
    if [[ "x${ENABLE_JMX_MONITORING,,}" == "xtrue" ]] || [[ "x${ENABLE_JMX_MONITORING,,}" == "xfalse" ]]; then
      sed -i "s/enable-jmx-monitoring=.*/enable-jmx-monitoring=${ENABLE_JMX_MONITORING}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for ENABLE_JMX_MONITORING!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #ENABLE_QUERY
  if [[ "x${ENABLE_QUERY}" != "x" ]]; then
    if [[ "x${ENABLE_QUERY,,}" == "xtrue" ]] || [[ "x${ENABLE_QUERY,,}" == "xfalse" ]]; then
      sed -i "s/enable-query=.*/enable-query=${ENABLE_QUERY}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for ENABLE_QUERY!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #ENABLE_RCON
  if [[ "x${ENABLE_RCON}" != "x" ]]; then
    if [[ "x${ENABLE_RCON,,}" == "xtrue" ]] || [[ "x${ENABLE_RCON,,}" == "xfalse" ]]; then
      sed -i "s/enable-rcon=.*/enable-rcon=${ENABLE_RCON}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for ENABLE_RCON!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #ENABLE_STATUS
  if [[ "x${ENABLE_STATUS}" != "x" ]]; then
    if [[ "x${ENABLE_STATUS,,}" == "xtrue" ]] || [[ "x${ENABLE_STATUS,,}" == "xfalse" ]]; then
      sed -i "s/enable-status=.*/enable-status=${ENABLE_STATUS}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for ENABLE_STATUS!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #ENFORCE_WHITELIST
  if [[ "x${ENFORCE_WHITELIST}" != "x" ]]; then
    if [[ "x${ENFORCE_WHITELIST,,}" == "xtrue" ]] || [[ "x${ENFORCE_WHITELIST,,}" == "xfalse" ]]; then
      sed -i "s/enforce-whitelist=.*/enforce-whitelist=${ENFORCE_WHITELIST}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for ENFORCE_WHITELIST!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #ENTITY_BROADCAST_RANGE_PERCENTAGE
  if [[ "x${ENTITY_BROADCAST_RANGE_PERCENTAGE}" != "x" ]]; then
    if [[ "${ENTITY_BROADCAST_RANGE_PERCENTAGE}" -gt 9 ]] && [[ "${ENTITY_BROADCAST_RANGE_PERCENTAGE}" -lt 1001 ]]; then
      sed -i "s/entity-broadcast-range-percentage=.*/entity-broadcast-range-percentage=${ENTITY_BROADCAST_RANGE_PERCENTAGE}/" $SERVER_PROPERTIES
    else
      echo "ERROR: ENTITY_BROADCAST_RANGE_PERCENTAGE must be a number between 10-1000!"
      exit 1
    fi
  fi
  #FORCE_GAMEMODE
  if [[ "x${FORCE_GAMEMODE}" != "x" ]]; then
    if [[ "x${FORCE_GAMEMODE,,}" == "xtrue" ]] || [[ "x${FORCE_GAMEMODE,,}" == "xfalse" ]]; then
      sed -i "s/force-gamemode=.*/force-gamemode=${FORCE_GAMEMODE}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for FORCE_GAMEMODE!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #FUNCTION_PERMISSION_LEVEL
  if [[ "x${FUNCTION_PERMISSION_LEVEL}" != "x" ]]; then
    if [[ "${FUNCTION_PERMISSION_LEVEL}" -gt 0 ]] && [[ "${FUNCTION_PERMISSION_LEVEL}" -lt 5 ]]; then
      sed -i "s/function-permission-level=.*/function-permission-level=${FUNCTION_PERMISSION_LEVEL}/" $SERVER_PROPERTIES
    else
      echo "ERROR: FUNCTION_PERMISSION_LEVEL must be a number between 1-4!"
      exit 1
    fi
  fi
  #GAME_MODE
  if [[ "x${GAME_MODE}" != "x" ]]; then
    if [[ "x${GAME_MODE,,}" == "xsurvival" ]] || [[ "x${GAME_MODE,,}" == "xcreative" ]] || [[ "x${GAME_MODE,,}" == "xadventure" ]]; then
      sed -i "s/gamemode=.*/gamemode=${GAME_MODE}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for GAME_MODE!"
      echo "Options are: 'survival', 'creative', or 'adventure'"
      exit 1
    fi
  fi
  #HARDCORE
  if [[ "x${HARDCORE}" != "x" ]]; then
    if [[ "x${HARDCORE,,}" == "xtrue" ]] || [[ "x${HARDCORE,,}" == "xfalse" ]]; then
      sed -i "s/hardcore=.*/hardcore=${HARDCORE}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for HARDCORE!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #LEVEL_NAME
  if [[ "x${LEVEL_NAME}" != "x" ]]; then
    sed -i "s/level-name=.*/level-name=${LEVEL_NAME}/" $SERVER_PROPERTIES
    #TODO: Add logic to check for legal file names
  fi
  #LEVEL_SEED
  if [[ "x${LEVEL_SEED}" != "x" ]] || [ -f "${DATA_PATH}/seed.txt" ]; then
    #If seed.txt exists, use its value instead of ENV
    if [ -f "${DATA_PATH}/seed.txt" ]; then
      echo "Using seed from existing world's seed.txt file!"
      LEVEL_SEED=$(cat $DATA_PATH/seed.txt)
    #If ENV is random then choose one from list
    elif [[ "x${LEVEL_SEED,,}" == "xrandom" ]]; then
      echo "Choosing random seed from integrated seeds list."
      LEVEL_SEED=$(sort $SEEDS_FILE -uR | head -n 1)
    fi
    echo $LEVEL_SEED > $DATA_PATH/seed.txt
    sed -i "s/level-seed=.*/level-seed=${LEVEL_SEED}/" $SERVER_PROPERTIES
    #level-seed missing from recent downloads, insert if env var exists
    if [[ $(cat $SERVER_PROPERTIES | grep "level-seed" | wc -l) -eq 0 ]]; then
      echo "level-seed="${LEVEL_SEED^^} >> $SERVER_PROPERTIES
    fi
  fi
  #LEVEL_TYPE
  if [[ "x${LEVEL_TYPE}" != "x" ]]; then
    if [[ "x${LEVEL_TYPE,,}" == "xdefault" ]] || [[ "x${LEVEL_TYPE,,}" == "xflat" ]] || [[ "x${LEVEL_TYPE,,}" == "xlegacy" ]]; then
      sed -i "s/level-type=.*/level-type=${LEVEL_TYPE^^}/" $SERVER_PROPERTIES
      #level-type missing from recent downloads, insert if env var exists
      if [[ $(cat $SERVER_PROPERTIES | grep "level-type" | wc -l) -eq 0 ]]; then
        echo "level-type="${LEVEL_TYPE^^} >> $SERVER_PROPERTIES
      fi
    else
      echo "ERROR: Invalid option for LEVEL_TYPE!"
      echo "Options are: 'default', 'flat', or 'legacy'"
      exit 1
    fi
  fi
  #MAX_PLAYERS
  if [[ "x${MAX_PLAYERS}" != "x" ]]; then
    if [[ "${MAX_PLAYERS}" =~ ^[0-9]+$ ]]; then
      sed -i "s/max-players=.*/max-players=${MAX_PLAYERS}/" $SERVER_PROPERTIES
    else
      echo "ERROR: MAX_PLAYERS must be a number!"
      exit 1
    fi
  fi
  #max-tick-time=
  #max-world-size=
  #motd=
  #network-compression-threshold=
  #ONLINE_MODE
  if [[ "x${ONLINE_MODE}" != "x" ]]; then
    if [[ "x${ONLINE_MODE,,}" == "xtrue" ]] || [[ "x${ONLINE_MODE,,}" == "xfalse" ]]; then
      sed -i "s/online-mode=.*/online-mode=${ONLINE_MODE}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for ONLINE_MODE!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #op-permission-level
  #PLAYER_IDLE_TIMEOUT
  if [[ "x${PLAYER_IDLE_TIMEOUT}" != "x" ]]; then
    if [[ "${PLAYER_IDLE_TIMEOUT}" =~ ^[0-9]+$ ]]; then
      sed -i "s/player-idle-timeout=.*/player-idle-timeout=${PLAYER_IDLE_TIMEOUT}/" $SERVER_PROPERTIES
    else
      echo "ERROR: PLAYER_IDLE_TIMEOUT must be a number between 3-32!"
      exit 1
    fi
  fi
  #prevent-proxy-connections
  #pvp
  #query.port
#   rate-limit=0
# rcon.password=
  #RCON_PORT
  if [[ "x${RCON_PORT}" != "x" ]]; then
    if [[ "${RCON_PORT}" -gt 0 ]] && [[ "${RCON_PORT}" -lt 65536 ]]; then
      sed -i "s/rcon.port=.*/rcon.port=${RCON_PORT}/" $SERVER_PROPERTIES
    else
      echo "ERROR: RCON_PORT must be a number between 1-65535!"
      exit 1
    fi
  fi
# require-resource-pack=false
# resource-pack-prompt=
# resource-pack-sha1=
# resource-pack=
# server-ip=
  #SERVER_PORT
  if [[ "x${SERVER_PORT}" != "x" ]]; then
    if [[ "${SERVER_PORT}" -gt 0 ]] && [[ "${SERVER_PORT}" -lt 65536 ]]; then
      sed -i "s/server-port=.*/server-port=${SERVER_PORT}/" $SERVER_PROPERTIES
    else
      echo "ERROR: SERVER_PORT must be a number between 1-65535!"
      exit 1
    fi
  fi
# snooper-enabled=true
# spawn-animals=true
# spawn-monsters=true
# spawn-npcs=true
# spawn-protection=16
# sync-chunk-writes=true
# text-filtering-config=
# use-native-transport=true
  #VIEW_DISTANCE
  if [[ "x${VIEW_DISTANCE}" != "x" ]]; then
    if [[ "${VIEW_DISTANCE}" -gt 2 ]] && [[ "${VIEW_DISTANCE}" -lt 33 ]]; then
      sed -i "s/view-distance=.*/view-distance=${VIEW_DISTANCE}/" $SERVER_PROPERTIES
    else
      echo "ERROR: VIEW_DISTANCE must be a positive number greater than 4!"
      exit 1
    fi
  fi
  #WHITE_LIST
  if [[ "x${WHITE_LIST}" != "x" ]]; then
    if [[ "x${WHITE_LIST,,}" == "xtrue" ]] || [[ "x${WHITE_LIST,,}" == "xfalse" ]]; then
      if [[ "x${WHITE_LIST,,}" == "xtrue" ]] && [[ "x${WHITELIST_USERS}" == "x" ]]; then
        echo "ERROR: If WHITE_LIST is true then WHITELIST_USERS cannot be empty!"
        exit 1
      else
        sed -i "s/white-list=.*/white-list=${WHITE_LIST}/" $SERVER_PROPERTIES
      fi
    else
      echo "ERROR: Invalid option for WHITE_LIST!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
}

update_whitelist() {
  if [[ "x${WHITELIST_USERS}" != "x" ]] && [[ "x${WHITE_LIST,,}" == "xtrue" ]]; then
    jq -n --arg users "${WHITELIST_USERS}" '$users | split(",") | map({"name": .})' > $SERVER_WHITELIST
  fi
}

update_permissions() {
  if [[ "x${OPERATORS}" != "x" ]] || [[ "x${MEMBERS}" != "x" ]] || [[ "x${VISITORS}" != "x" ]]; then
    jq -n --arg operators "$OPERATORS" --arg members "$MEMBERS" --arg visitors "$VISITORS" '[
    [$operators | split(",") | map({permission: "operator", xuid:.})],
    [$members   | split(",") | map({permission: "member", xuid:.})],
    [$visitors  | split(",") | map({permission: "visitor", xuid:.})]
    ]| flatten' > $SERVER_PERMISSIONS
  fi
}

# #Check EULA
# if [[ "x${EULA^^}" != "xTRUE" ]]; then
#   echo "ERROR: EULA variable must be TRUE!"
#   echo "See https://minecraft.net/terms"
#   exit 1
# else
    echo "eula=true" > $DATA_PATH/eula.txt
# fi
#Check necessary data directories
for DIR_NAME in addons artifacts backups logs worlds ; do
  check_data_dir $DIR_NAME
done
#If not initialized
#Determine download version
VERSIONS_DATA=$(curl -fsSL -A "cubeworx/mcje-server" -H "accept-language:*" $VERSIONS_URL)
if [[ "x${VERSION}" == "xLATEST" ]]; then
  get_latest_version
else
  if [ ! -f "${ARTIFACTS_PATH}/minecraft_server.${VERSION}.jar" ]; then
    get_version_info $VERSION
  fi
fi
prepare_server_path
# #Check necessary symlinks
for LINK_NAME in eula.txt logs worlds ; do
  check_symlinks $LINK_NAME
done
#Create properties file for specific version
init_server_properties
#fi
#Update server.properties
update_server_properties
# #Update whitelist.json
# update_whitelist
# #Update permissions.json
# update_permissions
# #Check addons
# check_addons
# #Check pack directories
# for PACK_TYPE in behavior_packs resource_packs ; do
#   check_pack_type $PACK_TYPE
# done

echo "Starting Minecraft Java Server Version ${VERSION} with the following configuration:"
echo "########## SERVER PROPERTIES ##########"
cat $SERVER_PROPERTIES | grep "=" | grep -v "\#" | sort
echo "###############################"
# echo ""
# echo "########## WHITELIST ##########"
# cat $SERVER_WHITELIST
# echo "#################################"
# echo ""
# echo "########## PERMISSIONS ##########"
# cat $SERVER_PERMISSIONS
# echo "#################################"
# cd $SERVER_PATH/


cd $SERVER_PATH/

ls -alh

#java -Xmx1024M -Xms1024M -jar $ARTIFACTS_PATH/minecraft_server.$VERSION.jar nogui

ls -alh

cat eula.txt
cat server.properties