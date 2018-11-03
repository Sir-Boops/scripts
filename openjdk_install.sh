#!/bin/bash

# Request the URL
read -p "Please enter the DIRECT URL for your chosen OpenJDK download, This should end in '.tar.gz' : " DL_URL

# Download the OpenJDK version
rm -f ~/.openjdk.tar.gz
wget $DL_URL -O ~/.openjdk.tar.gz

# Extract the tarfile
echo "Extracting archive"
rm -rf ~/.openjdk-tmp
mkdir -p ~/.openjdk-tmp
tar -xf ~/.openjdk.tar.gz -C ~/.openjdk-tmp

# Get the folder name inside the tmp
echo "Copying folder to it's new installed location"
FOLDER_NAME=`ls ~/.openjdk-tmp`
rm -rf ~/.openjdk
mv ~/.openjdk-tmp/$FOLDER_NAME ~/.openjdk

# If installed before it's fine
# Else add the new bin to PATH
read -p "Have you run this script before?" ANS
ANS=`echo ${ANS,,}`

if [ $ANS == "yes" ]; then
	echo "openJDK has been installed and you're good to go!"
else
	echo "appending path edit to ~/.bashrc please restart your terminal to start using java"
	echo 'PATH=$PATH:~/.openjdk/bin' >> ~/.bashrc
fi

# Remove tmp folders
echo "Removing tmp files!"
rm ~/.openjdk.tar.gz
rm -rf ~/.openjdk-tmp
