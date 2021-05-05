#!/bin/bash
# Signs and installs the Profile with the given path to all enrolled devices

TEMP=$(mktemp -d)
trap 'rm -rf -- "$TEMP"' EXIT

TOKEN=$(jq -r .servers.production.api_token ~/.micromdm/servers.json)
SERVER=$(jq -r .servers.production.server_url ~/.micromdm/servers.json)
PROFILE_PATH="$1"

device_ids=( $(curl $CURL_OPTS -X POST --data-binary {} -s -u "micromdm:$TOKEN" "$SERVER/v1/devices" | \
    jq -r '.devices[] | select( .enrollment_status ).udid') )

for UUID in ${device_ids[@]}; do
    fn="$PROFILE_PATH"
    f=$(basename "$fn")
    echo "Processing $f for $UUID"
    mdmctl apply profiles -cert ../signing_cert.p12 -sign -f "$fn" -out "$TEMP/$f"
    cat "$TEMP/$f" | openssl base64 -A > "$TEMP/$f.b64"
    jq -n --arg request_type "InstallProfile" --arg udid "$UUID" --rawfile payload "$TEMP/$f.b64" \
    '.udid = $udid | .payload = $payload | .request_type = $request_type' | \
    curl $CURL_OPTS -u "micromdm:$TOKEN" "$SERVER/v1/commands" -d@-
done
