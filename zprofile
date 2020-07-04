# hidpi support for zoom (other QT apps too), make it look not horrible

export QT_SCALE_FACTOR=0.65

# for hidpi support on psyduck
export MOZ_ENABLE_WAYLAND=1

# change "desktop" dir
#
# see https://wiki.archlinux.org/index.php/Firefox#Firefox_keeps_creating_~/Desktop_even_when_this_is_not_desired
export XDG_DESKTOP_DIR=/home/zrl/downloads/

# default screenshot location
export GRIM_DEFAULT_DIR=/home/zrl/pokedex/screenshots/psyduck/

# hide OpenCV warnings to prevent Howdy from complaining every time it auths -
# see https://wiki.archlinux.org/index.php/Howdy#GStreamer_warnings_in_shell
export OPENCV_LOG_LEVEL=ERROR
