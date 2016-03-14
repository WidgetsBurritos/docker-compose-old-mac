#!/bin/sh
#Simple script that forces a load of all active versions.

RESULTS=($(curl -s https://api.github.com/repos/docker/compose/tags  | jsawk -a 'var ret = ""; for(i=0; i<this.length; i++) { ret += this[i].name + "\n" }; return ret;'))
for i in "${RESULTS[@]}"
do
	:
	./auto_compose_build.sh ${i}
done

