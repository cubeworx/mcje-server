#!/bin/bash

set -e

EULA=${EULA:-""}
MCJE_HOME=${MCJE_HOME:-"/mcje"}
ADDONS_PATH=${ADDONS_PATH:-"/mcje/data/addons"}
ARTIFACTS_PATH=${ARTIFACTS_PATH:-"/mcje/data/artifacts"}
DATA_PATH=${DATA_PATH:-"/mcje/data"}
EXEC_NAME="cbwx-mcje-${SERVER_NAME// /-}-server"
JVM_MAX_MEMORY=${JVM_MAX_MEMORY:-"1024M"}
JVM_MIN_MEMORY=${JVM_MIN_MEMORY:-"1024M"}
JVM_OPTS=${JVM_OPTS:-""}
OPERATORS_FILE=${OPERATORS_FILE:-"/mcje/data/ops.json"}
OPERATORS_LOOKUP=${OPERATORS_LOOKUP:-"true"}
OPERATORS_MODE=${OPERATORS_MODE:-"static"}
PLAYERDB_LOOKUP_URL=${PLAYERDB_LOOKUP_URL:-"https://playerdb.co/api/player/xbox"}
SEEDS_FILE=${SEEDS_FILE:-"/mcje/seeds.txt"}
SERVER_PATH=${SERVER_PATH:-"/mcje/server"}
SERVER_PROPERTIES=${SERVER_PROPERTIES:-"/mcje/server/server.properties"}
USER_LOOKUP_URL=${USER_LOOKUP_URL:-"https://sessionserver.mojang.com/session/minecraft/profile"}
UUID_LOOKUP_URL=${UUID_LOOKUP_URL:-"https://api.mojang.com/users/profiles/minecraft"}
VERSION=${VERSION:-"LATEST"}
VERSIONS_FILE=${VERSIONS_FILE:-"/mcje/versions.txt"}
VERSIONS_URL=${VERSIONS_URL:-"https://launchermeta.mojang.com/mc/game/version_manifest.json"}
WHITELIST_ENABLE=${WHITELIST_ENABLE:-"false"}
WHITELIST_FILE=${WHITELIST_FILE:-"/mcje/data/whitelist.json"}
WHITELIST_LOOKUP=${WHITELIST_LOOKUP:-"true"}
WHITELIST_MODE=${WHITELIST_MODE:-"static"}

check_data_dir() {
  DIR_NAME=$1
  if [ ! -d "${DATA_PATH}/${DIR_NAME}" ]; then
    echo "Creating directory: ${DATA_PATH}/${DIR_NAME}"
    mkdir -p "${DATA_PATH}/${DIR_NAME}"
  fi
}

get_latest_version() {
  LATEST_VERSION=$(echo "${VERSIONS_DATA}" | jq -r '.latest.release')
  #Check if website curl worked, if not default to latest from versions.txt
  if [[ -n $LATEST_VERSION ]]; then
    echo "Latest version available is: ${LATEST_VERSION}"
    VERSION=$LATEST_VERSION
  else
    echo "ERROR: Unable to determine latest version, defaulting to latest in ${VERSIONS_FILE}!"
    VERSION=$(head -n 1 "${VERSIONS_FILE}")
  fi
  if [ ! -f "${ARTIFACTS_PATH}/minecraft_server.${VERSION}.jar" ]; then
    get_version_info "${VERSION}"
  fi
}

get_version_info() {
  VERSION=$1
  SPECIFIC_VERSION_DATA_URL=$(echo "${VERSIONS_DATA}" | jq --arg VERSION "${VERSION}" -r '.versions[]|select(.id == $VERSION).url')
  if [[ -n $SPECIFIC_VERSION_DATA_URL ]]; then
    SPECIFIC_VERSION_DATA=$(curl -fsSL -A "cubeworx/mcje-server" -H "accept-language:*" "${SPECIFIC_VERSION_DATA_URL}")
    if [[ -n $SPECIFIC_VERSION_DATA ]]; then
      VERSION_DOWNLOAD_URL=$(echo "${SPECIFIC_VERSION_DATA}" | jq -r '.downloads.server.url')
      VERSION_HASH=$(echo "${SPECIFIC_VERSION_DATA}" | jq -r '.downloads.server.sha1')
      download_file "${VERSION_DOWNLOAD_URL}" "${ARTIFACTS_PATH}/minecraft_server.${VERSION}.jar" "${VERSION_HASH}"
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
  curl -Ss "${DOWNLOAD_URL}" -o "${DOWNLOAD_FILE}"
  if [ ! -f "${DOWNLOAD_FILE}" ]; then
    echo "ERROR: File failed to download!"
    exit 1
  elif [[ -n $DOWNLOAD_SHA1 ]]; then
    FILE_SHA1=$(sha1sum "${DOWNLOAD_FILE}" | cut -d" " -f1)
    echo "Verifying SHA-1."
    echo "Expected SHA-1: ${DOWNLOAD_SHA1}"
    echo "File SHA-1: ${FILE_SHA1}"
    if [[ "${DOWNLOAD_SHA1}" == "${FILE_SHA1}" ]]; then
      echo "Success! Expected SHA-1 and file SHA-1 match!"
    else
      echo "ERROR: Expected SHA-1 and file SHA-1 do not match!"
      exit 1
    fi
  fi
}

