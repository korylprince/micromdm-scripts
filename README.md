# About

This repo contains useful scripts for managing [MicroMDM](https://github.com/micromdm/micromdm).

**Directory Layout:**

* [/scripts](./scripts)
* [/profiles](./profiles): place any Configuration Profiles you need here
* /signing_cert.p12: Scripts dealing with uploading or installing profiles expect a cert at this path. You can get this with an Apple Developer account. It's the "Developer ID Installer" type of certificate.

`mdmctl` should be installed in `$PATH` and should be configured (`~/.micromdm/servers.json` should exist).
