#!/bin/bash

OUT=$(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu,memory.used,memory.total \
    --format=csv,noheader,nounits 2>/dev/null)

if [ -z "$OUT" ]; then
    echo '{"text":"N/A","class":"off","tooltip":"nvidia-smi unavailable"}'
    exit 0
fi

U=$(echo "$OUT"  | awk -F',' '{gsub(/ /,"",$1); print $1}')
T=$(echo "$OUT"  | awk -F',' '{gsub(/ /,"",$2); print $2}')
MU=$(echo "$OUT" | awk -F',' '{gsub(/ /,"",$3); print $3}')
MT=$(echo "$OUT" | awk -F',' '{gsub(/ /,"",$4); print $4}')

CL="normal"
if   [ "$T" -ge 85 ] 2>/dev/null; then CL="critical"
elif [ "$T" -ge 70 ] 2>/dev/null; then CL="warning"
fi

TEXT="${U}% ${T}°"
TOOLTIP="GPU ${U}%  Temp ${T}°\nVRAM ${MU}MiB / ${MT}MiB"

printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$TEXT" "$TOOLTIP" "$CL"
