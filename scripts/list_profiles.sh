#!/bin/bash
# Issues a ProfileList command to Serial. For use with webhook

TOKEN=$(jq -r .servers.production.api_token ~/.micromdm/servers.json)
SERVER=$(jq -r .servers.production.server_url ~/.micromdm/servers.json)
SERIAL="$1"

udid=$(jq -n --arg serial "$SERIAL" \
'.page = 0 | .per_page = 0 | .filter_udid = null | .filter_serial = [$serial]' | \
curl $CURL_OPTS -s -X POST -u "micromdm:$TOKEN" "$SERVER/v1/devices" -d@- | \
jq -r ".devices[0].udid"
)

jq -n --arg request_type "ProfileList" --arg udid "$udid" \
'.udid = $udid | .request_type = $request_type' | \
curl $CURL_OPTS -u "micromdm:$TOKEN" "$SERVER/v1/commands" -d@-
