#!/bin/bash

CONFIG_FILE="file_check_config.txt"
ALERT_LOG="./file_monitor.log"
EMAIL_RECIPIENTS="your_email@example.com"  # Replace with your actual email

# 🔄 Changed: Updated CURRENT_TIME handling (removes leading 0s for numeric compare)
CURRENT_TIME=$(date +%H%M | sed 's/^0*//')
TODAY_YMD=$(date +%Y-%m-%d)

# ➕ Added: Weekend-aware logic for consistent file date (D-1/D-2/D-3 logic)
DOW=$(date +%u)  # 1=Mon, 7=Sun
if [ "$DOW" -eq 6 ]; then       # Saturday
    DATE_TO_CHECK=$(date -d "1 day ago" +%Y%m%d)  # Friday
elif [ "$DOW" -eq 7 ]; then     # Sunday
    DATE_TO_CHECK=$(date -d "2 days ago" +%Y%m%d)  # Friday
elif [ "$DOW" -eq 1 ]; then     # Monday
    DATE_TO_CHECK=$(date -d "3 days ago" +%Y%m%d)  # Friday
else
    DATE_TO_CHECK=$(date +%Y%m%d)  # Tue–Fri → today
fi

# ➕ Added: Fallback to keep existing YESTERDAY variable if needed elsewhere
: "${YESTERDAY:=$(date -d "yesterday" +%Y%m%d)}"

# ✅ No change: Monthly last date logic
LAST_DAY_PREV_MONTH=$(date -d "$(date +%Y-%m-01) -1 day" +%Y%m%d)

# ✅ No change: Build working days array for M1/M2/M3 support
working_days=()
for i in {0..6}; do
    d=$(date -d "$(date +%Y-%m-01) +$i days" +%Y-%m-%d)
    dow_iter=$(date -d "$d" +%u)
    [ "$dow_iter" -lt 6 ] && working_days+=("$d")
done

