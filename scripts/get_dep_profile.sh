#!/bin/bash
# Returns DEP information about the Serial

TOKEN=$(jq -r .servers.production.api_token ~/.micromdm/servers.json)
SERVER=$(jq -r .servers.production.server_url ~/.micromdm/servers.json)
SERIAL="$1"

jq -n --arg id "$DEP_ID" --arg serial "$SERIAL" \
'.serials = [$serial]' | \
curl $CURL_OPTS -X POST -u "micromdm:$TOKEN" "$SERVER/v1/dep/devices" -d@-
