# Docker Compose Binaries for Older Macs. 

## docker-compose 1.7.0-rc1 Update

Good News! 
[The issue this repository was built to correct has apparently been corrected as of docker-compose 1.7.0-rc1](https://github.com/docker/compose/issues/271#issuecomment-201203732)

This repository will remains up for a while for anyone needing binaries of any 1.6 versions, but this should no longer be an issue moving forward. 

## Original Instructions

Older Macs don't compile the `docker-compose` binary properly and produce the following error when run:

`Illegal instruction: 4`

See these threads for futher details:
- [Illegal instruction: 4](https://github.com/docker/compose/issues/1885)
- [Docker-compose returns null error code (illegal instruction: 4) when installing on older Mac](https://github.com/kalabox/kalabox/issues/901)

This repository contains binaries of versions that were compiled on an older Mac, starting with 1.5.2, that seem to work for both old and new Macs.

A copy of the latest version of the docker-compose binary is always located at:

`bin/docker-compose-Darwin-x86_64`

NOTE: Automation script requires [jsawk](https://www.github.com/micha/jsawk)

