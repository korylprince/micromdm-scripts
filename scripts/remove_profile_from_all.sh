#!/bin/bash
# Removes the profile by its PayloadIdentifier from all enrolled devices

TOKEN=$(jq -r .servers.production.api_token ~/.micromdm/servers.json)
SERVER=$(jq -r .servers.production.server_url ~/.micromdm/servers.json)
IDENTIFIER="$1"

device_ids=( $(curl $CURL_OPTS -X POST --data-binary {} -s -u "micromdm:$TOKEN" "$SERVER/v1/devices" | \
    jq -r '.devices[] | select( .enrollment_status ).udid') )

for UUID in ${device_ids[@]}; do
    jq -n --arg request_type "RemoveProfile" --arg udid "$UUID" --arg identifier "$IDENTIFIER" \
    '.udid = $udid | .identifier = $identifier | .request_type = $request_type' | \
    curl $CURL_OPTS -u "micromdm:$TOKEN" "$SERVER/v1/commands" -d@-
done
