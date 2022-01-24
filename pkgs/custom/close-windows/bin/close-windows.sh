# from https://unix.stackexchange.com/a/145766/52095
#
# close all open windows gracefully without closing the Desktop environment
WIN_IDs=$($WMCTRL_BIN -l | grep -vwE "Desktop$|xfce4-panel$" | cut -f1 -d' ')
for i in $WIN_IDs; do $WMCTRL_BIN -ic "$i"; done
# Keep checking and waiting until all windows are closed (you probably don't need this section)
while test $WIN_IDs; do 
    sleep 0.1; 
    WIN_IDs=$($WMCTRL_BIN -l | grep -vwE "Desktop$|xfce4-panel$" | cut -f1 -d' ')
done 