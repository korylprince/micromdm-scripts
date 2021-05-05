#!/bin/bash
# Signs all the profiles in ../profiles and puts them in OUTPUT/

OUTPUT=$1

for fn in ../profiles/*.mobileconfig; do
    f=$(basename "$fn")
    mdmctl apply profiles -cert ../signing_cert.p12 -sign -f "$fn" -out "$1/$f"
done
