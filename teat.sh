#!/bin/bash

CONFIG_FILE="file_check_config.txt"
ALERT_LOG="./file_monitor.log"
EMAIL_RECIPIENTS="your_email@example.com"  # Replace this with your actual email
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

while IFS=',' read -r process_name file_pattern file_ext date_logic input_path frequency file_type expected_time; do
    # Clean up \r and whitespace
    process_name=$(echo "$process_name" | tr -d '\r' | xargs)
    file_pattern=$(echo "$file_pattern" | tr -d '\r' | xargs)
    file_ext=$(echo "$file_ext" | tr -d '\r' | xargs)
    date_logic=$(echo "$date_logic" | tr -d '\r' | xargs)
    input_path=$(echo "$input_path" | tr -d '\r' | xargs)
    frequency=$(echo "$frequency" | tr -d '\r' | xargs)
    file_type=$(echo "$file_type" | tr -d '\r' | xargs)
    expected_time=$(echo "$expected_time" | tr -d '\r' | xargs)

    if [[ "$process_name" == \#* ]] || [[ -z "$process_name" ]]; then
        continue
    fi

    # Date logic
    if [ "$frequency" = "monthly" ]; then
        DAY_OF_MONTH=$(date +%d)
        if [ "$DAY_OF_MONTH" -gt 3 ]; then
            echo "[$(date)] ⏭️ Skipping monthly check for [$process_name], outside 1st–3rd window."
            continue
        fi
        DATE_STR=$LAST_DAY_PREV_MONTH
    elif [ "$date_logic" = "same_day" ]; then
        DATE_STR=$TODAY
    else
        DATE_STR=$YESTERDAY
    fi

    EXPECTED_FILE="${file_pattern}${DATE_STR}${file_ext}"
    FILE_PATH="$input_path/$EXPECTED_FILE"

    if [[ "$CURRENT_TIME" > "$expected_time" ]]; then
        if [ ! -f "$FILE_PATH" ]; then
            MSG="[$(date)] ❌ ALERT: File not found for [$process_name] → Expected: $FILE_PATH before $expected_time"
            echo "$MSG" >> "$ALERT_LOG"
            echo "$MSG" | mail -s "Missing File Alert: $process_name" "$EMAIL_RECIPIENTS"
        elif [ ! -s "$FILE_PATH" ]; then
            MSG="[$(date)] ⚠️ ALERT: File [$FILE_PATH] is empty (0 bytes)"
            echo "$MSG" >> "$ALERT_LOG"
            echo "$MSG" | mail -s "Empty File Alert: $process_name" "$EMAIL_RECIPIENTS"
        else
            echo "[$(date)] ✅ OK: File exists and is not empty for [$process_name] → $FILE_PATH"
        fi
    else
        echo "[$(date)] ⏳ Waiting: Not yet time to check [$process_name] (Now: $CURRENT_TIME, Expected: $expected_time)"
    fi

done < "$CONFIG_FILE"