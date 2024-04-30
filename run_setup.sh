#!/bin/bash
# Detect the operating system
OS=$(uname -s)
# Define the image name
IMAGE_NAME="jupyter/pyspark-notebook"
CONTAINER_NAME_OR_ID="pyspark_workshop"

docker_conainer_creation () {
    docker run -p 10001:8888 \
    -v src:/home/jovyan/work \
    --name "$1" \
    "$2"
}


# Check if Docker is installed
if command -v docker &> /dev/null; then
    echo "Docker is installed"

    # Check if the docker image exists
    if docker ps --filter "name=$CONTAINER_NAME_OR_ID" --format '{{.Names}}' | grep -q "$CONTAINER_NAME_OR_ID"; then
        echo "$IMAGE_NAME has been pulled. Docker container will be newly setup."
        
        # Remove the existing container
        docker rm "$CONTAINER_NAME_OR_ID"
        
        # Create the new container
        docker_conainer_creation "$CONTAINER_NAME_OR_ID" "$IMAGE_NAME"
    else
        echo "$IMAGE_NAME has not been pulled. Image will be pulled."
        docker pull "$IMAGE_NAME"

        echo "Container $CONTAINER_NAME_OR_ID does not exist. Container will be set up."
        docker_conainer_creation "$CONTAINER_NAME_OR_ID" "$IMAGE_NAME"
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



