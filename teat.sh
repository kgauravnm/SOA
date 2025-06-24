#!/bin/bash

CONFIG_FILE="file_check_config.txt"
ALERT_LOG="./file_monitor.log"
EMAIL_RECIPIENTS="your_email@example.com"   # ← change to one or more addresses
CURRENT_TIME=$(date +%H:%M)
TODAY=$(date +%Y%m%d)

# Work out logical “yesterday”
dow=$(date +%u)
if [ "$dow" -eq 1 ]; then
    YESTERDAY=$(date -d "3 days ago" +%Y%m%d)   # Monday ⇒ Friday
else
    YESTERDAY=$(date -d "yesterday" +%Y%m%d)
fi

# Last day of previous month
LAST_DAY_PREV_MONTH=$(date -d "$(date +%Y-%m-01) -1 day" +%Y%m%d)

############ 1) — start HTML report ############
html_head='<html><head><style>
body   {font-family:Arial,Helvetica,sans-serif;background:#fafafa;color:#333;}
h2     {color:#d32f2f;margin-bottom:6px;}
table  {border-collapse:collapse;width:100%;margin-top:10px;font-size:14px;}
th,td  {border:1px solid #ddd;padding:8px;text-align:left;}
th     {background:#4caf50;color:#fff;}
tr:nth-child(even){background:#f5f5f5;}
td.status-nok{background:#f44336;color:#fff;font-weight:bold;text-align:center;}
</style></head><body>'
html_title="<h2>🚨 File Monitoring Alert Report</h2><p>Generated at $(date '+%Y-%m-%d %H:%M')</p>"
html_table="<table><tr><th>Process Name</th><th>Expected File</th><th>File Path</th><th>Expected Time</th><th>Status</th></tr>"
alert_found=false
################################################

while IFS=',' read -r process_name file_pattern file_ext date_logic input_path frequency file_type expected_time; do
    # Strip CR + spaces
    for v in process_name file_pattern file_ext date_logic input_path frequency file_type expected_time; do
        declare "$v"="$(echo "${!v}" | tr -d '\r' | xargs)"
    done

    [[ "$process_name" == \#* || -z "$process_name" ]] && continue
    freq_lower=$(echo "$frequency" | tr '[:upper:]' '[:lower:]')

    # Decide expected date
    if [[ $freq_lower == "monthly" ]]; then
        [[ $(date +%d) -gt 3 ]] && continue               # skip after 3rd
        DATE_STR=$LAST_DAY_PREV_MONTH
    elif [[ $date_logic == "same_day" ]]; then
        DATE_STR=$TODAY
    else
        DATE_STR=$YESTERDAY
    fi

    EXPECTED_FILE="${file_pattern}${DATE_STR}${file_ext}"
    FILE_PATH="$input_path/$EXPECTED_FILE"

    if [[ "$CURRENT_TIME" > "$expected_time" ]]; then
        if [[ ! -f "$FILE_PATH" ]]; then
            MSG="[$(date)] ❌ Missing: $FILE_PATH"
            echo "$MSG" | tee -a "$ALERT_LOG"
            html_table+="<tr><td>$process_name</td><td>$EXPECTED_FILE</td><td>$FILE_PATH</td><td>$expected_time</td><td class='status-nok'>NOK – Missing</td></tr>"
            alert_found=true
        elif [[ ! -s "$FILE_PATH" && "$file_ext" != ".tok" ]]; then
            MSG="[$(date)] ⚠️ Empty: $FILE_PATH"
            echo "$MSG" | tee -a "$ALERT_LOG"
            html_table+="<tr><td>$process_name</td><td>$EXPECTED_FILE</td><td>$FILE_PATH</td><td>$expected_time</td><td class='status-nok'>NOK – Empty</td></tr>"
            alert_found=true
        fi
    fi
done < "$CONFIG_FILE"

############ 2) — send email if any NOK ############
if $alert_found; then
    html_body="$html_head$html_title$html_table</table></body></html>"
    echo "$html_body" | mail -a "Content-Type: text/html" \
                        -s "🚨 File Monitoring Alert Report (NOK)" \
                        "$EMAIL_RECIPIENTS"
fi
####################################################