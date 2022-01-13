#!/bin/bash

AVALANCHE_URL=127.0.0.1:9661
AVALANCHE_USER="cresus"
AVALANCHE_PASS="g9KDa3X8g3Rm8mLP"
AVALANCHE_PRIV_KEY="PrivateKey-ewoqjP7PxY4yr3iLTpLisriqt94hdyDFNgchSxGGztUrTXtNN"

grey() {
	read input
	echo -e "\e[2m$input\e[0m"
}

# Create user in the keystore
echo "Create $AVALANCHE_USER account in keystore..."
curl -s -X POST --data "{
	\"jsonrpc\": \"2.0\",
	\"id\"     : 1,
	\"method\" : \"keystore.createUser\",
	\"params\" : {
		\"username\": \"$AVALANCHE_USER\",
		\"password\": \"$AVALANCHE_PASS\"
	}
}" -H 'content-type:application/json;' "$AVALANCHE_URL/ext/keystore" | grey

# Link pre-funded addresses to user
echo "Link $AVALANCHE_USER to pre-funded addresses..."
echo "  P-Chain..."
curl -s -X POST --data "{
	\"jsonrpc\": \"2.0\",
	\"method\": \"platform.importKey\",
	\"params\": {
		\"username\": \"$AVALANCHE_USER\",
		\"password\": \"$AVALANCHE_PASS\",
		\"privateKey\": \"$AVALANCHE_PRIV_KEY\"
	},
	\"id\": 1
}" -H 'Content-Type: application/json' "$AVALANCHE_URL/ext/platform" | grey
echo "  X-Chain..."
curl -s -X POST --data "{
	\"jsonrpc\": \"2.0\",
	\"method\": \"avm.importKey\",
	\"params\": {
		\"username\": \"$AVALANCHE_USER\",
		\"password\": \"$AVALANCHE_PASS\",
		\"privateKey\": \"$AVALANCHE_PRIV_KEY\"
	},
	\"id\": 1
}" -H 'Content-Type: application/json' "$AVALANCHE_URL/ext/bc/X" | grey
echo "  C-Chain..."
curl -s -X POST --data "{
	\"jsonrpc\": \"2.0\",
	\"method\": \"avax.importKey\",
	\"params\": {
		\"username\": \"$AVALANCHE_USER\",
		\"password\": \"$AVALANCHE_PASS\",
		\"privateKey\": \"$AVALANCHE_PRIV_KEY\"
	},
	\"id\": 1
}" -H 'Content-Type: application/json' "$AVALANCHE_URL/ext/bc/C/avax" | grey
