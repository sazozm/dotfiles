#!/bin/bash
set -e
out_json() { printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$1" "$2" "$3"; }

# NVIDIA
if command -v nvidia-smi &>/dev/null && nvidia-smi &>/dev/null; then
  OUT=$(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu,memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null)
  if [ -n "$OUT" ]; then
    U=$(echo "$OUT" | awk -F',' '{gsub(/ /,"",$1); print $1}')
    T=$(echo "$OUT" | awk -F',' '{gsub(/ /,"",$2); print $2}')
    MU=$(echo "$OUT" | awk -F',' '{gsub(/ /,"",$3); print $1}')
    MT=$(echo "$OUT" | awk -F',' '{gsub(/ /,"",$4); print $1}')
    CL="normal"; [ "$T" -ge 85 ] 2>/dev/null && CL="critical"; [ "$T" -ge 70 ] 2>/dev/null && [ "$CL" = "normal" ] && CL="warning"
    out_json "${U}% ${T}°" "GPU ${U}%  Temp ${T}°\nVRAM ${MU}MiB / ${MT}MiB" "$CL"; exit 0
  fi
fi

# AMD
if [ -d /sys/class/drm/card0/device ]; then
  GPU_PATH="/sys/class/drm/card0/device"
  TEMP=$(cat "$GPU_PATH/hwmon/hwmon*/temp1_input" 2>/dev/null | head -n1)
  [ -n "$TEMP" ] && TEMP=$((TEMP / 1000)) || TEMP="?"
  USAGE=$(cat "$GPU_PATH/gpu_busy_percent" 2>/dev/null || echo "?")
  VRAM_USED=$(cat "$GPU_PATH/mem_info_vram_used" 2>/dev/null)
  VRAM_TOTAL=$(cat "$GPU_PATH/mem_info_vram_total" 2>/dev/null)
  if [ -n "$VRAM_USED" ] && [ -n "$VRAM_TOTAL" ]; then
    MU=$((VRAM_USED / 1048576)); MT=$((VRAM_TOTAL / 1048576)); VRAM_STR="${MU}M / ${MT}M"
  else VRAM_STR="N/A"; fi
  CL="normal"; [ "$TEMP" != "?" ] && [ "$TEMP" -ge 85 ] 2>/dev/null && CL="critical"; [ "$TEMP" != "?" ] && [ "$TEMP" -ge 70 ] 2>/dev/null && [ "$CL" = "normal" ] && CL="warning"
  out_json "${USAGE}% ${TEMP}°" "AMD GPU ${USAGE}%  Temp ${TEMP}°\nVRAM ${VRAM_STR}" "$CL"; exit 0
fi

out_json "N/A" "No supported GPU detected" "off"
