update_server_properties() {
  echo "Updating server.properties file."
  #ACCEPT_TRANSFERS
  if [[ -n $ACCEPT_TRANSFERS ]]; then
    if [[ "${ACCEPT_TRANSFERS,,}" == "true" ]] || [[ "${ACCEPT_TRANSFERS,,}" == "false" ]]; then
      sed -i "s/accepts-transfers=.*/accepts-transfers=${ACCEPT_TRANSFERS}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for ACCEPT_TRANSFERS!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #ALLOW_FLIGHT
  if [[ -n $ALLOW_FLIGHT ]]; then
    if [[ "${ALLOW_FLIGHT,,}" == "true" ]] || [[ "${ALLOW_FLIGHT,,}" == "false" ]]; then
      sed -i "s/allow-flight=.*/allow-flight=${ALLOW_FLIGHT}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for ALLOW_FLIGHT!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #ALLOW_NETHER
  if [[ -n $ALLOW_NETHER ]]; then
    if [[ "${ALLOW_NETHER,,}" == "true" ]] || [[ "${ALLOW_NETHER,,}" == "false" ]]; then
      sed -i "s/allow-nether=.*/allow-nether=${ALLOW_NETHER}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for ALLOW_NETHER!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #BROADCAST_CONSOLE_TO_OPS
  if [[ -n $BROADCAST_CONSOLE_TO_OPS ]]; then
    if [[ "${BROADCAST_CONSOLE_TO_OPS,,}" == "true" ]] || [[ "${BROADCAST_CONSOLE_TO_OPS,,}" == "false" ]]; then
      sed -i "s/broadcast-console-to-ops=.*/broadcast-console-to-ops=${BROADCAST_CONSOLE_TO_OPS}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for BROADCAST_CONSOLE_TO_OPS!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #BROADCAST_RCON_TO_OPS
  if [[ -n $BROADCAST_RCON_TO_OPS ]]; then
    if [[ "${BROADCAST_RCON_TO_OPS,,}" == "true" ]] || [[ "${BROADCAST_RCON_TO_OPS,,}" == "false" ]]; then
      sed -i "s/broadcast-rcon-to-ops=.*/broadcast-rcon-to-ops=${BROADCAST_RCON_TO_OPS}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for BROADCAST_RCON_TO_OPS!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #DIFFICULTY - Added 1.14 (18w48a)
  if [[ -n $DIFFICULTY ]]; then
    if [[ "${DIFFICULTY,,}" == "peaceful" ]] || [[ "${DIFFICULTY,,}" == "easy" ]] || [[ "${DIFFICULTY,,}" == "normal" ]] || [[ "${DIFFICULTY,,}" == "hard" ]]; then
      sed -i "s/difficulty=.*/difficulty=${DIFFICULTY}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for DIFFICULTY!"
      echo "Options are: 'peaceful', 'easy', 'normal', or 'hard'"
      exit 1
    fi
  fi
  #ENABLE_COMMAND_BLOCK
  if [[ -n $ENABLE_COMMAND_BLOCK ]]; then
    if [[ "${ENABLE_COMMAND_BLOCK,,}" == "true" ]] || [[ "${ENABLE_COMMAND_BLOCK,,}" == "false" ]]; then
      sed -i "s/enable-command-block=.*/enable-command-block=${ENABLE_COMMAND_BLOCK}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for ENABLE_COMMAND_BLOCK!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #ENABLE_JMX_MONITORING
  if [[ -n $ENABLE_JMX_MONITORING ]]; then
    if [[ "${ENABLE_JMX_MONITORING,,}" == "true" ]] || [[ "${ENABLE_JMX_MONITORING,,}" == "false" ]]; then
      sed -i "s/enable-jmx-monitoring=.*/enable-jmx-monitoring=${ENABLE_JMX_MONITORING}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for ENABLE_JMX_MONITORING!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #ENABLE_QUERY
  if [[ -n $ENABLE_QUERY ]]; then
    if [[ "${ENABLE_QUERY,,}" == "true" ]] || [[ "${ENABLE_QUERY,,}" == "false" ]]; then
      sed -i "s/enable-query=.*/enable-query=${ENABLE_QUERY}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for ENABLE_QUERY!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #ENABLE_RCON
  if [[ -n $ENABLE_RCON ]]; then
    if [[ "${ENABLE_RCON,,}" == "true" ]] || [[ "${ENABLE_RCON,,}" == "false" ]]; then
      sed -i "s/enable-rcon=.*/enable-rcon=${ENABLE_RCON}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for ENABLE_RCON!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #ENABLE_STATUS
  if [[ -n $ENABLE_STATUS ]]; then
    if [[ "${ENABLE_STATUS,,}" == "true" ]] || [[ "${ENABLE_STATUS,,}" == "false" ]]; then
      sed -i "s/enable-status=.*/enable-status=${ENABLE_STATUS}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for ENABLE_STATUS!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #ENFORCE_SECURE_PROFILE - Added 1.19 (22w17a)
  if [[ -n $ENFORCE_SECURE_PROFILE ]]; then
    if [[ "${ENFORCE_SECURE_PROFILE,,}" == "true" ]] || [[ "${ENFORCE_SECURE_PROFILE,,}" == "false" ]]; then
      sed -i "s/enforce-secure-profile=.*/enforce-secure-profile=${ENFORCE_SECURE_PROFILE}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for ENFORCE_WHITELIST!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #ENFORCE_WHITELIST
  if [[ -n $ENFORCE_WHITELIST ]]; then
    if [[ "${ENFORCE_WHITELIST,,}" == "true" ]] || [[ "${ENFORCE_WHITELIST,,}" == "false" ]]; then
      sed -i "s/enforce-whitelist=.*/enforce-whitelist=${ENFORCE_WHITELIST}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for ENFORCE_WHITELIST!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #ENTITY_BROADCAST_RANGE_PERCENTAGE
  if [[ -n $ENTITY_BROADCAST_RANGE_PERCENTAGE ]]; then
    if [[ "${ENTITY_BROADCAST_RANGE_PERCENTAGE}" -gt 9 ]] && [[ "${ENTITY_BROADCAST_RANGE_PERCENTAGE}" -lt 1001 ]]; then
      sed -i "s/entity-broadcast-range-percentage=.*/entity-broadcast-range-percentage=${ENTITY_BROADCAST_RANGE_PERCENTAGE}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: ENTITY_BROADCAST_RANGE_PERCENTAGE must be a number between 10-1000!"
      exit 1
    fi
  fi
  #FORCE_GAMEMODE
  if [[ -n $FORCE_GAMEMODE ]]; then
    if [[ "${FORCE_GAMEMODE,,}" == "true" ]] || [[ "${FORCE_GAMEMODE,,}" == "false" ]]; then
      sed -i "s/force-gamemode=.*/force-gamemode=${FORCE_GAMEMODE}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for FORCE_GAMEMODE!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #FUNCTION_PERMISSION_LEVEL
  if [[ -n $FUNCTION_PERMISSION_LEVEL ]]; then
    if [[ "${FUNCTION_PERMISSION_LEVEL}" -gt 0 ]] && [[ "${FUNCTION_PERMISSION_LEVEL}" -lt 5 ]]; then
      sed -i "s/function-permission-level=.*/function-permission-level=${FUNCTION_PERMISSION_LEVEL}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: FUNCTION_PERMISSION_LEVEL must be a number between 1-4!"
      exit 1
    fi
  fi
  #GAME_MODE
  if [[ -n $GAME_MODE ]]; then
    if [[ "${GAME_MODE,,}" == "survival" ]] || [[ "${GAME_MODE,,}" == "creative" ]] || [[ "${GAME_MODE,,}" == "adventure" ]] || [[ "${GAME_MODE,,}" == "spectator" ]]; then
      sed -i "s/gamemode=.*/gamemode=${GAME_MODE}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for GAME_MODE!"
      echo "Options are: 'survival', 'creative', 'adventure', or 'spectator'"
      exit 1
    fi
  fi
  #GENERATE_STRUCTURES
  if [[ -n $GENERATE_STRUCTURES ]]; then
    if [[ "${GENERATE_STRUCTURES,,}" == "true" ]] || [[ "${GENERATE_STRUCTURES,,}" == "false" ]]; then
      sed -i "s/generate-structures=.*/generate-structures=${GENERATE_STRUCTURES}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for GENERATE_STRUCTURES!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #HARDCORE
  if [[ -n $HARDCORE ]]; then
    if [[ "${HARDCORE,,}" == "true" ]] || [[ "${HARDCORE,,}" == "false" ]]; then
      sed -i "s/hardcore=.*/hardcore=${HARDCORE}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for HARDCORE!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #HIDE_ONLINE_PLAYERS - Added 1.18 (21w44a)
  if [[ -n $HIDE_ONLINE_PLAYERS ]]; then
    if [[ "${HIDE_ONLINE_PLAYERS,,}" == "true" ]] || [[ "${HIDE_ONLINE_PLAYERS,,}" == "false" ]]; then
      sed -i "s/hide-online-players=.*/hide-online-players=${HIDE_ONLINE_PLAYERS}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for HIDE_ONLINE_PLAYERS!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #LEVEL_NAME
  if [[ -n $LEVEL_NAME ]]; then
    sed -i "s/level-name=.*/level-name=${LEVEL_NAME}/" "${SERVER_PROPERTIES}"
    #TODO: Add logic to check for legal file names
  fi
  #LEVEL_SEED
  if [[ -n $LEVEL_SEED ]] || [ -f "${DATA_PATH}/seed.txt" ]; then
    #If seed.txt exists, use its value instead of ENV
    if [ -f "${DATA_PATH}/seed.txt" ]; then
      echo "Using seed from existing world's seed.txt file!"
      LEVEL_SEED=$(cat "${DATA_PATH}/seed.txt")
    #If ENV is random then choose one from list
    elif [[ "${LEVEL_SEED,,}" == "random" ]]; then
      echo "Choosing random seed from integrated seeds list."
      LEVEL_SEED=$(sort "${SEEDS_FILE}" -uR | head -n 1)
    fi
    echo "${LEVEL_SEED}" > "${DATA_PATH}/seed.txt"
    sed -i "s/level-seed=.*/level-seed=${LEVEL_SEED}/" "${SERVER_PROPERTIES}"
    #level-seed missing from recent downloads, insert if env var exists
    # shellcheck disable=SC2126
    if [[ $(grep "level-seed" "${SERVER_PROPERTIES}" | wc -l) -eq 0 ]]; then
      # shellcheck disable=SC2086
      echo "level-seed="${LEVEL_SEED^^} >> "${SERVER_PROPERTIES}"
    fi
  fi
  #LEVEL_TYPE
  if [[ -n $LEVEL_TYPE ]]; then
    if [[ "${LEVEL_TYPE,,}" == "normal" ]] || [[ "${LEVEL_TYPE,,}" == "flat" ]] || [[ "${LEVEL_TYPE,,}" == "large_biomes" ]] || [[ "${LEVEL_TYPE,,}" == "amplified" ]] || [[ "${LEVEL_TYPE,,}" == "single_biome_surface" ]]; then
      sed -i "s/level-type=.*/level-type=${LEVEL_TYPE^^}/" "${SERVER_PROPERTIES}"
      #level-type missing from recent downloads, insert if env var exists
      # shellcheck disable=SC2126
      if [[ $(grep "level-type" "${SERVER_PROPERTIES}" | wc -l) -eq 0 ]]; then
        # shellcheck disable=SC2086
        echo "level-type="${LEVEL_TYPE^^} >> "${SERVER_PROPERTIES}"
      fi
    else
      echo "ERROR: Invalid option for LEVEL_TYPE!"
      echo "Options are: 'normal', 'flat', 'large_biomes', 'amplified', or 'single_biome_surface'"
      exit 1
    fi
  fi
  #LOG_IPS - Added 1.20.2	(23w31a)
  if [[ -n $LOG_IPS ]]; then
    if [[ "${LOG_IPS,,}" == "true" ]] || [[ "${LOG_IPS,,}" == "false" ]]; then
      sed -i "s/log-ips=.*/log-ips=${LOG_IPS}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for LOG_IPS!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #MAX_CHAINED_NEIGHBOR_UPDATES - Added 1.19 (22w11a)
  if [[ -n $MAX_CHAINED_NEIGHBOR_UPDATES ]]; then
    sed -i "s/max-chained-neighbor-updates=.*/max-chained-neighbor-updates=${MAX_CHAINED_NEIGHBOR_UPDATES}/" "${SERVER_PROPERTIES}"
  fi
  #MAX_PLAYERS
  if [[ -n $MAX_PLAYERS ]]; then
    if [[ "${MAX_PLAYERS}" =~ ^[0-9]+$ ]]; then
      sed -i "s/max-players=.*/max-players=${MAX_PLAYERS}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: MAX_PLAYERS must be a number!"
      exit 1
    fi
  fi
  #MAX_TICK_TIME
  if [[ -n $MAX_TICK_TIME ]]; then
    sed -i "s/max-tick-time=.*/max-tick-time=${MAX_TICK_TIME}/" "${SERVER_PROPERTIES}"
  fi
  #MAX_WORLD_SIZE
  if [[ -n $MAX_WORLD_SIZE ]]; then
    if [[ "${MAX_WORLD_SIZE}" -gt 0 ]] && [[ "${MAX_WORLD_SIZE}" -lt 29999985 ]]; then
      sed -i "s/max-world-siz=.*/max-world-siz=${MAX_WORLD_SIZE}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: MAX_WORLD_SIZE must be a number between 1-29999984!"
      exit 1
    fi
  fi
  #MOTD
  if [[ -n $MOTD ]]; then
    sed -i "s/motd=.*/motd=${MOTD}/" "${SERVER_PROPERTIES}"
  else
    sed -i "s/motd=.*/motd=${SERVER_NAME}/" "${SERVER_PROPERTIES}"
  fi
  #NETWORK_COMPRESSION_THRESHOLD
  if [[ -n $NETWORK_COMPRESSION_THRESHOLD ]]; then
    sed -i "s/network-compression-threshold=.*/network-compression-threshold=${NETWORK_COMPRESSION_THRESHOLD}/" "${SERVER_PROPERTIES}"
  fi
  #ONLINE_MODE
  if [[ -n $ONLINE_MODE ]]; then
    if [[ "${ONLINE_MODE,,}" == "true" ]] || [[ "${ONLINE_MODE,,}" == "false" ]]; then
      sed -i "s/online-mode=.*/online-mode=${ONLINE_MODE}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for ONLINE_MODE!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #OP_PERMISSION_LEVEL
  if [[ -n $OP_PERMISSION_LEVEL ]]; then
    if [[ "${OP_PERMISSION_LEVEL}" =~ ^[0-4]+$ ]]; then
      sed -i "s/op-permission-level=.*/op-permission-level=${OP_PERMISSION_LEVEL}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: OP_PERMISSION_LEVEL must be zero or a positive number less than 5!"
      exit 1
    fi
  fi
  #PAUSE_WHEN_EMPTY_SECONDS - Added 1.21.2 (24w33a)
  if [[ -n $PAUSE_WHEN_EMPTY_SECONDS ]]; then
    if [[ "${PAUSE_WHEN_EMPTY_SECONDS}" =~ ^[0-9]+$ ]]; then
      sed -i "s/pause-when-empty-seconds=.*/pause-when-empty-seconds=${PAUSE_WHEN_EMPTY_SECONDS}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: PAUSE_WHEN_EMPTY_SECONDS must be a number!"
      exit 1
    fi
  fi
  #PLAYER_IDLE_TIMEOUT
  if [[ -n $PLAYER_IDLE_TIMEOUT ]]; then
    if [[ "${PLAYER_IDLE_TIMEOUT}" =~ ^[0-9]+$ ]]; then
      sed -i "s/player-idle-timeout=.*/player-idle-timeout=${PLAYER_IDLE_TIMEOUT}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: PLAYER_IDLE_TIMEOUT must be zero or a positive number!"
      exit 1
    fi
  fi
  #PREVENT_PROXY_CONNECTIONS
  if [[ -n $PREVENT_PROXY_CONNECTIONS ]]; then
    if [[ "${PREVENT_PROXY_CONNECTIONS,,}" == "true" ]] || [[ "${PREVENT_PROXY_CONNECTIONS,,}" == "false" ]]; then
      sed -i "s/prevent-proxy-connections=.*/prevent-proxy-connections=${PREVENT_PROXY_CONNECTIONS}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for PREVENT_PROXY_CONNECTIONS!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #PVP
  if [[ -n $PVP ]]; then
    if [[ "${PVP,,}" == "true" ]] || [[ "${PVP,,}" == "false" ]]; then
      sed -i "s/pvp=.*/pvp=${PVP}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for PVP!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #QUERY_PORT
  if [[ -n $QUERY_PORT ]]; then
    if [[ "${QUERY_PORT}" -gt 0 ]] && [[ "${QUERY_PORT}" -lt 65536 ]]; then
      sed -i "s/query.port=.*/query.port=${QUERY_PORT}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: QUERY_PORT must be a number between 1-65535!"
      exit 1
    fi
  fi
  #RATE_LIMIT
  if [[ -n $RATE_LIMIT ]]; then
    if [[ "${RATE_LIMIT}" =~ ^[0-9]+$ ]]; then
      sed -i "s/rate-limit=.*/rate-limit=${RATE_LIMIT}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: RATE_LIMIT must be a positive number!"
      exit 1
    fi
  fi
  #RCON_PASSWORD
  if [[ -n $RCON_PASSWORD ]]; then
    sed -i "s/rcon.password=.*/rcon.password=${RCON_PASSWORD}/" "${SERVER_PROPERTIES}"
  fi
  #RCON_PORT
  if [[ -n $RCON_PORT ]]; then
    if [[ "${RCON_PORT}" -gt 0 ]] && [[ "${RCON_PORT}" -lt 65536 ]]; then
      sed -i "s/rcon.port=.*/rcon.port=${RCON_PORT}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: RCON_PORT must be a number between 1-65535!"
      exit 1
    fi
  fi
  #REGION_FILE_COMPRESSION - Added 1.20.5	(24w04a)
  if [[ -n $REGION_FILE_COMPRESSION ]]; then
    if [[ "${REGION_FILE_COMPRESSION,,}" == "deflate" ]] || [[ "${REGION_FILE_COMPRESSION,,}" == "lz4" ]] || [[ "${REGION_FILE_COMPRESSION,,}" == "none" ]]; then
      sed -i "s/region-file-compression=.*/region-file-compression=${REGION_FILE_COMPRESSION}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for REGION_FILE_COMPRESSION!"
      echo "Options are: 'deflate', 'lz4', or 'none'"
      exit 1
    fi
  fi
  #REQUIRE_RESOURCE_PACK
  if [[ -n $REQUIRE_RESOURCE_PACK ]]; then
    if [[ "${REQUIRE_RESOURCE_PACK,,}" == "true" ]] || [[ "${REQUIRE_RESOURCE_PACK,,}" == "false" ]]; then
      sed -i "s/require-resource-pack=.*/require-resource-pack=${REQUIRE_RESOURCE_PACK}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for REQUIRE_RESOURCE_PACK!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #RESOURCE_PACK
  if [[ -n $RESOURCE_PACK ]]; then
    sed -i "s/resource-pack=.*/resource-pack=${RESOURCE_PACK}/" "${SERVER_PROPERTIES}"
  fi
  #RESOURCE_PACK_PROMPT
  if [[ -n $RESOURCE_PACK_PROMPT ]]; then
    sed -i "s/resource-pack-prompt=.*/resource-pack-prompt=${RESOURCE_PACK_PROMPT}/" "${SERVER_PROPERTIES}"
  fi
  #RESOURCE_PACK_SHA1
  if [[ -n $RESOURCE_PACK_SHA1 ]]; then
    sed -i "s/resource-pack-sha1=.*/resource-pack-sha1=${RESOURCE_PACK_SHA1}/" "${SERVER_PROPERTIES}"
  fi
  #SERVER_IP
  if [[ -n $SERVER_IP ]]; then
    sed -i "s/server-ip=.*/server-ip=${SERVER_IP}/" "${SERVER_PROPERTIES}"
  fi
  #SERVER_PORT
  if [[ -n $SERVER_PORT ]]; then
    if [[ "${SERVER_PORT}" -gt 0 ]] && [[ "${SERVER_PORT}" -lt 65536 ]]; then
      sed -i "s/server-port=.*/server-port=${SERVER_PORT}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: SERVER_PORT must be a number between 1-65535!"
      exit 1
    fi
  fi
  #SIMULATION_DISTANCE - Added 1.18 (21w38a)
  if [[ -n $SIMULATION_DISTANCE ]]; then
    if [[ "${SIMULATION_DISTANCE}" -gt 2 ]] && [[ "${SIMULATION_DISTANCE}" -lt 33 ]]; then
      sed -i "s/simulation-distance=.*/simulation-distance=${SIMULATION_DISTANCE}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: SIMULATION_DISTANCE must be a positive number between 3-32!"
      exit 1
    fi
  fi
  #SPAWN_ANIMALS - Removed 1.21.2 (24w33a)
  if [[ -n $SPAWN_ANIMALS ]]; then
    if [[ "${SPAWN_ANIMALS,,}" == "true" ]] || [[ "${SPAWN_ANIMALS,,}" == "false" ]]; then
      sed -i "s/spawn-animals=.*/spawn-animals=${SPAWN_ANIMALS}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for SPAWN_ANIMALS!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #SPAWN_MONSTERS
  if [[ -n $SPAWN_MONSTERS ]]; then
    if [[ "${SPAWN_MONSTERS,,}" == "true" ]] || [[ "${SPAWN_MONSTERS,,}" == "false" ]]; then
      sed -i "s/spawn-monsters=.*/spawn-monsters=${SPAWN_MONSTERS}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for SPAWN_MONSTERS!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #SPAWN_NPCS - Removed 1.21.2 (24w33a)
  if [[ -n $SPAWN_NPCS ]]; then
    if [[ "${SPAWN_NPCS,,}" == "true" ]] || [[ "${SPAWN_NPCS,,}" == "false" ]]; then
      sed -i "s/spawn-npcs=.*/spawn-npcs=${SPAWN_NPCS}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for SPAWN_NPCS!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #SPAWN_PROTECTION
  if [[ -n $SPAWN_PROTECTION ]]; then
    if [[ "${SPAWN_PROTECTION}" =~ ^[0-9]+$ ]]; then
      sed -i "s/spawn-protection=.*/spawn-protection=${SPAWN_PROTECTION}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: SPAWN_PROTECTION must be a positive number!"
      exit 1
    fi
  fi
  #SYNC_CHUNK_WRITES
  if [[ -n $SYNC_CHUNK_WRITES ]]; then
    if [[ "${SYNC_CHUNK_WRITES,,}" == "true" ]] || [[ "${SYNC_CHUNK_WRITES,,}" == "false" ]]; then
      sed -i "s/sync-chunk-writes=.*/sync-chunk-writes=${SYNC_CHUNK_WRITES}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for SYNC_CHUNK_WRITES!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #TEXT_FILTERING_CONFIG
  if [[ -n $TEXT_FILTERING_CONFIG ]]; then
    sed -i "s/text-filtering-config=.*/text-filtering-config=${TEXT_FILTERING_CONFIG}/" "${SERVER_PROPERTIES}"
  fi
  #TEXT_FILTERING_VERSION - Added 1.21.2
  if [[ -n $TEXT_FILTERING_VERSION ]]; then
    if [[ "${TEXT_FILTERING_VERSION}" -eq 0 ]] || [[ "${TEXT_FILTERING_VERSION}" -eq 1 ]]; then
      sed -i "s/text-filtering-version=.*/text-filtering-version=${TEXT_FILTERING_VERSION}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for TEXT_FILTERING_VERSION!"
      echo "Options are: '0' or '1'"
      exit 1
    fi
  fi
  #USE_NATIVE_TRANSPORT
  if [[ -n $USE_NATIVE_TRANSPORT ]]; then
    if [[ "${USE_NATIVE_TRANSPORT,,}" == "true" ]] || [[ "${USE_NATIVE_TRANSPORT,,}" == "false" ]]; then
      sed -i "s/use-native-transport=.*/use-native-transport=${USE_NATIVE_TRANSPORT}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: Invalid option for USE_NATIVE_TRANSPORT!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
  #VIEW_DISTANCE
  if [[ -n $VIEW_DISTANCE ]]; then
    if [[ "${VIEW_DISTANCE}" -gt 2 ]] && [[ "${VIEW_DISTANCE}" -lt 33 ]]; then
      sed -i "s/view-distance=.*/view-distance=${VIEW_DISTANCE}/" "${SERVER_PROPERTIES}"
    else
      echo "ERROR: VIEW_DISTANCE must be a positive number between 3-32!"
      exit 1
    fi
  fi
  #WHITELIST_ENABLE
  if [[ -n $WHITELIST_ENABLE ]]; then
    if [[ "${WHITELIST_ENABLE,,}" == "true" ]] || [[ "${WHITELIST_ENABLE,,}" == "false" ]]; then
      if [[ "${WHITELIST_ENABLE,,}" == "true" ]]; then
        # shellcheck disable=SC2268
        if [[ "x${WHITELIST_USERS}" == "x" ]] && [[ "x${OPERATORS}" == "x" ]]; then
          echo "ERROR: If WHITELIST_ENABLE is true then either WHITELIST_USERS or OPERATORS must not be empty!"
          exit 1
        fi
        sed -i "s/white-list=.*/white-list=${WHITELIST_ENABLE}/" "${SERVER_PROPERTIES}"
      fi
    else
      echo "ERROR: Invalid option for WHITELIST_ENABLE!"
      echo "Options are: 'true' or 'false'"
      exit 1
    fi
  fi
}