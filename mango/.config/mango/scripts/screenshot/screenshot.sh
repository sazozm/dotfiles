#!/usr/bin/env bash
set -euo pipefail

# Создаем папку, если её нет
mkdir -p "$HOME/Pictures/Screenshots"

# Формат имени файла
filepath="$HOME/Pictures/Screenshots/Screenshot from $(date '+%Y-%m-%d %H-%M-%S').png"

# Функция для копирования в буфер и уведомления
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
  window)
    g=$(mmsg -x | awk '/x / {x=$3} /y / {y=$3} /width / {w=$3} /height / {h=$3} END {print x","y" "w"x"h}')
    [ -z "$g" ] && exit 1
    grim -g "$g" "$filepath"
    post_process "$filepath"
    ;;
  annotate)
    # Сначала делаем скриншот всего экрана
    grim "$filepath"
    # Открываем в satty для редактирования. 
    # После сохранения в satty файл обновится, и мы его скопируем.
    satty --filename "$filepath" --output-filename "$filepath" --actions-on-enter save-to-file --early-exit
    post_process "$filepath"
    ;;
  *) 
    grim "$filepath"
    post_process "$filepath"
    ;;
esac
