# These functions generate the ops.json & whitelist.json files
# Because operators can update whitelist.json too, need to process whitelist first

check_whitelist() {
  #Check whitelist mode
  if [[ "${WHITELIST_MODE,,}" == "static" ]] || [[ "${WHITELIST_MODE,,}" == "dynamic" ]]; then
    #If static, overwrite file at start
    if [[ "${WHITELIST_MODE,,}" == "static" ]] && [[ "${SERVER_INITIALIZED}" == "false" ]] ; then
      echo "[]" > "${WHITELIST_FILE}"
    elif [[ "${WHITELIST_MODE,,}" == "static" ]] && [[ "${SERVER_INITIALIZED}" == "true" ]] ; then
      cat "${SERVER_PATH}/whitelist.json.cached" > "${WHITELIST_FILE}"
    #If dynamic, create file in data directory if doesn't exist
    elif [[ "${WHITELIST_MODE,,}" == "dynamic" ]] && [ ! -f "${WHITELIST_FILE}" ]; then
      echo "[]" > "${WHITELIST_FILE}"
    fi
  else
    echo "ERROR: Invalid option for WHITELIST_MODE!"
    echo "Options are: 'static' or 'dymamic'"
    exit 1
  fi
  #If whitelist is enabled check usernames
  #Because whitelist.json is case sensitive prefer to verify username
  if [[ "${WHITELIST_ENABLE,,}" == "true" ]]; then
    #If WHITELIST_USERS not empty and not already initialized
    if [[ -n $WHITELIST_USERS ]] && [[ "${SERVER_INITIALIZED}" == "false" ]]; then
      #If lookup enabled verify from api
      if [[ "${WHITELIST_LOOKUP,,}" == "true" ]]; then
        # shellcheck disable=SC2001
        for USER in $(echo "${WHITELIST_USERS}" | sed "s/,/ /g"); do
          playerdb_lookup "${USER}"
        done
      #If lookup disabled write values from env vars
      elif [[ "${WHITELIST_LOOKUP,,}" == "false" ]]; then
        jq -n --arg users "${WHITELIST_USERS}" '$users | split(",") | map({"name": .})' > "${WHITELIST_FILE}"
      else
        echo "ERROR: Invalid option for WHITELIST_LOOKUP!"
        echo "Options are: 'true' or 'false'"
        exit 1
      fi
    fi
  fi
}

check_operators() {
  #Check operators mode
  if [[ "${OPERATORS_MODE,,}" == "static" ]] || [[ "${OPERATORS_MODE,,}" == "dynamic" ]]; then
    #If static, overwrite file at start
    if [[ "${OPERATORS_MODE,,}" == "static" ]] && [[ "${SERVER_INITIALIZED}" == "false" ]] ; then
      echo "[]" > "${OPERATORS_FILE}"
    elif [[ "${OPERATORS_MODE,,}" == "static" ]] && [[ "${SERVER_INITIALIZED}" == "true" ]] ; then
      cat "${SERVER_PATH}/ops.json.cached" > "${OPERATORS_FILE}"
    #If dynamic, create file in data directory if doesn't exist
    elif [[ "${OPERATORS_MODE,,}" == "dynamic" ]] && [ ! -f "${OPERATORS_FILE}" ]; then
      echo "[]" > "${OPERATORS_FILE}"
    fi
  else
    echo "ERROR: Invalid option for OPERATORS_MODE!"
    echo "Options are: 'static' or 'dymamic'"
    exit 1
  fi
  #If environment variables aren't empty then update permissions if not intialized
  if [[ -n $OPERATORS ]]; then
    if [[ "${SERVER_INITIALIZED}" == "false" ]]; then
      #If lookup enabled verify from api
      if [[ "${OPERATORS_LOOKUP,,}" == "true" ]]; then
        # shellcheck disable=SC2001
        for OPERATOR in $(echo "${OPERATORS}" | sed "s/,/ /g"); do
          #Check for operator level value in string
          if [[ "${OPERATOR}"  =~ | ]]; then
            USER_OP_PERMISSION_LEVEL=$(echo "${OPERATOR}"  | cut -d"|" -f2)
            OPERATOR=$(echo "${OPERATOR}"  | cut -d"|" -f1)
          fi
          #If operator value is 1-4 use it, otherwise use default
          if [[ "${USER_OP_PERMISSION_LEVEL}" =~ ^[1-4]+$ ]]; then
            OP_PERMISSION_LEVEL=$USER_OP_PERMISSION_LEVEL
            unset USER_OP_PERMISSION_LEVEL
          else
            DEFAULT_OP_PERMISSION_LEVEL=$(grep "op-permission-level=" "${SERVER_PROPERTIES}" | cut -d"=" -f2)
            if [[ -n $DEFAULT_OP_PERMISSION_LEVEL ]]; then
              OP_PERMISSION_LEVEL=$DEFAULT_OP_PERMISSION_LEVEL
            fi
          fi
          playerdb_lookup "${OPERATOR}" "${OP_PERMISSION_LEVEL}"
        done
      #If lookup disabled write values from env vars
      elif [[ "${OPERATORS_LOOKUP,,}" == "false" ]]; then
        jq -n --arg operators "${OPERATORS}" '$operators | split(",") | map({"name": .})' > "${OPERATORS_FILE}"
      else
        echo "ERROR: Invalid option for OPERATORS_LOOKUP!"
        echo "Options are: 'true' or 'false'"
        exit 1
      fi
    fi
  fi
}

