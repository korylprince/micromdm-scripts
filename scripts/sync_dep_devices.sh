#!/bin/bash
# Forces a DEP sync

TOKEN=$(jq -r .servers.production.api_token ~/.micromdm/servers.json)
SERVER=$(jq -r .servers.production.server_url ~/.micromdm/servers.json)

curl $CURL_OPTS -u "micromdm:$TOKEN" -X POST "$SERVER/v1/dep/syncnow"
