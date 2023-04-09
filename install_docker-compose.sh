#!/usr/bin/env bash

# Check to see if Docker Compose is installed on the system, if it isn't
# install it, if its already present on the system, notify the user and exit.
# This script will also install the latest version of docker-compose over an
# existing version of docker-compose.

# Works Cited [COMPOSE_VERSION]: Thank you Roberto Rodriguez (https://github.com/Cyb3rWard0g)
INSTALL_DIR=/usr/local/bin
COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)

install_dc() {

    sudo curl -SL https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` \
    -o $INSTALL_DIR/docker-compose

    echo "Docker Compose successfully downloaded to: $INSTALL_DIR"

    sudo chmod 755 $INSTALL_DIR/docker-compose
    sudo ln -sf $INSTALL_DIR/docker-compose /usr/bin/docker-compose

    echo "Docker Compose successfully linked to: /usr/bin/docker-compose"
    echo "`docker-compose version` has been successfully installed on this system."
}


docker_compose_install() {

    Color_Off='\033[0m'
    Green='\033[0;32m'

    if [ ! $(command -v docker-compose) ]; then

        echo -e "Docker Compose is NOT installed on: $(hostname)"
        echo -e "$Green Installing docker-compose -> $COMPOSE_VERSION. $Color_Off"
        
        install_dc
        exit
    fi

    DC_LOC=`command -v docker-compose`
    DC_CURVER=`docker-compose version | awk '{ print $4 }'`

    if [ -f "$DC_LOC" ] && [ "$COMPOSE_VERSION" = "$DC_CURVER" ]; then
        echo -e "`docker-compose version` exists and is the most current version. Exiting."
        exit
    fi

    if [ "$COMPOSE_VERSION" != "$DC_CURVER" ]; then
        echo -e "$Green Installing a newer version $COMPOSE_VERSION of docker-compose..$Color_Off"
        sudo rm -rf $DC_LOC
        
        install_dc
        exit
    fi
}

docker_compose_install
