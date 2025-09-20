## 3. Log File Analyzer:  
Create a script that analyzes web server logs (e.g., Apache, Nginx) for 
common patterns such as the number of 404 errors, the most requested 
pages, or IP addresses with the most requests. The script should output a 
summarized report.

# Web Server Log File Analyzer

## Description
This is a **Bash script** to analyze web server logs (Nginx ) and generate a summarized report.  
It identifies common patterns such as:
- Number of 404 errors
- Most requested pages
- IP addresses with the most requests

The script outputs a **report file** with a clear summary of the log analysis.

---

## Features
- Count total requests
- Count total 404 errors
- Find top requested pages
- Find top IP addresses
- Generates a summarized report
- Can be automated using cron

---

## Prerequisites
- Ubuntu or Linux server
- Bash shell
- Web server logs (e.g., `/var/log/nginx/access.log` or `/var/log/apache2/access.log`)

Install Nginx to generate logs for testing:
```bash
sudo apt update
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

Setup

Create a folder for script and reports:
```bash
mkdir -p ~/log_analyzer
```

Create sample log file (for testing):
```bash
mkdir -p ~/test_logs
cat <<EOL > ~/test_logs/access.log
192.168.1.10 - - [20/Sep/2025:15:00:01 +0530] "GET /index.html HTTP/1.1" 200 1024
192.168.1.11 - - [20/Sep/2025:15:00:02 +0530] "GET /about.html HTTP/1.1" 404 512
192.168.1.10 - - [20/Sep/2025:15:00:03 +0530] "GET /contact.html HTTP/1.1" 200 256
192.168.1.12 - - [20/Sep/2025:15:00:04 +0530] "GET /index.html HTTP/1.1" 200 1024
192.168.1.11 - - [20/Sep/2025:15:00:05 +0530] "GET /index.html HTTP/1.1" 404 1024
EOL
```

Create the script:
```bash
nano ~/log_analyzer/log_analyzer.sh
```

Paste this code:
```bash
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
```
Make script executable:
```bash
chmod +x ~/log_analyzer/log_analyzer.sh
```
Usage

Run the script manually:
```bash
~/log_analyzer/log_analyzer.sh
```

Check the generated report:
```bash
cat ~/log_analyzer/log_report.txt
```
Sample Output
Web Server Log Analysis Report
Log File: /home/ubuntu/test_logs/access.log
Generated on: 2025-09-20 16:30:00
----------------------------------------
```bash
ubuntu@ip-172-31-26-18:~$ cat ~/log_analyzer/log_report.txt
Web Server Log Analysis Report
LWeb Server Log Analysis Report
Log File: /var/log/nginx/access.log
Generated on: Sat Sep 20 10:42:40 UTC 2025
----------------------------------------
Total Requests: 0
Total 404 Errors: 0

Top 5 Requested Pages:

Top 5 IP Addresses:
```

Automation with Cron

To run daily at 1:00 AM:
```bash
crontab -e
```

Add:
```bash
0 1 * * * /home/ubuntu/log_analyzer/log_analyzer.sh
```
