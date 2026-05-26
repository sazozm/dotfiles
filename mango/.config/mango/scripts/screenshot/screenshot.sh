#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HOME/Pictures/Screenshots"
filepath="$HOME/Pictures/Screenshots/Screenshot from $(date '+%Y-%m-%d %H-%M-%S').png"

post_process() {
    if [ -f "$1" ]; then
        wl-copy < "$1"
        dunstify "Screenshot" "Saved and copied to clipboard" -i "$1"
    fi
}

case "${1:-fullscreen}" in
  region)
    g=$(slurp -d); [ -z "$g" ] && exit 1
    grim -g "$g" "$filepath"
    post_process "$filepath"
    ;;
  output)
    cursor_pos=$(slurp -p -d 2>/dev/null || echo "0,0")
    cx=$(echo "$cursor_pos" | cut -d, -f1 | tr -d '[:space:]')
    
    g="0,0 1920x1080"
    
    if [ -n "$cx" ] && (( cx >= 1920 )); then
        g="1920,0 1920x1080"
    else
        g="0,0 1920x1080"
    fi
    
    grim -g "$g" "$filepath"
    post_process "$filepath"
    ;;
  window)
    g=$(mmsg -x | awk '/x / {x=$3} /y / {y=$3} /width / {w=$3} /height / {h=$3} END {print x","y" "w"x"h}')
    [ -z "$g" ] && exit 1
    grim -g "$g" "$filepath"
    post_process "$filepath"
    ;;
  annotate)
    grim "$filepath"
    satty --filename "$filepath" --output-filename "$filepath" --actions-on-enter save-to-file --early-exit
    post_process "$filepath"
    ;;
  *) 
    grim "$filepath"
    post_process "$filepath"
    ;;
esac