# ✅ Email + Table style (unchanged except for table color)
html_head='<html><head><style>
body { font-family: Arial; background: #fafafa; color: #333; }
table { border-collapse: collapse; width: 100%; font-size: 14px; }
th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
th { background: #d2b48c; color: white; }
tr:nth-child(even) { background: #f2f2f2; }
td.status-nok {
  background: #f44336; color: white; text-align: center; font-weight: bold;
  box-shadow: 0 0 8px #f44336; animation: pulse 2s infinite;
}
@keyframes pulse {
  0% { box-shadow: 0 0 5px #f44336; }
  50% { box-shadow: 0 0 15px #f44336; }
  100% { box-shadow: 0 0 5px #f44336; }
}
</style></head><body>'
html_title="<h3>🚨 File Monitoring Alert Report – $(date)</h3>"
html_table="<table><tr><th>Process Name</th><th>Expected File</th><th>File Path</th><th>Expected Time</th><th>Status</th></tr>"
alert_found=false

# ✅ Main check loop
while IFS=',' read -r process_name file_pattern file_ext date_logic input_path frequency file_type expected_time date_to_check; do
    # ✅ Standard cleanup
    process_name=$(echo "$process_name" | tr -d '\r' | xargs)
    file_pattern=$(echo "$file_pattern" | tr -d '\r' | xargs)
    file_ext=$(echo "$file_ext" | tr -d '\r' | xargs)
    date_logic=$(echo "$date_logic" | tr -d '\r' | xargs)
    input_path=$(echo "$input_path" | tr -d '\r' | xargs)
    frequency=$(echo "$frequency" | tr -d '\r' | xargs)
    file_type=$(echo "$file_type" | tr -d '\r' | xargs)
    expected_time=$(echo "$expected_time" | tr -d '\r' | sed 's/[^0-9]//g' | sed 's/^0*//')
    date_to_check=$(echo "$date_to_check" | tr -d '\r' | xargs)

    [[ "$process_name" == \#* || -z "$process_name" ]] && continue
    freq_lower=$(echo "$frequency" | tr '[:upper:]' '[:lower:]')

    # ✅ Monthly check (unchanged)
    if [[ "$freq_lower" == "monthly" ]]; then
        case "$date_to_check" in
            M1) [[ "$TODAY_YMD" != "${working_days[0]}" ]] && echo "[$(date)] ⏭️ Skip [$process_name] – not M1" >> "$ALERT_LOG" && continue ;;
            M2) [[ "$TODAY_YMD" != "${working_days[1]}" ]] && echo "[$(date)] ⏭️ Skip [$process_name] – not M2" >> "$ALERT_LOG" && continue ;;
            M3) [[ "$TODAY_YMD" != "${working_days[2]}" ]] && echo "[$(date)] ⏭️ Skip [$process_name] – not M3" >> "$ALERT_LOG" && continue ;;
            *) echo "[$(date)] ⚠️ Invalid date_to_check: $date_to_check for [$process_name]" >> "$ALERT_LOG"; continue ;;
        esac
        DATE_STR=$LAST_DAY_PREV_MONTH

    else
        # 🔄 CHANGED: Unified same_day/previous_day logic
        DATE_STR=$DATE_TO_CHECK
    fi

    # ✅ File checks (no change)
    EXPECTED_FILE="${file_pattern}${DATE_STR}${file_ext}"
    FILE_PATH="$input_path/$EXPECTED_FILE"

    if [ "$CURRENT_TIME" -gt "$expected_time" ]; then
        if [ ! -f "$FILE_PATH" ]; then
            MSG="[$(date)] ❌ ALERT: File not found – $FILE_PATH"
            echo "$MSG" | tee -a "$ALERT_LOG"
            html_table+="<tr><td>$process_name</td><td>$EXPECTED_FILE</td><td>$FILE_PATH</td><td>$expected_time</td><td class='status-nok'>NOK – Missing</td></tr>"
            alert_found=true
        elif [ ! -s "$FILE_PATH" ]; then
            if [[ "$file_ext" != ".tok" ]]; then
                MSG="[$(date)] ⚠️ ALERT: Empty file – $FILE_PATH"
                echo "$MSG" | tee -a "$ALERT_LOG"
                html_table+="<tr><td>$process_name</td><td>$EXPECTED_FILE</td><td>$FILE_PATH</td><td>$expected_time</td><td class='status-nok'>NOK – Empty</td></tr>"
                alert_found=true
            else
                echo "[$(date)] ✅ Note: .tok file is empty but expected → $FILE_PATH" >> "$ALERT_LOG"
            fi
        else
            echo "[$(date)] ✅ OK: File present → $FILE_PATH" >> "$ALERT_LOG"
        fi
    else
        echo "[$(date)] ⏳ Too early to check [$process_name] (Now=$CURRENT_TIME, Expected=$expected_time)" >> "$ALERT_LOG"
    fi

done < "$CONFIG_FILE"

# ✅ Email sending section (unchanged)
if $alert_found; then
    html_full="$html_head$html_title$html_table</table></body></html>"
    (
    echo "To: $EMAIL_RECIPIENTS"
    echo "Subject: 🚨 File Monitoring Alert Summary"
    echo "MIME-Version: 1.0"
    echo "Content-Type: text/html"
    echo
    echo "$html_full"
    ) | sendmail -t
    echo "[$(date)] 📧 Alert sent to $EMAIL_RECIPIENTS" | tee -a "$ALERT_LOG"
else
    echo "[$(date)] ✅ No alerts. All good." | tee -a "$ALERT_LOG"
fi


elif [ "$date_logic" = "same_day" ] && { [ "$(date +%u)" -eq 6 ] || [ "$(date +%u)" -eq 7 ]; }; then
    echo "[$(date)] ⏭️ Skipping same_day check on weekend for [$process_name]" | tee -a "$ALERT_LOG"
    continue
elif [ "$date_logic" = "same_day" ]; then
    DATE_STR=$TODAY

