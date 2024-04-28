#!/bin/bash
# Detect the operating system
OS=$(uname -s)

# Check if Docker is installed
if command -v docker &> /dev/null; then
    echo "Docker is installed"
else
    echo "Docker is not installed. Please install Docker."
    # Check if the operating system is macOS
    if [[ "$OS" =~ Darwin ]]; then
        echo "macOS detected"
        xdg-open https://www.docker.com/products/docker-desktop/
    # Check if the operating system is Linux
    elif [[ "$OS" =~ Linux ]]; then
        echo "Linux detected"
        xdg-open https://www.docker.com/products/docker-desktop/
    # Check if the operating system is Windows
    elif [[ "$OS" =~ MINGW64_NT ]]; then
        echo "Windows detected"
        #check if wsl2 is installed as it is needed to work with docker
        start https://www.docker.com/products/docker-desktop/
    # If the operating system is none of the above
    else
        echo "Unsupported operating system: $OS"
    fi
fi

# Run Docker with prefabricated image
docker pull jupyter/pyspark-notebook

docker run -p 10001:8888 \
-v src:/home/jovyan/work/ \
jupyter/pyspark-notebook

