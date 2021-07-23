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

init_server_properties() {
  if [ ! -f "${SERVER_PROPERTIES}" ]; then
    cd $SERVER_PATH
    java -jar $ARTIFACTS_PATH/minecraft_server.$VERSION.jar nogui --initSettings
    cd $MCJE_HOME
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

#Check EULA
if [[ "x${EULA^^}" != "xTRUE" ]]; then
  echo "ERROR: EULA variable must be TRUE!"
  echo "See https://minecraft.net/terms"
  exit 1
else
    echo "eula=true" > $DATA_PATH/eula.txt
fi
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
source $MCJE_HOME/scripts/server-properties.sh
update_server_properties
#Update whitelist.json
update_whitelist
#Update permissions.json
update_permissions
#Check addons
source $MCJE_HOME/scripts/addons.sh
check_addons
#Check pack directories
for PACK_TYPE in behavior_packs resource_packs ; do
  check_pack_type $PACK_TYPE
done

echo "Starting Minecraft Java Server Version ${VERSION} with the following configuration:"
echo "########## SERVER PROPERTIES ##########"
cat $SERVER_PROPERTIES | grep "=" | grep -v "\#" | sort
echo "###############################"
echo ""
# echo "########## WHITELIST ##########"
# cat $SERVER_WHITELIST
# echo "#################################"
# echo ""
# echo "########## PERMISSIONS ##########"
# cat $SERVER_PERMISSIONS
# echo "#################################"

cd $SERVER_PATH/

java -Xmx1024M -Xms1024M -jar $ARTIFACTS_PATH/minecraft_server.$VERSION.jar nogui
