#!/bin/bash
# Pulls from the docker/compose github repository, builds the docker-compose binary, and pushes it to the WidgetsBurritos/docker-compose-old-mac respository. 

# Initialize our folder/file paths.
REPO_DIR="${HOME}/git/"
SRC_REPO="${REPO_DIR}/compose"
DEST_REPO="${REPO_DIR}/docker-compose-old-mac"
DEST_FOLDER="${DEST_REPO}/bin"
DCOM_FOLDER="${REPO_DIR}/.docker-compose-old-mac"
LASTRUN_FILE="${DCOM_FOLDER}/lastrun"

# Make DCOM folder if it doesn't already exist
mkdir -p ${DCOM_FOLDER}

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
DOCKER_COMPOSE_VERSION=$(${SRC_REPO}/dist/docker-compose-Darwin-x86_64 version | grep docker-compose | perl -p -e 's/docker-compose version (.+), build ([a-zA-Z0-9]+)/$1_build_$2/g')
VERSION_FILE="${DCOM_FOLDER}/${DOCKER_COMPOSE_VERSION}"
if [ ! -f ${VERSION_FILE} ]; 
then
	# Establish our src file.
	SRC_FILE="${SRC_REPO}/dist/docker-compose-Darwin-x86_64"

	# Switch into our destination repo. 
	cd ${DEST_REPO}

	# Establish and copy our destination file.
	DEST_FILE="${DEST_FOLDER}/docker-compose-Darwin-x86_64-${DOCKER_COMPOSE_VERSION}"
	cp ${SRC_FILE} ${DEST_FILE} &>/dev/null
	git add ${DEST_FILE}

	# If we're not trying to obtain a specific version via the command-line, then upload the latest version without the version/build info.
	if [ "$1" == "" ];
	then
		DEST_LATEST_FILE="${DEST_FOLDER}/docker-compose-Darwin-x86_64"
		cp ${SRC_FILE} ${DEST_LATEST_FILE} &>/dev/null
		git add ${DEST_LATEST_FILE}
	fi

	git commit -m "Added ${DOCKER_COMPOSE_VERSION}"	
	git push
	touch ${VERSION_FILE}
	echo "${DOCKER_COMPOSE_VERSION} has been uploaded to github"
else
	echo "${DOCKER_COMPOSE_VERSION} is already on github."
fi

touch ${LASTRUN_FILE}

