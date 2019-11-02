#!/bin/bash
#
# Any macOS specific config goes here.

# Silence bash deprecation warning in macOS Catalina
export BASH_SILENCE_DEPRECATION_WARNING=1

# Load up z, our favorite little helper
if [ ! -f /usr/local/etc/profile.d/z.sh ]; then
  echo "z not installed! Please install it."
else
  . /usr/local/etc/profile.d/z.sh
fi
