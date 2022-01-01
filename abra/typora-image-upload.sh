#!/bin/bash

HOST="slowking:1000"

for FILE in "$@"; do
    cat "$FILE" | curl --data-binary @- http://$HOST/upload
done
