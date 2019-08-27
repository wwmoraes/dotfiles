#!/bin/bash

SOURCE=$1
DESTINATION=~/${1#*/}

echo "Unlinking $DESTINATION"
unlink "$DESTINATION"
echo "Moving $SOURCE to $DESTINATION"
mv "$SOURCE" "$DESTINATION"