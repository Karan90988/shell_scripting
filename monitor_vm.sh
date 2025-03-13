#!/bin/bash
#healthy and not healthy vm ec2 
# Function to get the current CPU usage
get_cpu_usage() {
  top -bn1 | grep "Cpu(s)" | \
  sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
  awk '{print 100 - $1}'
}

# Function to get the current memory usage
get_memory_usage() {
  free | grep Mem | awk '{print $3/$2 * 100.0}'
}

# Function to get the current disk usage
get_disk_usage() {
  df / | grep / | awk '{print $5}' | sed 's/%//g'
}

CPU_USAGE=$(get_cpu_usage)
MEMORY_USAGE=$(get_memory_usage)
DISK_USAGE=$(get_disk_usage)

# Function to determine health status
determine_health_status() {
  if (( $(echo "$CPU_USAGE > 60" | bc -l) )) || \
     (( $(echo "$MEMORY_USAGE > 60" | bc -l) )) || \
     (( $(echo "$DISK_USAGE > 60" | bc -l) )); then
    echo "Unhealthy"
  else
    echo "Healthy"
  fi
}

# Function to explain health status
explain_health_status() {
  echo "CPU Usage: ${CPU_USAGE}%"
  echo "Memory Usage: ${MEMORY_USAGE}%"
  echo "Disk Usage: ${DISK_USAGE}%"
  echo "Health Status: $(determine_health_status)"
}

# Main script execution
if [ "$1" == "explain" ]; then
  explain_health_status
else
  determine_health_status
fi
