#!/usr/bin/env bash
#
# LOGBOOK_DIR and EDITOR can be overridden.

DEFAULT_LOGBOOK_DIR=/mnt/pokedex/txt/Typewriter\ Daily\ Writings
DEFAULT_EDITOR="typora"

LOGBOOK_DIR="${LOGBOOK_DIR:-$DEFAULT_LOGBOOK_DIR}"
EDITOR="${EDITOR:-$DEFAULT_EDITOR}"

$EDITOR "$LOGBOOK_DIR"
