#!/bin/bash

sudo launchctl config user path $PATH
launchctl setenv PATH $PATH
killall Dock