playerdb_lookup() {
  PLAYERID=$1
  OP_PERMISSION_LEVEL=$2
  #Make call to get profile data
  PLAYERDB_PROFILE_DATA=$(curl -fsSL -A "cubeworx/mcje-server:${VERSION}" -H "accept-language:*" "${PLAYERDB_LOOKUP_URL}/${PLAYERID}")
  #If receive proper data update files, otherwise fail silently
  # shellcheck disable=SC2086
  # shellcheck disable=SC2126
  if [[ $(echo $PLAYERDB_PROFILE_DATA | grep -i success | grep found | wc -l) -ne 0 ]]; then
    PLAYER_USERNAME=$(echo $PLAYERDB_PROFILE_DATA | jq -r '.data.player.username')
    PLAYER_UUID=$(echo $PLAYERDB_PROFILE_DATA | jq -r '.data.player.id')
    #Update operators
    if [[ -n $OP_PERMISSION_LEVEL ]]; then
      update_operators "${PLAYER_USERNAME}" "${PLAYER_UUID}" "${OP_PERMISSION_LEVEL}" 
    fi
    #Update whitelist too
    if [[ "${WHITELIST_ENABLE,,}" == "true" ]]; then
      update_whitelist "${PLAYER_USERNAME}" "${PLAYER_UUID}"
    fi
  fi
}

update_operators() {
  OPERATOR_NAME=$1
  OPERATOR_UUID=$2
  OP_PERMISSION_LEVEL=$3
  OPERATOR_INFO="{\"name\": \"${OPERATOR_NAME}\", \"uuid\": \"${OPERATOR_UUID}\", \"level\": \"${OP_PERMISSION_LEVEL}\", \"bypassesPlayerLimit\": true }"
  if [[ $(jq --arg UUID "${OPERATOR_UUID}" -r '.[]|select(.uuid == $UUID)' "${OPERATORS_FILE}" | wc -l) -eq 0 ]]; then
    echo "Adding ${OPERATOR_NAME} ${OPERATOR_UUID} to ${OPERATORS_FILE}"
    jq ". |= . + [${OPERATOR_INFO}]" "${OPERATORS_FILE}" > "${OPERATORS_FILE}.tmp"
    mv "${OPERATORS_FILE}.tmp" "${OPERATORS_FILE}"
  fi
}

update_whitelist() {
  WHITELIST_NAME=$1
  WHITELIST_UUID=$2
  WHITELIST_INFO="{\"name\": \"${WHITELIST_NAME}\", \"uuid\": \"${WHITELIST_UUID}\" }"
  if [[ $(jq --arg UUID "${WHITELIST_UUID}" -r '.[]|select(.uuid == $UUID)' "${WHITELIST_FILE}" | wc -l) -eq 0 ]]; then
    echo "Adding ${WHITELIST_NAME} ${WHITELIST_UUID} to ${WHITELIST_FILE}"
    jq ". |= . + [${WHITELIST_INFO}]" "${WHITELIST_FILE}" > "${WHITELIST_FILE}.tmp"
    mv "${WHITELIST_FILE}.tmp" "${WHITELIST_FILE}"
  fi
}

create_cache_files() {
  #Create copies of ops.json & whitelist.json at init if modes are static
  if [[ "${OPERATORS_MODE,,}" == "static" ]] && [[ "${SERVER_INITIALIZED}" == "false" ]] ; then
    cp "${OPERATORS_FILE}" "${SERVER_PATH}/ops.json.cached"
  fi
  if [[ "${WHITELIST_MODE,,}" == "static" ]] && [[ "${SERVER_INITIALIZED}" == "false" ]] ; then
    cp "${WHITELIST_FILE}" "${SERVER_PATH}/whitelist.json.cached"
  fi
}