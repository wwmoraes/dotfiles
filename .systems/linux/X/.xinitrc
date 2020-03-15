#!/bin/sh

# Allow root to create X windows on this user
exec xhost +si:localuser:root

# Merge Xresources
exec xrdb -merge ~/.Xresources

# PulseAudio
exec start-pulseaudio-x11

# Start tmux scratchpad session
exec tmux new -A -s scratchpad -d

# start twmn notify daemon
exec twmnd

# geoclue2 agent
exec /usr/lib/geoclue-2.0/demos/agent

# start i3wm
exec i3
