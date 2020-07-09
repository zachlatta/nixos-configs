# The Sway configuration file in ~/.config/sway/config calls this script.
# You should see changes to the status bar after saving this script.
# If not, do "killall swaybar" and $mod+Shift+c to reload the configuration.
#
# Based on https://unix.stackexchange.com/a/473789

# Produces "21 days", for example
uptime_formatted=$(uptime | cut -d ',' -f1  | cut -d ' ' -f4,5)

# The abbreviated weekday (e.g., "Sat"), followed by the ISO-formatted date
# like 2018-10-06 and the time (e.g., 14:01)
date_formatted=$(date "+%a %F %H:%M")

# Get the Linux version but remove the "-1-ARCH" part
linux_version=$(uname -r | cut -d '-' -f1)

# Time since last sync of ~/dev/inbox/
inbox_sync=$(($(date +%s) - $(stat -c %Y ~/dev/inbox/.git/FETCH_HEAD)))

# Returns the current WiFi network name
networking="$(nmcli -t -f name connection show --active)"

# Returns screen brightness percentage
brightness="$(printf %.0f $(light))%"

# Returns current volume
volume="$(pamixer --get-volume-human)"

# Returns the battery % full
battery_status="$(cat /sys/class/power_supply/BAT0/capacity)%"

# Returns the remaining space on the system drive
hdd_remaining="$(df -h | grep vol_grp-root | tr -s ' ' | cut -d ' ' -f 4)"

# Emojis and characters for the status bar
# 💎 💻 💡 🔌 ⚡ 📁 \|
echo ↑ $uptime_formatted 🐧 $linux_version 📥 last sync $inbox_sync seconds ago 📡 $networking 🖴 $hdd_remaining 🌞 $brightness 🔊 $volume 🔋 $battery_status '|' $date_formatted
