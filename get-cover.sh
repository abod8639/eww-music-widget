#!/bin/bash

COVER_URL=$(playerctl metadata mpris:artUrl)
DEFAULT_COVER="$HOME/.config/eww/music-widget/default-cover.png"

if [[ -n "$COVER_URL" ]]; then
    if [[ "$COVER_URL" == file://* ]]; then
        LOCAL_PATH="${COVER_URL#file://}"
        if [[ -f "$LOCAL_PATH" ]]; then
            echo "$LOCAL_PATH"
            exit 0
        fi
    else
        FILENAME=$(echo -n "$COVER_URL" | md5sum | awk '{print $1}')
        TMP_COVER="/tmp/${FILENAME}.png"

        if [ ! -f "$TMP_COVER" ]; then
            curl -s -L "$COVER_URL" -o "$TMP_COVER"
        fi

        if file "$TMP_COVER" | grep -qE 'image|jpg|jpeg|png|gif'; then
            echo "$TMP_COVER"
            exit 0
        fi
    fi
fi

if [ -f "$DEFAULT_COVER" ]; then
    echo "$DEFAULT_COVER"
else
    echo "$HOME/Downloads/jpg(34).jpeg"
fi

exit 0
