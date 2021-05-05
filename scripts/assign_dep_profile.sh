#!/bin/bash
# Assigns the DEP UUID to the Serial

TOKEN=$(jq -r .servers.production.api_token ~/.micromdm/servers.json)
SERVER=$(jq -r .servers.production.server_url ~/.micromdm/servers.json)
SERIAL="$1"
DEP_ID="$2"

jq -n --arg id "$DEP_ID" --arg serial "$SERIAL" \
'.id = $id | .serials = [$serial]' | \
curl $CURL_OPTS -X POST -u "micromdm:$TOKEN" "$SERVER/v1/dep/assign" -d@-
