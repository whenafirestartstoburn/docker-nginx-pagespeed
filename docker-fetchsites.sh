#!/bin/bash

export $(cat /.env | xargs)

echo -n "Fetching sites configurations... "
PAYLOAD=$(curl -qfsw '\n%{http_code}' $ENDPOINT/api/config/nginx/$FILESYSTEM)
RESPONSE=$?

# terminate if no valid response 200 is received from API call
if [[ $RESPONSE -ne 0 ]] ; then
    echo "HTTP Error: $(echo "$PAYLOAD" | tail -n1 )"
    exit 1
else
	echo "DONE!"
fi

# parse json payload
echo "Parsing json payload..."
CONFIGS=$(echo "$PAYLOAD" | head -n-1 | jq "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]")

# render vhost configuration files
mkdir -p /etc/nginx/sites/
while IFS="=" read -r key value
do
	FILENAME=/etc/nginx/sites/${key:1}

	echo "Rendering: $FILENAME.conf"
    printf "$value" | head -n-1 > $FILENAME.conf
done <<< "$CONFIGS"

echo "Setup complete..."
