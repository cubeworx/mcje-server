# These functions generate the ops.json & whitelist.json files
# Because operators can update whitelist.json too, need to process whitelist first

check_whitelist() {
  #Check whitelist mode
  if [[ "x${WHITELIST_MODE,,}" == "xstatic" ]] || [[ "x${WHITELIST_MODE,,}" == "xdynamic" ]]; then
    #If static, overwrite file at start
    if [[ "x${WHITELIST_MODE,,}" == "xstatic" ]] && [[ "x${SERVER_INITIALIZED}" == "xfalse" ]] ; then
      echo "[]" > $WHITELIST_FILE
    elif [[ "x${WHITELIST_MODE,,}" == "xstatic" ]] && [[ "x${SERVER_INITIALIZED}" == "xtrue" ]] ; then
      cat $SERVER_PATH/whitelist.json.cached > $WHITELIST_FILE
    #If dynamic, create file in data directory if doesn't exist
    elif [[ "x${WHITELIST_MODE,,}" == "xdynamic" ]] && [ ! -f "${WHITELIST_FILE}" ]; then
      echo "[]" > $WHITELIST_FILE
    fi
  else
    echo "ERROR: Invalid option for WHITELIST_MODE!"
    echo "Options are: 'static' or 'dymamic'"
    exit 1
  fi
  #If whitelist is enabled check usernames
  #Because whitelist.json is case sensitive prefer to verify username
  if [[ "x${WHITELIST_ENABLE,,}" == "xtrue" ]]; then
    #If WHITELIST_USERS not empty and not already initialized
    if [[ "x${WHITELIST_USERS}" != "x" ]] && [[ "x${SERVER_INITIALIZED}" == "xfalse" ]]; then
      #If lookup enabled verify from api
      if [[ "x${WHITELIST_LOOKUP,,}" == "xtrue" ]]; then
        for USER in $(echo $WHITELIST_USERS | sed "s/,/ /g"); do
          #Determine if value is username or uuid
          if [[ $(echo ${#USER}) -gt 3 ]] && [[ $(echo ${#USER}) -lt 17 ]] ; then #username
            lookup_mojang_profile username $USER
          elif [[ $(echo ${#USER}) -gt 31 ]] && [[ $(echo ${#USER}) -lt 37 ]] ; then #uuid
            lookup_mojang_profile uuid $USER
          fi
        done
      #If lookup disabled write values from env vars
      elif [[ "x${WHITELIST_LOOKUP,,}" == "xfalse" ]]; then
        jq -n --arg users "${WHITELIST_USERS}" '$users | split(",") | map({"name": .})' > $WHITELIST_FILE
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
  if [[ "x${OPERATORS_MODE,,}" == "xstatic" ]] || [[ "x${OPERATORS_MODE,,}" == "xdynamic" ]]; then
    #If static, overwrite file at start
    if [[ "x${OPERATORS_MODE,,}" == "xstatic" ]] && [[ "x${SERVER_INITIALIZED}" == "xfalse" ]] ; then
      echo "[]" > $OPERATORS_FILE
    elif [[ "x${OPERATORS_MODE,,}" == "xstatic" ]] && [[ "x${SERVER_INITIALIZED}" == "xtrue" ]] ; then
      cat $SERVER_PATH/ops.json.cached > $OPERATORS_FILE
    #If dynamic, create file in data directory if doesn't exist
    elif [[ "x${OPERATORS_MODE,,}" == "xdynamic" ]] && [ ! -f "${OPERATORS_FILE}" ]; then
      echo "[]" > $OPERATORS_FILE
    fi
  else
    echo "ERROR: Invalid option for OPERATORS_MODE!"
    echo "Options are: 'static' or 'dymamic'"
    exit 1
  fi
  #If environment variables aren't empty then update permissions if not intialized
  if [[ "x${OPERATORS}" != "x" ]]; then
    if [[ "x${SERVER_INITIALIZED}" == "xfalse" ]]; then
      #If lookup enabled verify from api
      if [[ "x${OPERATORS_LOOKUP,,}" == "xtrue" ]]; then
        for OPERATOR in $(echo $OPERATORS | sed "s/,/ /g"); do
          #Check for operator level value in string
          if [[ $OPERATOR =~ "|" ]]; then
            USER_OP_PERMISSION_LEVEL=$(echo $OPERATOR | cut -d"|" -f2)
            OPERATOR=$(echo $OPERATOR | cut -d"|" -f1)
          fi
          #If operator value is 1-4 use it, otherwise use default
          if [[ "${USER_OP_PERMISSION_LEVEL}" =~ ^[1-4]+$ ]]; then
            OP_PERMISSION_LEVEL=$USER_OP_PERMISSION_LEVEL
            unset USER_OP_PERMISSION_LEVEL
          else
            DEFAULT_OP_PERMISSION_LEVEL=$(cat $SERVER_PROPERTIES | grep "op-permission-level=" | cut -d"=" -f2)
            if [[ "x${DEFAULT_OP_PERMISSION_LEVEL}" != "x" ]]; then
              OP_PERMISSION_LEVEL=$DEFAULT_OP_PERMISSION_LEVEL
            fi
          fi
          #Determine if value is username or uuid
          if [[ $(echo ${#OPERATOR}) -gt 3 ]] && [[ $(echo ${#OPERATOR}) -lt 17 ]] ; then #username
            lookup_mojang_profile username $OPERATOR $OP_PERMISSION_LEVEL
          elif [[ $(echo ${#OPERATOR}) -gt 31 ]] && [[ $(echo ${#OPERATOR}) -lt 37 ]] ; then #uuid
            lookup_mojang_profile uuid $OPERATOR $OP_PERMISSION_LEVEL
          fi
        done
      #If lookup disabled write values from env vars
      elif [[ "x${OPERATORS_LOOKUP,,}" == "xfalse" ]]; then
        jq -n --arg operators "${OPERATORS}" '$operators | split(",") | map({"name": .})' > $OPERATORS_FILE
      else
        echo "ERROR: Invalid option for OPERATORS_LOOKUP!"
        echo "Options are: 'true' or 'false'"
        exit 1
      fi
    fi
  fi
}

lookup_mojang_profile() {
  MOJANG_LOOKUP=$1
  MOJANG_STRING=$2
  OP_PERMISSION_LEVEL=$3
  if [[ "x${MOJANG_LOOKUP}" == "xuuid" ]]; then
    MOJANG_LOOKUP_URL="${USER_LOOKUP_URL}/${MOJANG_STRING}"
  elif [[ "x${MOJANG_LOOKUP}" == "xusername" ]]; then
    MOJANG_LOOKUP_URL="${UUID_LOOKUP_URL}/${MOJANG_STRING}"
  fi
  #Make call to get profile data
  MOJANG_PROFILE_DATA=$(curl -fsSL -A "cubeworx/mcje-server:${VERSION}" -H "accept-language:*" ${MOJANG_LOOKUP_URL})
  #If receive proper data update files, otherwise fail silently
  if [[ $(echo $MOJANG_PROFILE_DATA | grep name | grep id | wc -l) -ne 0 ]]; then
    MOJANG_USERNAME=$(echo $MOJANG_PROFILE_DATA | jq -r '.name')
    MOJANG_UUID=$(echo $MOJANG_PROFILE_DATA | jq -r '.id')
    UUID=${MOJANG_UUID:0:8}-${MOJANG_UUID:8:4}-${MOJANG_UUID:12:4}-${MOJANG_UUID:16:4}-${MOJANG_UUID:20:12}
    #Update operators
    if [[ "x${OP_PERMISSION_LEVEL}" != "x" ]]; then
      update_operators $MOJANG_USERNAME $UUID $OP_PERMISSION_LEVEL
    fi
    #Update whitelist too
    if [[ "x${WHITELIST_ENABLE,,}" == "xtrue" ]]; then
      update_whitelist $MOJANG_USERNAME $UUID
    fi
  fi
}

update_operators() {
  OPERATOR_NAME=$1
  OPERATOR_UUID=$2
  OP_PERMISSION_LEVEL=$3
  OPERATOR_INFO="{\"name\": \"${OPERATOR_NAME}\", \"uuid\": \"${OPERATOR_UUID}\", \"level\": \"${OP_PERMISSION_LEVEL}\", \"bypassesPlayerLimit\": true }"
  if [[ $(cat $OPERATORS_FILE | jq --arg UUID "${OPERATOR_UUID}" -r '.[]|select(.uuid == $UUID)' | wc -l) -eq 0 ]]; then
    echo "Adding ${OPERATOR_NAME} ${OPERATOR_UUID} to ${OPERATORS_FILE}"
    jq ". |= . + [${OPERATOR_INFO}]" $OPERATORS_FILE > "${OPERATORS_FILE}.tmp"
    mv "${OPERATORS_FILE}.tmp" $OPERATORS_FILE
  fi
}

update_whitelist() {
  WHITELIST_NAME=$1
  WHITELIST_UUID=$2
  WHITELIST_INFO="{\"name\": \"${WHITELIST_NAME}\", \"uuid\": \"${WHITELIST_UUID}\" }"
  if [[ $(cat $WHITELIST_FILE | jq --arg UUID "${WHITELIST_UUID}" -r '.[]|select(.uuid == $UUID)' | wc -l) -eq 0 ]]; then
    echo "Adding ${WHITELIST_NAME} ${WHITELIST_UUID} to ${WHITELIST_FILE}"
    jq ". |= . + [${WHITELIST_INFO}]" $WHITELIST_FILE > "${WHITELIST_FILE}.tmp"
    mv "${WHITELIST_FILE}.tmp" $WHITELIST_FILE
  fi
}

create_cache_files() {
  #Create copies of ops.json & whitelist.json at init if modes are static
  if [[ "x${OPERATORS_MODE,,}" == "xstatic" ]] && [[ "x${SERVER_INITIALIZED}" == "xfalse" ]] ; then
    cp $OPERATORS_FILE $SERVER_PATH/ops.json.cached
  fi
  if [[ "x${WHITELIST_MODE,,}" == "xstatic" ]] && [[ "x${SERVER_INITIALIZED}" == "xfalse" ]] ; then
    cp $WHITELIST_FILE $SERVER_PATH/whitelist.json.cached
  fi
}