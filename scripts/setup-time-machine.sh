#!/usr/bin/env bash

URL=$(op read "op://Home/TimeMachine/url")
USERNAME=$(op read "op://Home/TimeMachine/username")
# PASSWORD=$(op read "op://Home/TimeMachine/password")

sudo tmutil setdestination -p -a "smb://${USERNAME}:${PASSWORD}@${URL}/TimeMachine"
# op read "op://Home/TimeMachine/password" | sudo tmutil setdestination -p -a "smb://${USERNAME}@${URL}/TimeMachine"
