#!/bin/bash
KEYMODE=$(mmsg -b 2>/dev/null | awk '{print $NF}' | sort -u | grep -v '^default$' | head -1)

if [ -n "$KEYMODE" ]; then
    printf '{"text":"%s","class":"resize"}\n' "$KEYMODE"
    exit 0
fi

decode() {
    case "$1" in
        T)  echo "tile"      ;;
        S)  echo "scroller"  ;;
        M)  echo "monocle"   ;;
        G)  echo "grid"      ;;
        K)  echo "deck"      ;;
        CT) echo "center"    ;;
        VT) echo "v-tile"    ;;
        RT) echo "r-tile"    ;;
        VS) echo "v-scroll"  ;;
        VG) echo "v-grid"    ;;
        VK) echo "v-deck"    ;;
        D)  echo "dwindle"   ;;
        F)  echo "fair"      ;;
        VF) echo "v-fair"    ;;
        *)  echo "$1"        ;;
    esac
}

LAYOUTS=$(mmsg -g -l 2>/dev/null | awk '{print $1, $NF}')
TEXT=""
while IFS= read -r line; do
    MON=$(echo "$line" | awk '{print $1}')
    CODE=$(echo "$line" | awk '{print $2}')
    NAME=$(decode "$CODE")
    [ -n "$TEXT" ] && TEXT="$TEXT  $NAME" || TEXT="$NAME"
done <<< "$LAYOUTS"

[ -z "$TEXT" ] && printf '{"text":"","class":"default"}\n' && exit 0

printf '{"text":"%s","class":"layout"}\n' "$TEXT"
#!/bin/bash
KEYMODE=$(mmsg -b 2>/dev/null | awk '{print $NF}' | sort -u | grep -v '^default$' | head -1)

if [ -n "$KEYMODE" ]; then
    printf '{"text":"%s","class":"resize"}\n' "$KEYMODE"
    exit 0
fi

decode() {
    case "$1" in
        T)  echo "tile"      ;;
        S)  echo "scroller"  ;;
        M)  echo "monocle"   ;;
        G)  echo "grid"      ;;
        K)  echo "deck"      ;;
        CT) echo "center"    ;;
        VT) echo "v-tile"    ;;
        RT) echo "r-tile"    ;;
        VS) echo "v-scroll"  ;;
        VG) echo "v-grid"    ;;
        VK) echo "v-deck"    ;;
        D)  echo "dwindle"   ;;
        F)  echo "fair"      ;;
        VF) echo "v-fair"    ;;
        *)  echo "$1"        ;;
    esac
}

LAYOUTS=$(mmsg -g -l 2>/dev/null | awk '{print $1, $NF}')
TEXT=""
while IFS= read -r line; do
    MON=$(echo "$line" | awk '{print $1}')
    CODE=$(echo "$line" | awk '{print $2}')
    NAME=$(decode "$CODE")
    [ -n "$TEXT" ] && TEXT="$TEXT  $NAME" || TEXT="$NAME"
done <<< "$LAYOUTS"

[ -z "$TEXT" ] && printf '{"text":"","class":"default"}\n' && exit 0

printf '{"text":"%s","class":"layout"}\n' "$TEXT"

