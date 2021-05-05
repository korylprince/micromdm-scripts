#!/bin/bash
# Signs and installs the Profile with the given path to Serial

TEMP=$(mktemp -d)
trap 'rm -rf -- "$TEMP"' EXIT

TOKEN=$(jq -r .servers.production.api_token ~/.micromdm/servers.json)
SERVER=$(jq -r .servers.production.server_url ~/.micromdm/servers.json)
SERIAL="$1"
PROFILE="$2"

udid=$(jq -n --arg serial "$SERIAL" \
'.page = 0 | .per_page = 0 | .filter_udid = null | .filter_serial = [$serial]' | \
curl $CURL_OPTS -s -X POST -u "micromdm:$TOKEN" "$SERVER/v1/devices" -d@- | \
jq -r ".devices[0].udid"
)

fn="$PROFILE"
f=$(basename "$fn")

echo "Processing $f"
mdmctl apply profiles -cert ../signing_cert.p12 -sign -f "$fn" -out "$TEMP/$f"
cat "$TEMP/$f" | openssl base64 -A > "$TEMP/$f.b64"
jq -n --arg request_type "InstallProfile" --arg udid "$udid" --rawfile payload "$TEMP/$f.b64" \
'.udid = $udid | .payload = $payload | .request_type = $request_type' | \
curl $CURL_OPTS -u "micromdm:$TOKEN" "$SERVER/v1/commands" -d@-
