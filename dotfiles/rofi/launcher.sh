#!/usr/bin/env bash

theme="kde_krunner"
dir="$HOME/.config/rofi/"

rofi -no-lazy-grab -show drun -modi drun -theme $dir/"$theme"
