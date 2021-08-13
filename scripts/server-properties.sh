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
    if [[ "x${GAME_MODE,,}" == "xsurvival" ]] || [[ "x${GAME_MODE,,}" == "xcreative" ]] || [[ "x${GAME_MODE,,}" == "xadventure" ]] || [[ "x${GAME_MODE,,}" == "xspectator" ]]; then
      sed -i "s/gamemode=.*/gamemode=${GAME_MODE}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for GAME_MODE!"
      echo "Options are: 'survival', 'creative', 'adventure', or 'spectator'"
      exit 1
    fi
  fi
  #GENERATE_STRUCTURES
  if [[ "x${GENERATE_STRUCTURES}" != "x" ]]; then
    if [[ "x${GENERATE_STRUCTURES,,}" == "xtrue" ]] || [[ "x${GENERATE_STRUCTURES,,}" == "xfalse" ]]; then
      sed -i "s/generate-structures=.*/generate-structures=${GENERATE_STRUCTURES}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for GENERATE_STRUCTURES!"
      echo "Options are: 'true' or 'false'"
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
    if [[ "x${LEVEL_TYPE,,}" == "xdefault" ]] || [[ "x${LEVEL_TYPE,,}" == "xflat" ]] || [[ "x${LEVEL_TYPE,,}" == "xlargebiomes" ]] || [[ "x${LEVEL_TYPE,,}" == "xamplified" ]]; then
      sed -i "s/level-type=.*/level-type=${LEVEL_TYPE^^}/" $SERVER_PROPERTIES
      #level-type missing from recent downloads, insert if env var exists
      if [[ $(cat $SERVER_PROPERTIES | grep "level-type" | wc -l) -eq 0 ]]; then
        echo "level-type="${LEVEL_TYPE^^} >> $SERVER_PROPERTIES
      fi
    else
      echo "ERROR: Invalid option for LEVEL_TYPE!"
      echo "Options are: 'default', 'flat', 'largebiomes', or 'amplified'"
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
  #MAX_TICK_TIME
  if [[ "x${MAX_TICK_TIME}" != "x" ]]; then
    sed -i "s/max-tick-time=.*/max-tick-time=${MAX_TICK_TIME}/" $SERVER_PROPERTIES
  fi
  #MAX_WORLD_SIZE
  if [[ "x${MAX_WORLD_SIZE}" != "x" ]]; then
    if [[ "${MAX_WORLD_SIZE}" -gt 0 ]] && [[ "${MAX_WORLD_SIZE}" -lt 29999985 ]]; then
      sed -i "s/max-world-siz=.*/max-world-siz=${MAX_WORLD_SIZE}/" $SERVER_PROPERTIES
    else
      echo "ERROR: MAX_WORLD_SIZE must be a number between 1-29999984!"
      exit 1
    fi
  fi
  #MOTD
  if [[ "x${MOTD}" != "x" ]]; then
    sed -i "s/motd=.*/motd=${MOTD}/" $SERVER_PROPERTIES
  else
    sed -i "s/motd=.*/motd=${SERVER_NAME}/" $SERVER_PROPERTIES
  fi
  #NETWORK_COMPRESSION_THRESHOLD
  if [[ "x${NETWORK_COMPRESSION_THRESHOLD}" != "x" ]]; then
    sed -i "s/network-compression-threshold=.*/network-compression-threshold=${NETWORK_COMPRESSION_THRESHOLD}/" $SERVER_PROPERTIES
  fi
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
  #OP_PERMISSION_LEVEL
  if [[ "x${OP_PERMISSION_LEVEL}" != "x" ]]; then
    if [[ "${OP_PERMISSION_LEVEL}" =~ ^[0-4]+$ ]]; then
      sed -i "s/op-permission-level=.*/op-permission-level=${OP_PERMISSION_LEVEL}/" $SERVER_PROPERTIES
    else
      echo "ERROR: OP_PERMISSION_LEVEL must be zero or a positive number less than 5!"
      exit 1
    fi
  fi
  #PLAYER_IDLE_TIMEOUT
  if [[ "x${PLAYER_IDLE_TIMEOUT}" != "x" ]]; then
    if [[ "${PLAYER_IDLE_TIMEOUT}" =~ ^[0-9]+$ ]]; then
      sed -i "s/player-idle-timeout=.*/player-idle-timeout=${PLAYER_IDLE_TIMEOUT}/" $SERVER_PROPERTIES
    else
      echo "ERROR: PLAYER_IDLE_TIMEOUT must be zero or a positive number!"
      exit 1
    fi
  fi
  #PREVENT_PROXY_CONNECTIONS
  if [[ "x${PREVENT_PROXY_CONNECTIONS}" != "x" ]]; then
    if [[ "x${PREVENT_PROXY_CONNECTIONS,,}" == "xtrue" ]] || [[ "x${PREVENT_PROXY_CONNECTIONS,,}" == "xfalse" ]]; then
      sed -i "s/prevent-proxy-connections=.*/prevent-proxy-connections=${PREVENT_PROXY_CONNECTIONS}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for PREVENT_PROXY_CONNECTIONS!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #PVP
  if [[ "x${PVP}" != "x" ]]; then
    if [[ "x${PVP,,}" == "xtrue" ]] || [[ "x${PVP,,}" == "xfalse" ]]; then
      sed -i "s/pvp=.*/pvp=${PVP}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for PVP!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #QUERY_PORT
  if [[ "x${QUERY_PORT}" != "x" ]]; then
    if [[ "${QUERY_PORT}" -gt 0 ]] && [[ "${QUERY_PORT}" -lt 65536 ]]; then
      sed -i "s/query.port=.*/query.port=${QUERY_PORT}/" $SERVER_PROPERTIES
    else
      echo "ERROR: QUERY_PORT must be a number between 1-65535!"
      exit 1
    fi
  fi
  #RATE_LIMIT
  if [[ "x${RATE_LIMIT}" != "x" ]]; then
    if [[ "${RATE_LIMIT}" =~ ^[0-9]+$ ]]; then
      sed -i "s/rate-limit=.*/rate-limit=${RATE_LIMIT}/" $SERVER_PROPERTIES
    else
      echo "ERROR: RATE_LIMIT must be a positive number!"
      exit 1
    fi
  fi
  #RCON_PASSWORD
  if [[ "x${RCON_PASSWORD}" != "x" ]]; then
    sed -i "s/rcon.password=.*/rcon.password=${RCON_PASSWORD}/" $SERVER_PROPERTIES
  fi
  #RCON_PORT
  if [[ "x${RCON_PORT}" != "x" ]]; then
    if [[ "${RCON_PORT}" -gt 0 ]] && [[ "${RCON_PORT}" -lt 65536 ]]; then
      sed -i "s/rcon.port=.*/rcon.port=${RCON_PORT}/" $SERVER_PROPERTIES
    else
      echo "ERROR: RCON_PORT must be a number between 1-65535!"
      exit 1
    fi
  fi
  #REQUIRE_RESOURCE_PACK
  if [[ "x${REQUIRE_RESOURCE_PACK}" != "x" ]]; then
    if [[ "x${REQUIRE_RESOURCE_PACK,,}" == "xtrue" ]] || [[ "x${REQUIRE_RESOURCE_PACK,,}" == "xfalse" ]]; then
      sed -i "s/require-resource-pack=.*/require-resource-pack=${REQUIRE_RESOURCE_PACK}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for REQUIRE_RESOURCE_PACK!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #RESOURCE_PACK
  if [[ "x${RESOURCE_PACK}" != "x" ]]; then
    sed -i "s/resource-pack=.*/resource-pack=${RESOURCE_PACK}/" $SERVER_PROPERTIES
  fi
  #RESOURCE_PACK_PROMPT
  if [[ "x${RESOURCE_PACK_PROMPT}" != "x" ]]; then
    sed -i "s/resource-pack-prompt=.*/resource-pack-prompt=${RESOURCE_PACK_PROMPT}/" $SERVER_PROPERTIES
  fi
  #RESOURCE_PACK_SHA1
  if [[ "x${RESOURCE_PACK_SHA1}" != "x" ]]; then
    sed -i "s/resource-pack-sha1=.*/resource-pack-sha1=${RESOURCE_PACK_SHA1}/" $SERVER_PROPERTIES
  fi
  #SERVER_PORT
  if [[ "x${SERVER_PORT}" != "x" ]]; then
    if [[ "${SERVER_PORT}" -gt 0 ]] && [[ "${SERVER_PORT}" -lt 65536 ]]; then
      sed -i "s/server-port=.*/server-port=${SERVER_PORT}/" $SERVER_PROPERTIES
    else
      echo "ERROR: SERVER_PORT must be a number between 1-65535!"
      exit 1
    fi
  fi
  #SNOOPER_ENABLED
  if [[ "x${SNOOPER_ENABLED}" != "x" ]]; then
    if [[ "x${SNOOPER_ENABLED,,}" == "xtrue" ]] || [[ "x${SNOOPER_ENABLED,,}" == "xfalse" ]]; then
      sed -i "s/snooper-enabled=.*/snooper-enabled=${SNOOPER_ENABLED}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for SNOOPER_ENABLED!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #SPAWN_ANIMALS
  if [[ "x${SPAWN_ANIMALS}" != "x" ]]; then
    if [[ "x${SPAWN_ANIMALS,,}" == "xtrue" ]] || [[ "x${SPAWN_ANIMALS,,}" == "xfalse" ]]; then
      sed -i "s/spawn-animals=.*/spawn-animals=${SPAWN_ANIMALS}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for SPAWN_ANIMALS!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #SPAWN_MONSTERS
  if [[ "x${SPAWN_MONSTERS}" != "x" ]]; then
    if [[ "x${SPAWN_MONSTERS,,}" == "xtrue" ]] || [[ "x${SPAWN_MONSTERS,,}" == "xfalse" ]]; then
      sed -i "s/spawn-monsters=.*/spawn-monsters=${SPAWN_MONSTERS}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for SPAWN_MONSTERS!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #SPAWN_NPCS
  if [[ "x${SPAWN_NPCS}" != "x" ]]; then
    if [[ "x${SPAWN_NPCS,,}" == "xtrue" ]] || [[ "x${SPAWN_NPCS,,}" == "xfalse" ]]; then
      sed -i "s/spawn-npcs=.*/spawn-npcs=${SPAWN_NPCS}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for SPAWN_NPCS!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #SPAWN_PROTECTION
  if [[ "x${SPAWN_PROTECTION}" != "x" ]]; then
    if [[ "${SPAWN_PROTECTION}" =~ ^[0-9]+$ ]]; then
      sed -i "s/spawn-protection=.*/spawn-protection=${SPAWN_PROTECTION}/" $SERVER_PROPERTIES
    else
      echo "ERROR: SPAWN_PROTECTION must be a positive number!"
      exit 1
    fi
  fi
  #SYNC_CHUNK_WRITES
  if [[ "x${SYNC_CHUNK_WRITES}" != "x" ]]; then
    if [[ "x${SYNC_CHUNK_WRITES,,}" == "xtrue" ]] || [[ "x${SYNC_CHUNK_WRITES,,}" == "xfalse" ]]; then
      sed -i "s/sync-chunk-writes=.*/sync-chunk-writes=${SYNC_CHUNK_WRITES}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for SYNC_CHUNK_WRITES!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #TEXT_FILTERING_CONFIG
  if [[ "x${TEXT_FILTERING_CONFIG}" != "x" ]]; then
    sed -i "s/text-filtering-config=.*/text-filtering-config=${TEXT_FILTERING_CONFIG}/" $SERVER_PROPERTIES
  fi
  #USE_NATIVE_TRANSPORT
  if [[ "x${USE_NATIVE_TRANSPORT}" != "x" ]]; then
    if [[ "x${USE_NATIVE_TRANSPORT,,}" == "xtrue" ]] || [[ "x${USE_NATIVE_TRANSPORT,,}" == "xfalse" ]]; then
      sed -i "s/use-native-transport=.*/use-native-transport=${USE_NATIVE_TRANSPORT}/" $SERVER_PROPERTIES
    else
      echo "ERROR: Invalid option for USE_NATIVE_TRANSPORT!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #VIEW_DISTANCE
  if [[ "x${VIEW_DISTANCE}" != "x" ]]; then
    if [[ "${VIEW_DISTANCE}" -gt 2 ]] && [[ "${VIEW_DISTANCE}" -lt 33 ]]; then
      sed -i "s/view-distance=.*/view-distance=${VIEW_DISTANCE}/" $SERVER_PROPERTIES
    else
      echo "ERROR: VIEW_DISTANCE must be a positive number between 3-32!"
      exit 1
    fi
  fi
  #WHITELIST_ENABLE
  if [[ "x${WHITELIST_ENABLE}" != "x" ]]; then
    if [[ "x${WHITELIST_ENABLE,,}" == "xtrue" ]] || [[ "x${WHITELIST_ENABLE,,}" == "xfalse" ]]; then
      if [[ "x${WHITELIST_ENABLE,,}" == "xtrue" ]]; then
        if [[ "x${WHITELIST_USERS}" == "x" ]] && [[ "x${OPERATORS}" == "x" ]]; then
          echo "ERROR: If WHITELIST_ENABLE is true then either WHITELIST_USERS or OPERATORS must not be empty!"
          exit 1
        fi
        sed -i "s/white-list=.*/white-list=${WHITELIST_ENABLE}/" $SERVER_PROPERTIES
      fi
    else
      echo "ERROR: Invalid option for WHITELIST_ENABLE!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
}