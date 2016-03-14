# docker-compose-old-mac

Older Macs don't compile the docker-compose binary properly and produce the following error when run:

`Illegal instruction: 4`

[Illegal instruction: 4](https://github.com/docker/compose/issues/1885)
[Docker-compose returns null error code (illegal instruction: 4) when installing on older Mac](https://github.com/kalabox/kalabox/issues/901)

This repository contains binaries of versions that were compiled on older Macs that seem to work for all Macs. 
