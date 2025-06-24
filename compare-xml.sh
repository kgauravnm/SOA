#!/bin/bash

CONFIG_FILE="file_check_config.txt"
echo "Running File Monitor Simulation"

# Simulate today for testing purposes
today="2024-07-02"  # 👈 Change this to simulate different dates
working_days=()

# Build list of first 3 working days of the month
for i in {0..6}; do
    d=$(date -d "$(date +%Y-%m-01) +$i days" +%Y-%m-%d)
    dow=$(date -d "$d" +%u)
    [ "$dow" -lt 6 ] && working_days+=("$d")
done

echo "Working days this month: ${working_days[@]}"
echo "Simulated Today: $today"
echo

while IFS=',' read -r process_name file_pattern file_ext date_logic input_path frequency file_type expected_time date_to_check; do
    process_name=$(echo "$process_name" | xargs)
    [ "$process_name" == "" ] && continue

    case "$date_to_check" in
        M1)
            if [ "$today" != "${working_days[0]}" ]; then
                echo "⏭️ Skipping [$process_name] – not M1 working day"
                continue
            fi
            ;;
        M2)
            if [ "$today" != "${working_days[1]}" ]; then
                echo "⏭️ Skipping [$process_name] – not M2 working day"
                continue
            fi
            ;;
        M3)
            if [ "$today" != "${working_days[2]}" ]; then
                echo "⏭️ Skipping [$process_name] – not M3 working day"
                continue
            fi
            ;;
        *)
            echo "⚠️ Invalid date_to_check [$date_to_check] for [$process_name]"
            continue
            ;;
    esac

    echo "✅ [$process_name] scheduled to be checked today ($today)"
done < "$CONFIG_FILE"