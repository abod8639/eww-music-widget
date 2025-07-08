#!/bin/bash

# This script fetches and caches album art for the current song.
# It's designed to be called by EWW and is optimized to minimize
# network and disk I/O.

WIDGET_DIR=$(dirname "$0")
DEFAULT_COVER="$WIDGET_DIR/assets/DEFAULTImage.jpeg"
CACHE_DIR="$HOME/.cache/eww/music-widget"
mkdir -p "$CACHE_DIR"

# Function to safely exit with the default cover
show_default_cover() {
    echo "$DEFAULT_COVER"
    exit 0
}

# Get the art URL. Exit if player is not running or no URL is available.
COVER_URL=$(playerctl metadata mpris:artUrl 2>/dev/null)
if [[ -z "$COVER_URL" ]]; then
    show_default_cover
fi

# If it's a local file (file://), decode the path and use it directly.
if [[ "$COVER_URL" == file://* ]]; then
    # URL-decode the path to handle special characters like spaces
    LOCAL_PATH=$(printf '%b' "${COVER_URL#file://}")
    if [[ -f "$LOCAL_PATH" ]]; then
        echo "$LOCAL_PATH"
        exit 0
    else
        show_default_cover
    fi
fi

# For web URLs, we hash the URL to create a unique filename for caching.
URL_HASH=$(echo -n "$COVER_URL" | md5sum | awk '{print $1}')
# Try to get a file extension from the URL, default to .jpg if it's weird.
EXTENSION="${COVER_URL##*.}"
if [[ "$EXTENSION" == "$COVER_URL" ]] || [[ ${#EXTENSION} -gt 5 ]]; then
    EXTENSION="jpg"
fi
CACHED_COVER="$CACHE_DIR/$URL_HASH.$EXTENSION"

# If the cover is not already cached, download it.
if [ ! -f "$CACHED_COVER" ]; then
    # Download with a 5-second timeout. If it fails or the downloaded file is empty,
    # clean up and show the default cover.
    curl -s -L --max-time 5 "$COVER_URL" -o "$CACHED_COVER"
    if [[ $? -ne 0 ]] || [[ ! -s "$CACHED_COVER" ]]; then
        rm -f "$CACHED_COVER"
        show_default_cover
    fi
fi

# As a final sanity check, ensure the cached file is a valid image.
# If not, remove the junk file and show the default cover.
if file "$CACHED_COVER" | grep -qE 'image|jpeg|png|jpg|gif'; then
    echo "$CACHED_COVER"
else
    rm -f "$CACHED_COVER"
    show_default_cover
fi

exit 0
