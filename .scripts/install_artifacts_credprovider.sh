#!/bin/bash
#To make the .sh file executable
#sudo chmod +x ./create_seido_nuget_feed.sh

# DESCRIPTION: A simple shell script designed to fetch a version
# of the artifacts credential provider plugin and install it into $HOME/.nuget/plugins.
# https://github.com/microsoft/artifacts-credprovider

URI="https://github.com/microsoft/artifacts-credprovider/releases/download/v1.1.1/Microsoft.Net6.NuGet.CredentialProvider.tar.gz"
NUGET_PLUGIN_DIR="$HOME/.nuget/plugins"


# Ensure plugin directory exists
if [ ! -d "${NUGET_PLUGIN_DIR}" ]; then
  echo "INFO: Creating the nuget plugin directory (i.e. ${NUGET_PLUGIN_DIR}). "
  if ! mkdir -p "${NUGET_PLUGIN_DIR}"; then
      echo "ERROR: Unable to create nuget plugins directory (i.e. ${NUGET_PLUGIN_DIR})."
      exit 1
  fi
fi

#Fetch the file and untar it
echo "Downloading from $URI"
if ! curl -H "Accept: application/octet-stream" \
     -s \
     -S \
     -L \
     "$URI" | tar xz -C "$HOME/.nuget/" "plugins/netcore"; then
        
        echo "Error Downloading from $URI"
        exit 1
fi

echo "INFO: credential provider netcore plugin extracted to $HOME/.nuget/"