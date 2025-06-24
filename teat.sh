#!/bin/bash

CONFIG_FILE="file_check_config.txt"
ALERT_LOG="./file_monitor.log"
EMAIL_RECIPIENTS="your_email@example.com"  # Replace with your actual email
CURRENT_TIME=$(date +%H:%M)
TODAY=$(date +%Y%m%d)

# Handle Monday: use Friday as "yesterday"
dow=$(date +%u)
if [ "$dow" -eq 1 ]; then
    YESTERDAY=$(date -d "3 days ago" +%Y%m%d)
else
    YESTERDAY=$(date -d "yesterday" +%Y%m%d)
fi

# Last day of previous month
LAST_DAY_PREV_MONTH=$(date -d "$(date +%Y-%m-01) -1 day" +%Y%m%d)

# HTML email setup
html_head='<html><head><style>
body {
  font-family: Arial, sans-serif;
  background: #fafafa;
  color: #333;
}
table {
  border-collapse: collapse;
  width: 100%;
  font-size: 14px;
}
th, td {
  border: 1px solid #ccc;
  padding: 8px;
  text-align: left;
}
th {
  background: #d2b48c;
  color: white;
}
tr:nth-child(even) {
  background: #f2f2f2;
}
td.status-nok {
  background: #f44336;
  color: white;
  text-align: center;
  font-weight: bold;
  box-shadow: 0 0 8px #f44336;
  animation: pulse 2s infinite;
}
@keyframes pulse {
  0%   { box-shadow: 0 0 5px #f44336; }
  50%  { box-shadow: 0 0 15px #f44336; }
  100% { box-shadow: 0 0 5px #f44336; }
}
</style></head><body>'
html_title="<h3>🚨 File Monitoring Alert Report – $(date)</h3>"
html_table="<table><tr><th>Process Name</th><th>Expected File</th><th>File Path</th><th>Expected Time</th><th>Status</th></tr>"
alert_found=false

while IFS=',' read -r process_name file_pattern file_ext date_logic input_path frequency file_type expected_time date_to_check; do
    # Clean up \r and whitespace
    process_name=$(echo "$process_name" | tr -d '\r' | xargs)
    file_pattern=$(echo "$file_pattern" | tr -d '\r' | xargs)
    file_ext=$(echo "$file_ext" | tr -d '\r' | xargs)
    date_logic=$(echo "$date_logic" | tr -d '\r' | xargs)
    input_path=$(echo "$input_path" | tr -d '\r' | xargs)
    frequency=$(echo "$frequency" | tr -d '\r' | xargs)
    file_type=$(echo "$file_type" | tr -d '\r' | xargs)
    expected_time=$(echo "$expected_time" | tr -d '\r' | xargs)
    date_to_check=$(echo "$date_to_check" | tr -d '\r' | xargs)

    # Convert frequency to lowercase
    freq_lower=$(echo "$frequency" | tr '[:upper:]' '[:lower:]')

    # Skip commented or empty lines
    if [[ "$process_name" == \#* ]] || [[ -z "$process_name" ]]; then
        continue
    fi

    # Handle date logic
    if [ "$freq_lower" = "monthly" ]; then
        # Build working days (excluding Sat/Sun) from 1st of month
        working_days=()
        for i in {0..6}; do
            d=$(date -d "$(date +%Y-%m-01) +$i days" +%Y-%m-%d)
            dow=$(date -d "$d" +%u)
            [ "$dow" -lt 6 ] && working_days+=("$d")
        done

        today=$(date +%Y-%m-%d)
        case "$date_to_check" in
            M1) [ "$today" != "${working_days[0]}" ] && echo "[$(date)] ⏭️ Skipping [$process_name] – not M1 working day" | tee -a "$ALERT_LOG" && continue ;;
            M2) [ "$today" != "${working_days[1]}" ] && echo "[$(date)] ⏭️ Skipping [$process_name] – not M2 working day" | tee -a "$ALERT_LOG" && continue ;;
            M3) [ "$today" != "${working_days[2]}" ] && echo "[$(date)] ⏭️ Skipping [$process_name] – not M3 working day" | tee -a "$ALERT_LOG" && continue ;;
            *) echo "[$(date)] ⚠️ Invalid or missing date_to_check [$date_to_check] for [$process_name]" | tee -a "$ALERT_LOG" && continue ;;
        esac

        DATE_STR=$LAST_DAY_PREV_MONTH
    elif [ "$date_logic" = "same_day" ]; then
        DATE_STR=$TODAY
    else
        DATE_STR=$YESTERDAY
    fi

    EXPECTED_FILE="${file_pattern}${DATE_STR}${file_ext}"
    FILE_PATH="$input_path/$EXPECTED_FILE"
    safe_path=$(echo "$FILE_PATH" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')

    if [[ "$CURRENT_TIME" > "$expected_time" ]]; then
        if [ ! -f "$FILE_PATH" ]; then
            MSG="[$(date)] ❌ ALERT: File not found for [$process_name] → Expected: $FILE_PATH before $expected_time"
            echo "$MSG" | tee -a "$ALERT_LOG"
            html_table+="<tr><td>$process_name</td><td>$EXPECTED_FILE</td><td>$safe_path</td><td>$expected_time</td><td class='status-nok'>NOK – Missing</td></tr>"
            alert_found=true
        elif [ ! -s "$FILE_PATH" ]; then
            if [[ "$file_ext" != ".tok" ]]; then
                MSG="[$(date)] ⚠️ ALERT: File [$FILE_PATH] is empty (0 bytes)"
                echo "$MSG" | tee -a "$ALERT_LOG"
                html_table+="<tr><td>$process_name</td><td>$EXPECTED_FILE</td><td>$safe_path</td><td>$expected_time</td><td class='status-nok'>NOK – Empty</td></tr>"
                alert_found=true
            else
                echo "[$(date)] ✅ Note: Empty .tok file [$FILE_PATH] is expected. Skipping empty check." | tee -a "$ALERT_LOG"
            fi
        else
            echo "[$(date)] ✅ OK: File exists and is not empty for [$process_name] → $FILE_PATH" | tee -a "$ALERT_LOG"
        fi
    else
        echo "[$(date)] ⏳ Waiting: Not yet time to check [$process_name] (Now: $CURRENT_TIME, Expected: $expected_time)" | tee -a "$ALERT_LOG"
    fi
done < "$CONFIG_FILE"

# Send HTML email alert if any issue
if $alert_found; then
    html_full="$html_head$html_title$html_table</table></body></html>"
    (
    echo "To: $EMAIL_RECIPIENTS"
    echo "Subject: 🚨 File Monitoring Alert Summary"
    echo "MIME-Version: 1.0"
    echo "Content-Type: text/html"
    echo ""
    echo "$html_full"
    ) | sendmail -t
    echo "[$(date)] 📧 HTML alert sent to $EMAIL_RECIPIENTS" | tee -a "$ALERT_LOG"
else
    echo "[$(date)] ✅ No alerts to send. All files OK or not yet time." | tee -a "$ALERT_LOG"
fi