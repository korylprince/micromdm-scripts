#!/bin/bash
# Unassigns any DEP profile from the given Serial

TOKEN=$(jq -r .servers.production.api_token ~/.micromdm/servers.json)
SERVER=$(jq -r .servers.production.server_url ~/.micromdm/servers.json)
SERIAL="$1"

jq -n --arg serial "$SERIAL" \
'.serials = [$serial]' | \
curl $CURL_OPTS -X DELETE -u "micromdm:$TOKEN" "$SERVER/v1/dep/profiles" -d@-
