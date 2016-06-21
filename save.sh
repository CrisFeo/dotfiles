#! /bin/bash
set -e


# Karabiner
KARABINER="/Applications/Karabiner.app/Contents/Library/bin/karabiner"
DIR_PRIVATE_XML="$HOME/Library/Application Support/Karabiner/private.xml"
cp -f "$DIR_PRIVATE_XML" ./karabiner/private.xml
$KARABINER export >./karabiner/import.sh