prepare_server_path() {
  if [ ! -d "${SERVER_PATH}" ]; then
    mkdir -p "${SERVER_PATH}"
  fi
  # shellcheck disable=SC2046
  JAVA_DIR=$(dirname $(which java))
  if [ ! -L "${JAVA_DIR}/${EXEC_NAME}" ]; then
    echo "Creating ${EXEC_NAME} symlink to java executable for easier host process identification."
    ln -s "${JAVA_DIR}/java" "${JAVA_DIR}/${EXEC_NAME}"
  fi
  compare_version
  echo "${VERSION}" > "${DATA_PATH}/version.txt"
}

prepare_world_level_path() {
  if [ ! -d "${DATA_PATH}/worlds/${LEVEL_NAME}" ]; then
    mkdir -p "${DATA_PATH}/worlds/${LEVEL_NAME}"
  fi
  if [ ! -L "${SERVER_PATH}/${LEVEL_NAME}" ]; then
    echo "Creating symlink ${SERVER_PATH}/${LEVEL_NAME} to ${DATA_PATH}/worlds/${LEVEL_NAME}"
    ln -s "${DATA_PATH}/worlds/${LEVEL_NAME}" "${SERVER_PATH}/${LEVEL_NAME}"
  fi
}

compare_version() {
  if [ -f "${DATA_PATH}/version.txt" ]; then
    OLD_VER=$(cat "${DATA_PATH}/version.txt")
    if [[ "x${OLD_VER}" != "x${VERSION}" ]]; then
      DATE_TIME=$(date +%Y%m%d%H%M%S)
      echo "Previous version was ${OLD_VER}, current version is ${VERSION}"
      echo "Creating backup of data before version change."
      echo "Backup file: ${DATA_PATH}/backups/${DATE_TIME}_${LEVEL_NAME// /-}_${OLD_VER}_to_${VERSION}.mcworld"
      zip -r "${DATA_PATH}/backups/${DATE_TIME}_${LEVEL_NAME// /-}_${OLD_VER}_to_${VERSION}.mcworld" "${DATA_PATH}/worlds"
    fi
  fi
}

check_symlinks() {
  LINK_NAME=$1
  if [ ! -L "${SERVER_PATH}/${LINK_NAME}" ]; then
    echo "Creating symlink ${SERVER_PATH}/${LINK_NAME} to ${DATA_PATH}/${LINK_NAME}"
    ln -s "${DATA_PATH}/${LINK_NAME}" "${SERVER_PATH}/${LINK_NAME}"
  fi
}

init_server_properties() {
  if [ ! -f "${SERVER_PROPERTIES}" ]; then
    echo "Temporarily starting minecraft server to generate correct server.properties file for version."
    cd "${SERVER_PATH}"
    java -jar "${ARTIFACTS_PATH}/minecraft_server.${VERSION}.jar" --nogui --initSettings
    cd "${MCJE_HOME}"
  fi
}

#Check EULA
if [[ "x${EULA^^}" != "xTRUE" ]]; then
  echo "ERROR: EULA variable must be TRUE!"
  echo "See https://minecraft.net/terms"
  exit 1
else
  echo "eula=true" > "${DATA_PATH}/eula.txt"
fi
#Check necessary data directories
for DIR_NAME in addons artifacts backups logs worlds ; do
  check_data_dir $DIR_NAME
done
#Check if already initialized
if [ ! -f "${SERVER_PATH}/usercache.json" ]; then
  SERVER_INITIALIZED="false"
  #Determine download version
  VERSIONS_DATA=$(curl -fsSL -A "cubeworx/mcje-server" -H "accept-language:*" "${VERSIONS_URL}")
  if [[ "${VERSION^^}" == "LATEST" ]]; then
    get_latest_version
  else
    if [ ! -f "${ARTIFACTS_PATH}/minecraft_server.${VERSION}.jar" ]; then
      get_version_info "${VERSION}"
    fi
  fi
  prepare_server_path
  prepare_world_level_path
  # #Check necessary symlinks
  for LINK_NAME in eula.txt logs ops.json whitelist.json ; do
    check_symlinks $LINK_NAME
  done
  #Create properties file for specific version
  init_server_properties
else
  #If already initialized, need to read in version & not lookup users
  # shellcheck disable=SC2034
  SERVER_INITIALIZED="true"
  echo "###########################################"
  echo "Already initialized. Did container restart?"
  VERSION=$(cat "${DATA_PATH}/version.txt")
fi
#Update server.properties
source "${MCJE_HOME}/scripts/server-properties.sh"
update_server_properties
#Check operators & whitelist
source "${MCJE_HOME}/scripts/operators-whitelist.sh"
check_whitelist
check_operators
create_cache_files
#Configure logging
source "${MCJE_HOME}/scripts/logging.sh"
configure_logging
echo "Starting Minecraft Java Server Version ${VERSION} with the following configuration:"
echo "########## SERVER PROPERTIES ##########"
# shellcheck disable=SC2002
cat "${SERVER_PROPERTIES}" | grep "=" | grep -v "\#" | sort
echo "###############################"
echo ""
echo "########## OPERATORS ##########"
cat "${OPERATORS_FILE}"
echo "#################################"
echo ""
echo "########## WHITELIST ##########"
cat "${WHITELIST_FILE}"
echo "#################################"

cd "${SERVER_PATH}"/

# shellcheck disable=SC2086
$EXEC_NAME -Xms$JVM_MIN_MEMORY -Xmx$JVM_MAX_MEMORY $JVM_OPTS -jar "${ARTIFACTS_PATH}/minecraft_server.${VERSION}.jar" --nogui