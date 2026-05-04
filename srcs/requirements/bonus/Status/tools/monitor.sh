#!/bin/bash

DISCORD_WEBHOOK="${DISCORD_WEBHOOK_URL}"
STATUS_FILE="/var/www/status/status.json"

declare -A SERVICES
SERVICES=(
	["mariadb"]="mariadb:3306"
	["wordpress"]="wordpress:9000"
	["nginx"]="nginx:443"
	["redis"]="redis:6379"
	["adminer"]="adminer:9001"
	["ftp"]="ftp:21"
)

declare -A PREV_STATUS

send_discord() {
	local message="$1"
	local color="$2"

	curl -s -X POST "$DISCORD_WEBHOOK" \
		-H "Content-Type: application/json" \
		-d "{
			\"embeds\": [{
				\"title\": \"🖥️ Inception Monitor\",
				\"description\": \"$message\",
				\"color\": $color,
				\"footer\": { \"text\": \"tarini.42.fr\" },
				\"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"
			}]
		}"
}

check_port() {
	local host="$1"
	local port="$2"
	nc -z -w2 "$host" "$port" 2>/dev/null
	return $?
}

check_services() {
	local timestamp
	timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
	local json="{\"updated\":\"$timestamp\",\"services\":{"
	local first=true

	for service in "${!SERVICES[@]}"; do
		local addr="${SERVICES[$service]}"
		local host="${addr%%:*}"
		local port="${addr##*:}"

		if check_port "$host" "$port"; then
			status="up"
		else
			status="down"
		fi

		echo "[$(date +%H:%M:%S)] $service → $status (prev: ${PREV_STATUS[$service]:-none})"

		if [ -n "${PREV_STATUS[$service]}" ] && [ "${PREV_STATUS[$service]}" != "$status" ]; then
			if [ "$status" = "down" ]; then
				echo "Sending DOWN alert for $service..."
				send_discord "🔴 **$service** is DOWN" "15158332"
			else
				echo "Sending UP alert for $service..."
				send_discord "🟢 **$service** is back UP" "3066993"
			fi
		fi

		PREV_STATUS[$service]=$status

		if [ "$first" = true ]; then
			first=false
		else
			json+=","
		fi
		json+="\"$service\":{\"status\":\"$status\",\"host\":\"$host\",\"port\":$port}"
	done

	json+="}}"
	echo "$json" > "$STATUS_FILE"
}

if ! command -v nc &>/dev/null; then
	apt-get install -y netcat-openbsd -qq
fi

echo "Monitor started..."
while true; do
	check_services
	sleep 30
done