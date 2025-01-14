#!/bin/bash

# Define the download URL
URL="https://release.gitkraken.com/linux/gitkraken-amd64.deb"

# Temporary file for the download
temp_deb="/tmp/gitkraken.deb"

# Update package list and install dependencies
echo "Updating package list and installing required tools..."
apt update && apt install -y wget gdebi-core

# Download the GitKraken .deb file
echo "Downloading GitKraken package..."
wget -O "$temp_deb" "$URL"
if [ $? -ne 0 ]; then
    echo "Failed to download GitKraken. Please, check the URL."
    exit 1
fi

# Install the .deb package
echo "Installing GitKraken..."
gdebi -n "$temp_deb"
if [ $? -ne 0 ]; then
    echo "Installation failed. Please, contact Juanma."
    exit 1
fi

# Clean up the temporary file
echo "Cleaning up..."
rm "$temp_deb"

# Confirm installation
if command -v gitkraken &> /dev/null; then
    echo "GitKraken has been successfully installed."
else
    echo "GitKraken installation failed."
    exit 1
fi
