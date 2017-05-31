#!/bin/bash

# this is container boot process that will fetch configuration payload from orchestrator
# to create individual sites Nginx vhost configuration files
# it will exit the container if the process fails

echo "Starting Nginx setup..."

# validate that required environment variables exist
if [ -z ${ENDPOINT+x} ]; then 
	echo "ERROR: required ENDPOINT environment variable is not defined"; 
	exit 0
else 
	echo "ENDPOINT is set to '$ENDPOINT'"; 
fi

if [ -z ${HOSTNAME+x} ]; then 
	echo "ERROR: required HOSTNAME environment variable is not defined"; 
	exit 0
else 
	echo "HOSTNAME is set to '$HOSTNAME'"; 
fi

if [ -z ${FILESYSTEM+x} ]; then 
	echo "ERROR: required FILESYSTEM environment variable is not defined"; 
	exit 0
else 
	echo "FILESYSTEM is set to '$FILESYSTEM'"; 
fi

echo ""

# build request URI
REQUEST=$ENDPOINT/api/config/$HOSTNAME/$FILESYSTEM
PAYLOAD=$(curl -qfsw '\n%{http_code}' $REQUEST)
RESPONSE=$?

echo -n "Fetching configurations from: $REQUEST : "



echo -n "Fetching sites configurations... "
PAYLOAD=$(curl -qfsw '\n%{http_code}' $ENDPOINT/api/config/nginx/$FILESYSTEM)
RESPONSE=$?

# terminate if no valid response 200 is received from API call
if [[ $RESPONSE -ne 0 ]] ; then
    echo "HTTP Error: $(echo "$PAYLOAD" | tail -n1 )"
    exit 1
else
	echo "PAYLOAD RECEIVED!"
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
