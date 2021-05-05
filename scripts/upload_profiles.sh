#!/bin/bash
# Signs and uploads all the profiles in ../profiles to micromdm

for fn in ../profiles/*.mobileconfig; do
    mdmctl apply profiles -cert ../signing_cert.p12 -sign -f "$fn"
done
