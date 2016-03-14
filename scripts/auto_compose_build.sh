
# Navigate to our source repo#!/bin/bash

SRC_REPO="/Users/davids/git/compose"
DEST_REPO="/Users/davids/git/docker-compose-old-mac"
DEST_FOLDER="${DEST_REPO}/bin"
DCOM_FOLDER="/Users/davids/.docker-compose-old-mac"
LOG_FILE="/Users/davids/git/compose.log"
LASTRUN_FILE="${DCOM_FOLDER}/lastrun"

# Make DCOM folder if it doesn't already exist
mkdir -p DCOM_FOLDER

# Navigate to our source repo
cd ${SRC_REPO}

# Retrieve the latest version of the code and switch to the latest branch.
git fetch --all &>/dev/null
git reset --hard &>/dev/null
if [ "$1" == "" ];
then
	VERSION=$(curl -s https://api.github.com/repos/docker/compose/tags | jsawk -a 'return this[0].name;')
else
	VERSION=$1
fi
git checkout ${VERSION} &>/dev/null


# Build our binary
${SRC_REPO}/script/build-osx &>/dev/null
DOCKER_COMPOSE_VERSION=$(${SRC_REPO}/dist/docker-compose-Darwin-x86_64 version | grep docker-compose | perl -p -e 's/docker-compose version ([0-9\.]+), build ([a-zA-Z0-9]+)/$1_build_$2/g')
VERSION_FILE="${DCOM_FOLDER}/${DOCKER_COMPOSE_VERSION}"
if [ ! -f ${VERSION_FILE} ]; 
then
	# Upload to github repository
	DEST_FILE="${DEST_FOLDER}/docker-compose-Darwin-x86_64-${DOCKER_COMPOSE_VERSION}"
	DEST_LATEST_FILE="${DEST_FOLDER}/docker-compose-Darwin-x86_64"
	SRC_FILE="${SRC_REPO}/dist/docker-compose-Darwin-x86_64"
	cp ${SRC_FILE} ${DEST_FILE} &>/dev/null
	git add ${DEST_FILE}
	git add ${DEST_LATEST_FILE}
	git commit -C "Added ${DOCKER_COMPOSE_VERSION}"	
	git push
	touch ${VERSION_FILE}
	echo "${DOCKER_COMPOSE_VERSION} has been uploaded to github"
else
	echo "${DOCKER_COMPOSE_VERSION} is already on github."
fi

touch ${LASTRUN_FILE}

