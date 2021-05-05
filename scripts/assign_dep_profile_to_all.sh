#!/bin/bash
# Assigns the DEP UUID to all DEP devices

TOKEN=$(jq -r .servers.production.api_token ~/.micromdm/servers.json)
SERVER=$(jq -r .servers.production.server_url ~/.micromdm/servers.json)
DEP_ID="$1"

serials=( $(curl $CURL_OPTS -X POST --data-binary {} -s -u "micromdm:$TOKEN" "$SERVER/v1/devices" | \
    jq -r '.devices[] | select( .dep_profile_status != "" ).serial_number') )

for serial in ${serials[@]}; do
    jq -n --arg id "$DEP_ID" --arg serial "$serial" \
    '.id = $id | .serials = [$serial]' | \
    curl $CURL_OPTS -X POST -u "micromdm:$TOKEN" "$SERVER/v1/dep/assign" -d@-
done
