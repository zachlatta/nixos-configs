#!/bin/bash
#
# Any macOS specific config goes here.

# Load up z, our favorite little helper
if [ ! -f /usr/local/etc/profile.d/z.sh ]; then
  echo "z not installed! Please install it."
else
  . /usr/local/etc/profile.d/z.sh
fi
