if [ "$freq_lower" = "monthly" ]; then
    DAY_OF_MONTH=$(date +%d)
    if [ "$DAY_OF_MONTH" -gt 3 ]; then
        echo "[$(date)] ⏭️ Skipping monthly check for [$process_name], outside 1st–3rd window." | tee -a "$ALERT_LOG"
        continue
    fi
    DATE_STR=$LAST_DAY_PREV_MONTH

elif [ "$freq_lower" = "weekly" ]; then
    current_day=$(date +%u)  # 5 = Friday
    if [ "$current_day" -ne 5 ]; then
        echo "[$(date)] ⏭️ Skipping weekly check for [$process_name], today is not Friday." | tee -a "$ALERT_LOG"
        continue
    fi
    DATE_STR=$TODAY

elif [ "$date_logic" = "same_day" ]; then
    DATE_STR=$TODAY

else
    DATE_STR=$YESTERDAY
fi