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
rpcuser=${RPC_USER}
rpcpassword=${RPC_PASSWORD}
EOF
        chown "${APP_USER}:${APP_GROUP}" "${DATA_DIR}/bitcoin.conf"
    fi

    # ensure correct ownership and linking of data directory
    # we do not update group ownership here, in case users want to mount
    # a host directory and still retain access to it
    chown -R "${APP_USER}" "${DATA_DIR}"
    ln -sfn "${DATA_DIR}" "/home/${APP_USER}/.bitcoin"
    chown -h "${APP_USER}:${APP_GROUP}" "/home/${APP_USER}/.bitcoin"

    exec /usr/local/bin/gosu "${APP_USER}" "${APP_DIR}/${APP_NAME}/bin/$@"
fi

exec "$@"
