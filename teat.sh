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

while IFS='|' read -r process_name file_pattern file_ext date_logic input_path frequency file_type expected_time; do
    # Skip blank lines or comment lines
    if [[ "$process_name" == \#* ]] || [[ -z "$process_name" ]]; then
        continue
    fi

    date_logic=$(echo "$date_logic" | tr -d '\r' | tr '[:upper:]' '[:lower:]' | xargs)

    case "$date_logic" in
        same_day)
            DATE_STR=$TODAY
            ;;
        previous_day)
            DATE_STR=$YESTERDAY
            ;;
        last_day_prev_month)
            DAY_OF_MONTH=$(date +%d)
            if [ "$DAY_OF_MONTH" -gt 3 ]; then
                echo "[$(date)] â­ï¸ Skipping [$process_name]: last_day_prev_month only checked between 1stâ3rd" >> "$ALERT_LOG"
                continue
            fi
            DATE_STR=$LAST_DAY_PREV_MONTH
            ;;
        *)
            echo "[$(date)] â ï¸ Unknown date_logic [$date_logic] for process [$process_name]" >> "$ALERT_LOG"
            continue
            ;;
    esac

    EXPECTED_FILE="${file_pattern}${DATE_STR}${file_ext}"
    FILE_PATH="$input_path/$EXPECTED_FILE"

    if [[ "$CURRENT_TIME" > "$expected_time" ]]; then
        if [ ! -f "$FILE_PATH" ]; then
            echo "[$(date)] â ALERT: File not found for [$process_name] â Expected: $FILE_PATH before $expected_time" >> "$ALERT_LOG"
        elif [ ! -s "$FILE_PATH" ]; then
            echo "[$(date)] â ï¸ ALERT: File [$FILE_PATH] is empty (0 bytes)" >> "$ALERT_LOG"
        else
            echo "[$(date)] â OK: File exists and is not empty for [$process_name] â $FILE_PATH"
        fi
    else
        echo "[$(date)] â³ Waiting: Not yet time to check [$process_name] (Now: $CURRENT_TIME, Expected: $expected_time)"
    fi

done < "$CONFIG_FILE"
