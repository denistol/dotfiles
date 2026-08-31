#!/bin/bash
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILE="$DIR/screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"

GEOM=$(slurp)
if [ -n "$GEOM" ]; then
    grim -g "$GEOM" "$FILE"
    wl-copy --type image/png < "$FILE"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -i "$FILE" "Скриншот сохранен" "Скопирован в буфер и сохранен в:\n$FILE"
    fi
fi
