#!/bin/bash
# Issues InstallApplication command with the Manfest to Serial

TOKEN=$(jq -r .servers.production.api_token ~/.micromdm/servers.json)
SERVER=$(jq -r .servers.production.server_url ~/.micromdm/servers.json)
SERIAL="$1"
MANIFEST="$2"

udid=$(jq -n --arg serial "$SERIAL" \
'.page = 0 | .per_page = 0 | .filter_udid = null | .filter_serial = [$serial]' | \
curl $CURL_OPTS -s -X POST -u "micromdm:$TOKEN" "$SERVER/v1/devices" -d@- | \
jq -r ".devices[0].udid"
)

jq -n --arg request_type "InstallApplication" --arg udid "$udid" --arg manifest_url "$MANIFEST" \
'.udid = $udid | .manifest_url = $manifest_url | .request_type = $request_type' | \
curl $CURL_OPTS -u "micromdm:$TOKEN" "$SERVER/v1/commands" -d@-
