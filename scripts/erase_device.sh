#!/bin/bash
# Erases device with Serial. Must edit below

TOKEN=$(jq -r .servers.production.api_token ~/.micromdm/servers.json)
SERVER=$(jq -r .servers.production.server_url ~/.micromdm/servers.json)
SERIAL="$1"

echo "remove the exit to use this script"
exit 0

# you may need to set this to to an actual pin depending on the device model
PIN=""

udid=$(jq -n --arg serial "$SERIAL" \
'.page = 0 | .per_page = 0 | .filter_udid = null | .filter_serial = [$serial]' | \
curl $CURL_OPTS -s -X POST -u "micromdm:$TOKEN" "$SERVER/v1/devices" -d@- | \
jq -r ".devices[0].udid"
)

jq -n --arg request_type "EraseDevice" --arg udid "$udid" --arg pin "$PIN" \
'.udid = $udid | .request_type = $request_type | .pin = $pin' | \
curl $CURL_OPTS -u "micromdm:$TOKEN" "$SERVER/v1/commands" -d@-
