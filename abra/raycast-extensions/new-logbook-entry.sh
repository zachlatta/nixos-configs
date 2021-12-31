#!/bin/sh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title New Logbook Entry
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 📖

# Documentation:
# @raycast.description Create a new dated entry in the logbook, complete with location and other details if available
# @raycast.author zach latta
# @raycast.authorURL https://github.com/zachlatta

LOGBOOK_DIR=~/pokedex/txt/Typewriter\ Daily\ Writings
EXT=".md" # can change to .txt or something else
EDITOR="open -a typora"

# from https://coderedirect.com/questions/550619/formatting-the-date-in-unix-to-include-suffix-on-day-st-nd-rd-and-th
DaySuffix() {
    if [ "x`date +%-d | cut -c2`x" = "xx" ]
    then
        DayNum=`date +%-d`
    else
        DayNum=`date +%-d | cut -c2`
    fi

    CheckSpecialCase=`date +%-d`
    case $DayNum in
    0 )
      echo "th" ;;
    1 )
      if [ "$CheckSpecialCase" = "11" ]
      then
        echo "th"
      else
        echo "st"
      fi ;;
    2 )
      if [ "$CheckSpecialCase" = "12" ]
      then
        echo "th"
      else
        echo "nd"
      fi ;;
    3 )
      if [ "$CheckSpecialCase" = "13" ]
      then
        echo "th"
      else
        echo "rd"
      fi ;;
    [4-9] )
      echo "th" ;;
    * )
      return 1 ;;
    esac
}

# Using consolidated date command from chris_l
# Also using %-d instead of %d so it doesn't pad with 0's
DATE=$(date "+%A, %B %-d`DaySuffix`, %Y")
TIME=$(date "+%-I:%M %p")

FILE=""

if test -f "$LOGBOOK_DIR/$DATE$EXT"; then
    if test -f "$LOGBOOK_DIR/$DATE $TIME$EXT"; then
      $EDITOR "$LOGBOOK_DIR/$DATE $TIME$EXT"
      exit 0
    fi

    FILE="$LOGBOOK_DIR/$DATE $TIME$EXT"
else 
  FILE="$LOGBOOK_DIR/$DATE$EXT"
fi

touch "$FILE"

$EDITOR "$FILE"