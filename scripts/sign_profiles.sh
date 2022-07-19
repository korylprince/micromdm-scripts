#!/bin/bash
# Signs all the profiles in ../profiles and puts them in OUTPUT/
INPUT=$1
PASSW=$2

for fn in $1/*.mobileconfig; do
        f=$(basename "$fn")
        mdmctl apply profiles -cert signing_cert.p12 -sign -f "$fn" -password $2 -out "$1/signed-$f"
done
