#!/bin/bash

# ==========================================
# Server Performance Statistics Script
# Author: Amour Akowakou
# Description: Basic Linux server monitoring
# ==========================================

set -euo pipefail

# -------- Colors --------
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
NC="\e[0m"

# -------- Header --------
print_header() {
    clear
    echo -e "${BLUE}=========================================="
    echo -e " SERVER PERFORMANCE STATISTICS"
    echo -e "==========================================${NC}"
}

# -------- CPU Usage --------
get_cpu_usage() {
    echo -e "\n${YELLOW}CPU Usage:${NC}"
    if command -v mpstat &> /dev/null; then
        cpu_idle=$(mpstat 1 1 | awk '/Average/ {print 100 - $NF}' | cut -d'.' -f1)
    else
        # fallback si mpstat non dispo
        cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d'.' -f1)
        cpu_idle=$((100 - cpu_idle))
    fi
    echo " - Total CPU Used: ${cpu_idle}%"
}

# -------- Memory Usage --------
get_memory_usage() {
    echo -e "\n${YELLOW}Memory Usage:${NC}"
    if free_out=$(free -m 2>/dev/null); then
        read total used free_mem <<< $(echo "$free_out" | awk '/Mem:/ {print $2, $3, $4}')
        mem_percent=$((used * 100 / total))
        echo " - Used: ${used}MB / ${total}MB (${mem_percent}%)"
        echo " - Free: ${free_mem}MB"
    else
        echo "Unable to get memory usage"
    fi
}

# -------- Disk Usage --------
get_disk_usage() {
    echo -e "\n${YELLOW}Disk Usage (root /):${NC}"
    df -h / | awk 'NR==2 {print " - Used: "$3" / "$2" ("$5")"}'
}

# -------- Top Processes CPU --------
top_cpu_processes() {
    echo -e "\n${RED}Top 5 CPU consuming processes:${NC}"
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
}

# -------- Top Processes Memory --------
top_memory_processes() {
    echo -e "\n${RED}Top 5 Memory consuming processes:${NC}"
    ps -eo pid,comm,%mem --sort=-%mem | head -n 6
}

# -------- Extra System Info --------
extra_stats() {
    echo -e "\n${GREEN}Additional System Info:${NC}"
    if [ -f /etc/os-release ]; then
        os_name=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')
        echo " - OS       : $os_name"
    fi
    echo " - Kernel   : $(uname -r)"
    echo " - Uptime   : $(uptime -p)"
    echo " - Load Avg : $(uptime | awk -F'load average:' '{print $2}')"
    echo " - Users    : $(who | wc -l)"
}

# -------- Main --------
main() {
    print_header
    get_cpu_usage
    get_memory_usage
    get_disk_usage
    top_cpu_processes
    top_memory_processes
    extra_stats
}

main
