#!/usr/bin/env sh

step=5

if [ "$1" = "-o" ]; then
    shift
fi

case $1 in
    i) pamixer -i "${2:-$step}" ;;
    d) pamixer -d "${2:-$step}" ;;
    m) pamixer -t ;;
    g) pamixer --get-volume ;;
    s) pamixer --set-volume "$2" ;;
esac