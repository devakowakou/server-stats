#!/bin/bash

# ==========================================
# Server Performance Statistics Script
# Author: Amour Akowakou
# Description: Linux server monitoring with alerts and JSON output
# ==========================================

set -euo pipefail

# -------- Default Config --------
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80
OUTPUT_FORMAT="text"   # text | json
NO_COLOR=false

# -------- Colors --------
if [ "$NO_COLOR" = false ]; then
  RED="\e[31m"
  GREEN="\e[32m"
  YELLOW="\e[33m"
  BLUE="\e[34m"
  NC="\e[0m"
else
  RED=""; GREEN=""; YELLOW=""; BLUE=""; NC=""
fi

# -------- CLI Args --------
show_help() {
  echo "Usage: ./server-stats.sh [options]"
  echo ""
  echo "Options:"
  echo "  --json            Output in JSON format"
  echo "  --no-color        Disable colored output"
  echo "  --cpu N           CPU alert threshold (default 80)"
  echo "  --mem N           Memory alert threshold (default 80)"
  echo "  --disk N          Disk alert threshold (default 80)"
  echo "  -h, --help        Show this help"
}

while [[ $# -gt 0 ]]; do
  case $1 in
    --json) OUTPUT_FORMAT="json"; shift ;;
    --no-color) NO_COLOR=true; shift ;;
    --cpu) CPU_THRESHOLD="$2"; shift 2 ;;
    --mem) MEM_THRESHOLD="$2"; shift 2 ;;
    --disk) DISK_THRESHOLD="$2"; shift 2 ;;
    -h|--help) show_help; exit 0 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
 done

# -------- Metrics --------
get_cpu() {
  cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d'.' -f1)
  echo $((100 - cpu_idle))
}

get_mem() {
  read total used <<< $(free -m | awk '/Mem:/ {print $2, $3}')
  echo $((used * 100 / total))
}

get_disk() {
  df / | awk 'NR==2 {gsub(/%/,"",$5); print $5}'
}

alert_check() {
  local value=$1
  local threshold=$2
  if [ "$value" -ge "$threshold" ]; then
    echo "${RED}ALERT${NC}"
  else
    echo "${GREEN}OK${NC}"
  fi
}

# -------- TEXT OUTPUT --------
output_text() {
  clear
  echo -e "${BLUE}=========================================="
  echo -e " SERVER PERFORMANCE STATISTICS"
  echo -e "==========================================${NC}"

  CPU=$(get_cpu)
  MEM=$(get_mem)
  DISK=$(get_disk)

  echo -e "\n${YELLOW}CPU:${NC} $CPU% ($(alert_check $CPU $CPU_THRESHOLD))"
  echo -e "${YELLOW}Memory:${NC} $MEM% ($(alert_check $MEM $MEM_THRESHOLD))"
  echo -e "${YELLOW}Disk:${NC} $DISK% ($(alert_check $DISK $DISK_THRESHOLD))"

  echo -e "\nTop 5 CPU consuming processes:"
  ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

  echo -e "\nTop 5 Memory consuming processes:"
  ps -eo pid,comm,%mem --sort=-%mem | head -n 6

  echo -e "\nSystem Info:"
  echo " OS      : $(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')"
  echo " Kernel  : $(uname -r)"
  echo " Uptime  : $(uptime -p)"
  echo " LoadAvg : $(uptime | awk -F'load average:' '{print $2}')"
}

# -------- JSON OUTPUT --------
output_json() {
  CPU=$(get_cpu)
  MEM=$(get_mem)
  DISK=$(get_disk)

  cat <<EOF
{
  "cpu": {"usage": $CPU, "threshold": $CPU_THRESHOLD},
  "memory": {"usage": $MEM, "threshold": $MEM_THRESHOLD},
  "disk": {"usage": $DISK, "threshold": $DISK_THRESHOLD},
  "system": {
    "os": "$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')",
    "kernel": "$(uname -r)",
    "uptime": "$(uptime -p)",
    "load_avg": "$(uptime | awk -F'load average:' '{print $2}')"
  }
}
EOF
}

# -------- Main --------
if [ "$OUTPUT_FORMAT" = "json" ]; then
  output_json
else
  output_text
fi
