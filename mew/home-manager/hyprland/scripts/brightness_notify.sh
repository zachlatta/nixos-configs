#!/usr/bin/env bash
# brightness_notify.sh
# Shows a brightness notification

BRIGHTNESS=$(brightnessctl g)
MAX_BRIGHTNESS=$(brightnessctl m)
PERCENTAGE=$((BRIGHTNESS * 100 / MAX_BRIGHTNESS))

ICON=""
if [[ "$PERCENTAGE" -lt 34 ]]; then
    ICON="display-brightness-low-symbolic"
elif [[ "$PERCENTAGE" -lt 67 ]]; then
    ICON="display-brightness-medium-symbolic"
else
    ICON="display-brightness-high-symbolic"
fi

notify-send -h string:x-canonical-private-synchronous:brightness_notif -u low -i "$ICON" "Brightness: ${PERCENTAGE}%" -h int:value:"${PERCENTAGE}" 