#bin!/bin/bash
echo "Installing Kdevelop editor..."

wget -O KDevelop.AppImage https://download.kde.org/stable/kdevelop/5.6.1/bin/linux/KDevelop-5.6.1-x86_64.AppImage
chmod +x KDevelop.AppImage

# Renaming the file to be hidden and moving it in the home folder
mv KDevelop.AppImage $HOME/.KDevelop.AppImage
