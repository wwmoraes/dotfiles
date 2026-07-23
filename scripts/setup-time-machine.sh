#!/usr/bin/env bash

URL=$(op read "op://Home/NAS - timemachine/url")
USERNAME=$(op read "op://Home/NAS - timemachine/username")

op read "op://Home/NAS - timemachine/password" | sudo tmutil setdestination -p -a "smb://${USERNAME}:${PASSWORD}@${URL}/TimeMachine"
