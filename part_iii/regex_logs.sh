#!/bin/bash

# Directory to search for log files
LOG_DIRECTORY="/var/log"

# Temporary file to store unique, masked IP addresses
TEMP_FILE="/tmp/masked_ips.txt"

# Empty the temporary file
> "$TEMP_FILE"

# Process each log file in the directory
for log_file in "$LOG_DIRECTORY"/*; do
    if [ -f "$log_file" ]; then
        echo "Processing: $log_file"
        # Search for IP addresses, mask them, and save unique IPs to temporary file
        grep -oP '(?<=\s|^)(\d{1,3}\.){3}\d{1,3}(?=\s|$)' "$log_file" | sed 's/\([0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\)\.[0-9]\{1,3\}/\1.XXX/g' | sort -u >> "$TEMP_FILE"
    fi
done

# Provide a summary of unique masked IPs per file
if [ -s "$TEMP_FILE" ]; then
    echo "Unique Masked IPs:"
    sort "$TEMP_FILE" | uniq -c | sort -nr
else
    echo "No IP addresses found."
fi

# Clean up
rm -f "$TEMP_FILE"