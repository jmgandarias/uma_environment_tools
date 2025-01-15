#!/bin/bash

# Define the download URL
URL="https://release.gitkraken.com/linux/gitkraken-amd64.deb"

# Temporary file for the download
temp_deb="$HOME/temp/gitkraken.deb"
mkdir -p "$(dirname "$temp_deb")"

# Update package list and install dependencies
echo "Updating package list and installing required tools..."
sudo apt update && sudo apt install -y wget gdebi-core

# Download the GitKraken .deb file
echo "Downloading GitKraken package..."
sudo wget -O "$temp_deb" "$URL"
if [ $? -ne 0 ]; then
    error "Failed to download GitKraken. Please, check the URL."
    exit 1
fi

# Install the .deb package
echo "Installing GitKraken..."
sudo gdebi -n "$temp_deb"
if [ $? -ne 0 ]; then
    error "Installation failed. Please, contact Juanma."
    exit 1
fi

# Clean up the temporary file
echo "Cleaning up the temporary files"
sudo rm -r ~/temp

# Confirm installation
if command -v gitkraken &> /dev/null; then
    success "GitKraken has been successfully installed."
else
    error "GitKraken installation failed."
    exit 1
fi
