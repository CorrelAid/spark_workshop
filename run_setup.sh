#!/bin/bash
# Detect the operating system
OS=$(uname -s)
# Define the image name
IMAGE_NAME="jupyter/pyspark-notebook"
CONTAINER_NAME_OR_ID="pyspark_workshop"
SCRIPT_DIR=$(pwd -W)
SRC_DIR_SRC=$SCRIPT_DIR/src
SRC_DIR_DATA=$SCRIPT_DIR/data

docker_container_creation () {
    docker run --rm -p 10001:8888 \
    -v $SRC_DIR_SRC:/home/jovyan/src \
    -v $SRC_DIR_DATA:/home/jovyan/data \
    --name "$1" \
    "$2"
}

#-v "$SCRIPT_DIR/src:/mnt/src" \
# Check if Docker is installed
if command -v docker &> /dev/null; then
    echo "Docker is installed"

    # Check if the docker image exists
    if docker images | grep -q $IMAGE_NAME; then
        echo "$IMAGE_NAME has been pulled. Docker container will be newly setup."
        
        # Remove the existing container if it still exists
        if docker ps -a | grep "$CONTAINER_NAME_OR_ID"; then
            container_id=$(docker ps -aqf "name=pyspark_workshop" -a)
            docker stop "$CONTAINER_NAME_OR_ID"
            docker rm -f $container_id
        fi
        
        # Create the new container
        docker_container_creation "$CONTAINER_NAME_OR_ID" "$IMAGE_NAME"
    else
        echo "$IMAGE_NAME has not been pulled. Image will be pulled and Container $CONTAINER_NAME_OR_ID will be set up"
        
        docker pull "$IMAGE_NAME"
        docker_container_creation "$CONTAINER_NAME_OR_ID" "$IMAGE_NAME"
    fi
    
# if docker is not installed the corresponding docker executable will be installed for the corresponding operating system.
else
    echo "Docker is not installed. Please install Docker."
    # Check if the operating system is macOS
    if [[ "$OS" =~ Darwin ]]; then
        echo "macOS detected"
        curl -o docker.dmg https://desktop.docker.com/mac/main/arm64/Docker.dmg?utm_source=docker&utm_medium=webreferral&utm_campaign=dd-smartbutton&utm_location=module
        echo "docker downloaded"
        hdiutil mount docker.dmg  # Mount the disk image
        # Optionally, copy the application to the Applications folder
        cp -R /Volumes/Application.app /Applications/
    # Check if the operating system is Linux
    elif [[ "$OS" =~ Linux ]]; then
        echo "Linux detected"
        curl -o docker.deb https://docs.docker.com/desktop/linux/install/
        echo "docker downloaded"
        sudo dpkg -i docker.deb
    # Check if the operating system is Windows
    elif [[ "$OS" =~ MINGW64_NT ]]; then
        echo "Windows detected"
        # Run PowerShell command as administrator
        powershell -Command "Start-Process wsl -ArgumentList '--install' -Verb RunAs"
        # Attempt to update WSL to version 2 as it is the recommended one. 
        if wsl.exe --update &> /dev/null; then
            echo "WSL 2 is installed."
        else
            echo "WSL 2 is not installed or an error occurred. Please install manually with the command: wsl.exe --update"
            # Here you can handle the case where WSL 2 is not installed or an error occurred
        fi
        echo "A WSL (Windos Subsystem for Linux) has been downloaded. Please double-click the downloaded installer to start the wsl. You need to set a Username and Password."

        #check if wsl2 is installed as it is needed to work with docker
        curl -o docker.exe https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe?utm_source=docker&utm_medium=webreferral&utm_campaign=dd-smartbutton&utm_location=module
        echo "Docker Desktop installer downloaded. Please double-click the downloaded installer docker.exe to install Docker Desktop."

        shutdown /r /t 0

    # If the operating system is none of the above
    else
        echo "Unsupported operating system: $OS"
    fi
fi



