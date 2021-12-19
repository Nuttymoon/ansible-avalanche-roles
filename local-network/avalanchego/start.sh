#!/bin/bash

bootstrap_node=$(getent hosts avalanchego-1 | awk '{ print $1 }')
current_node=$(getent hosts "avalanchego-${NODE_ID}" | awk '{ print $1 }')

if [ "$NODE_ID" -eq 1 ]; then
	bootstrap_ip=""
	bootstrap_id=""
else
	bootstrap_ip="$bootstrap_node:9651"
	bootstrap_id=NodeID-7Xhw2mDxuDS44j42TCB6U5579esbSt3Lg
fi

/avalanchego/build/avalanchego \
	--public-ip="$current_node" --http-host="$current_node" \
	--http-port=9650 --staking-port=9651 \
	--snow-sample-size=2 --snow-quorum-size=2 \
	--db-dir="db/node${NODE_ID}" --staking-enabled=true \
	--network-id=local --bootstrap-ips="$bootstrap_ip" \
	--bootstrap-ids="$bootstrap_id" \
	--log-level=debug --log-dir=/var/log/avalanchego \
	--staking-tls-cert-file="/avalanchego/certs/staker${NODE_ID}.crt" \
	--staking-tls-key-file="/avalanchego/certs/staker${NODE_ID}.key"
