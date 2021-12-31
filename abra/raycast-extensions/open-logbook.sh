#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Logbook
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 📖

# Documentation:
# @raycast.author zach latta
# @raycast.authorURL https://github.com/zachlatta

EDITOR="open -a typora"
LOGBOOK_DIR=~/pokedex/txt/Typewriter\ Daily\ Writings

$EDITOR "$LOGBOOK_DIR"
