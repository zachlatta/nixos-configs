#!/usr/bin/env bash
# volume_notify.sh
# Shows a volume notification using dunst/mako

MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '/Volume:/ {print $5}' | sed 's/%//')

ICON_MUTED="audio-volume-muted-symbolic"
if [[ "$VOLUME" -eq 0 || "$MUTED" == "yes" ]]; then
    ICON_VOL="audio-volume-muted-blocking-symbolic"
elif [[ "$VOLUME" -lt 34 ]]; then
    ICON_VOL="audio-volume-low-symbolic"
elif [[ "$VOLUME" -lt 67 ]]; then
    ICON_VOL="audio-volume-medium-symbolic"
else
    ICON_VOL="audio-volume-high-symbolic"
fi

if [[ "$MUTED" == "yes" ]]; then
    notify-send -h string:x-canonical-private-synchronous:volume_notif -u low -i "$ICON_MUTED" "Muted"
else
    notify-send -h string:x-canonical-private-synchronous:volume_notif -u low -i "$ICON_VOL" "Volume: ${VOLUME}%" -h int:value:"${VOLUME}"
fi 