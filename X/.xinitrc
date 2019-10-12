#!/bin/sh

# Merge Xresources
exec xrdb -merge ~/.Xresources

# PulseAudio
exec start-pulseaudio-x11

# Start tmux scratchpad session
exec tmux new -A -s scratchpad -d

# start twmn notify daemon
exec twmnd

# start i3wm
exec i3
