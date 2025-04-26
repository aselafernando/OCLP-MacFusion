#!/bin/bash

DOWNLOAD_FILE=./Autodesk\ Fusion\ Installer.dmg
JSON_CONFIG=~/Desktop/Install\ Autodesk\ Fusion.app/Contents/Resources/resources/precheck_config.json
MOUNT_POINT=/Volumes/Autodesk\ Fusion\ Installer

if [ ! -f "$DOWNLOAD_FILE" ]; then
  echo "Downloading Fusion Client Downloader image..."
  curl -o "$DOWNLOAD_FILE" "https://dl.appstreaming.autodesk.com/production/installers/Fusion%20Client%20Downloader.dmg"
fi

if [ ! -e ~/Desktop/Install\ Autodesk\ Fusion.app ]; then
  hdiutil attach "$DOWNLOAD_FILE"
  cp -R "$MOUNT_POINT/Install Autodesk Fusion.app" ~/Desktop/
  hdiutil detach "$MOUNT_POINT"
fi

echo "Modifying JSON configuration.."
jq '.prechecks.CheckMacOSHardwareConfig.mandatory = "No"' "$JSON_CONFIG" > /tmp/precheck_config.json.tmp
mv /tmp/precheck_config.json.tmp "$JSON_CONFIG"

echo "Removing quarantine from modified application"
xattr -rd com.apple.quarantine "$JSON_CONFIG"
