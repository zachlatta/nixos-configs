#!/bin/sh
# The Dropbox setup here is a little atypical, so do be warned.
#
# See https://wiki.archlinux.org/index.php/dropbox#Multiple_Dropbox_instances for
# reference.
#
# Basically we expect there to be multiple folders in DROPBOX_BASE, each
# containing a fully set-up Dropbox instance in it.
#
# We trick Dropbox into running multiple instances on the same machine by telling
# it that each directory in DROPBOX_BASE is a HOME directory for an instance.

if [ "$DROPBOX_ENV" == "" ]; then
  >&2 echo "DROPBOX_ENV environment variable must be set. Try setting it to 'personal' or to 'work'."
fi

if [ "$DROPBOX_BASE" == "" ]; then
  >&2 echo "DROPBOX_BASE needs to be set. This should be the directory that the Dropbox home directories are stored in."
fi

echo "Starting Dropbox ${DROPBOX_ENV} instance..."

HOME="${DROPBOX_BASE}/${DROPBOX_ENV}" "${DROPBOX_BASE}/${DROPBOX_ENV}/.dropbox-dist/dropboxd"
