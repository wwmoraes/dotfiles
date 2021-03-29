#!/bin/sh

SOURCE=$1
DESTINATION=${HOME}/${1#*/}

echo "Unlinking ${DESTINATION}"
unlink "${DESTINATION}"
echo "Moving ${SOURCE} to ${DESTINATION}"
mv "${SOURCE}" "${DESTINATION}"
