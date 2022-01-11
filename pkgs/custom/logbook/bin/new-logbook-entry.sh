#!/usr/bin/env bash
#
# LOGBOOK_DIR, EXT, and EDITOR can be overridden.

DEFAULT_LOGBOOK_DIR=/mnt/pokedex/txt/Typewriter\ Daily\ Writings
DEFAULT_EXT=".md"
DEFAULT_EDITOR="typora"

LOGBOOK_DIR="${LOGBOOK_DIR:-$DEFAULT_LOGBOOK_DIR}"
EXT="${EXT:-$DEFAULT_EXT}" # can change to .txt or something else
EDITOR="${EDITOR:-$DEFAULT_EDITOR}"

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
FS_TIME=$(echo $TIME | sed 's/:/./g') # a version of $TIME safe for filenames (':' doesn't work on macOS)

FILE=""

if test -f "$LOGBOOK_DIR/$DATE$EXT"; then
    if test -f "$LOGBOOK_DIR/$DATE $FS_TIME$EXT"; then
      $EDITOR "$LOGBOOK_DIR/$DATE $FS_TIME$EXT"
      exit 0
    fi

    FILE="$LOGBOOK_DIR/$DATE $FS_TIME$EXT"
else 
  FILE="$LOGBOOK_DIR/$DATE$EXT"
fi

touch "$FILE"

echo "*$DATE*" >> "$FILE"
echo "*LOCATION*" >> "$FILE"
echo "*$TIME*" >> "$FILE"
echo "" >> "$FILE"
echo "**Logbook Entry**" >> "$FILE"
echo "" >> "$FILE"

$EDITOR "$FILE"