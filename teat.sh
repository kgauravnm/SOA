#!/bin/bash

CONFIG_FILE="file_check_config.txt"
ALERT_LOG="./file_monitor.log"
CURRENT_TIME=$(date +%H:%M)
TODAY=$(date +%Y%m%d)

# Handle logical 'yesterday' considering Monday
dow=$(date +%u)
if [ "$dow" -eq 1 ]; then
    YESTERDAY=$(date -d "3 days ago" +%Y%m%d)
else
    YESTERDAY=$(date -d "yesterday" +%Y%m%d)
fi

# Last day of previous month
LAST_DAY_PREV_MONTH=$(date -d "$(date +%Y-%m-01) -1 day" +%Y%m%d)

while IFS='|' read -r process_name file_pattern file_ext input_path frequency file_type expected_time; do
    [[ "$process_name" =~ ^#.*$ || -z "$process_name" ]] && continue

    # Convert frequency to lowercase
    frequency=$(echo "$frequency" | tr '[:upper:]' '[:lower:]')

    # Determine expected date string based on frequency
    case "$frequency" in
        d)
            DATE_STR=$TODAY
            ;;
        d1)
            DATE_STR=$YESTERDAY
            ;;
        dm1)
            DAY_OF_MONTH=$(date +%d)
            if [ "$DAY_OF_MONTH" -gt 3 ]; then
                echo "[$(date)] ⏭️ Skipping [$process_name]: dm1 check only valid from 1st to 3rd" >> "$ALERT_LOG"
                continue
            fi
            DATE_STR=$LAST_DAY_PREV_MONTH
            ;;
        *)
            echo "[$(date)] ⚠️ Unknown frequency [$frequency] for process [$process_name]" >> "$ALERT_LOG"
            continue
            ;;
    esac

    EXPECTED_FILE="${file_pattern}${DATE_STR}${file_ext}"
    FILE_PATH="$input_path/$EXPECTED_FILE"

    if [[ "$CURRENT_TIME" > "$expected_time" ]]; then
        if [ ! -f "$FILE_PATH" ]; then
            echo "[$(date)] ❌ ALERT: File not found for [$process_name] → Expected: $FILE_PATH before $expected_time" >> "$ALERT_LOG"
        elif [ ! -s "$FILE_PATH" ]; then
            echo "[$(date)] ⚠️ ALERT: File [$FILE_PATH] is empty (0 bytes)" >> "$ALERT_LOG"
        else
            echo "[$(date)] ✅ OK: File exists and is not empty for [$process_name] → $FILE_PATH"
        fi
    else
        echo "[$(date)] ⏳ Waiting: Not yet time to check [$process_name] (Now: $CURRENT_TIME, Expected: $expected_time)"
    fi

done < "$CONFIG_FILE"
