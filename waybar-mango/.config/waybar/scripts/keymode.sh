#!/bin/bash

# Получаем текущий режим с помощью правильной команды 'mmsg get keymode'
KEYMODE=$(mmsg get keymode 2>/dev/null | awk '{print $NF}' | sort -u | grep -v '^default$' | head -1)

# Если режим активен (не default), сразу выводим его в Waybar
if [ -n "$KEYMODE" ]; then
  printf '{"text":"%s","class":"resize"}\n' "$KEYMODE"
  exit 0
fi

# Функция декодирования символов или названий макетов
decode() {
  case "$1" in
  T | tile) echo "tile" ;;
  S | scroller) echo "scroller" ;;
  M | monocle) echo "monocle" ;;
  G | grid) echo "grid" ;;
  K | deck) echo "deck" ;;
  CT | center) echo "center" ;;
  VT | v-tile) echo "v-tile" ;;
  RT | r-tile) echo "r-tile" ;;
  VS | v-scroll) echo "v-scroll" ;;
  VG | v-grid) echo "v-grid" ;;
  VK | v-deck) echo "v-deck" ;;
  D | dwindle) echo "dwindle" ;;
  F | fair) echo "fair" ;;
  VF | v-fair) echo "v-fair" ;;
  *) echo "$1" ;;
  esac
}

# Получаем список тегов и макетов через 'mmsg get all-tags'
# Сохраняем вашу оригинальную логику обработки первого ($1) и последнего ($NF) аргументов строки
LAYOUTS=$(mmsg get all-tags 2>/dev/null | awk '{print $1, $NF}')

TEXT=""
while IFS= read -r line; do
  # Пропускаем пустые строки, если они есть
  [ -z "$line" ] && continue

  MON=$(echo "$line" | awk '{print $1}')
  CODE=$(echo "$line" | awk '{print $2}')
  NAME=$(decode "$CODE")

  if [ -n "$TEXT" ]; then
    TEXT="$TEXT  $NAME"
  else
    TEXT="$NAME"
  fi
done <<<"$LAYOUTS"

# Если вывод пустой, отдаем пустой JSON со стандартным классом
if [ -z "$TEXT" ]; then
  printf '{"text":"","class":"default"}\n'
  exit 0
fi

# Вывод результирующей строки макетов для Waybar
printf '{"text":"%s","class":"layout"}\n' "$TEXT"
