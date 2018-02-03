#!/usr/bin/env bash
set -e

if [[ "$1" == "bitcoin-tx" || "$1" == "omnicore-cli" || "$1" == "omnicore-qt" || "$1" == "omnicored" ]]; then

    if [[ ! -s "${DATA_DIR}/bitcoin.conf" ]]; then
        cat <<-EOF > "${DATA_DIR}/bitcoin.conf"
server=1
txindex=1
printtoconsole=1
omnilogfile=${LOG_OUTPUT}
logtimestamps=1
rpcallowip=${RPC_ALLOWIP}
rpcuser=${BITCOIN_RPC_USER}
rpcpassword=${BITCOIN_RPC_PASSWORD}
EOF
        chown "${APP_USER}:${APP_GROUP}" "${DATA_DIR}/bitcoin.conf"
    fi

    exec /usr/local/bin/gosu "${APP_USER}" "${APP_DIR}/${APP_NAME}/bin/$@"
fi

exec "$@"
