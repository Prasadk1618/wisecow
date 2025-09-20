#!/bin/bash

# Configuration
LOG_FILE="/var/log/nginx/access.log"
REPORT_FILE="$HOME/log_analyzer/log_report.txt"
TOP_N=5

# Check if log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Log file not found: $LOG_FILE"
    exit 1
fi

# Report header
echo "Web Server Log Analysis Report" > $REPORT_FILE
echo "Log File: $LOG_FILE" >> $REPORT_FILE
echo "Generated on: $(date)" >> $REPORT_FILE
echo "----------------------------------------" >> $REPORT_FILE

# Total requests
TOTAL_LINES=$(wc -l < "$LOG_FILE")
echo "Total Requests: $TOTAL_LINES" >> $REPORT_FILE

# Count 404 errors
ERROR_404=$(grep ' 404 ' "$LOG_FILE" | wc -l)
echo "Total 404 Errors: $ERROR_404" >> $REPORT_FILE

# Most requested pages
echo "" >> $REPORT_FILE
echo "Top $TOP_N Requested Pages:" >> $REPORT_FILE
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n $TOP_N >> $REPORT_FILE

# Top IP addresses
echo "" >> $REPORT_FILE
echo "Top $TOP_N IP Addresses:" >> $REPORT_FILE
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n $TOP_N >> $REPORT_FILE

echo "" >> $REPORT_FILE
echo "Report saved to $REPORT_FILE"
