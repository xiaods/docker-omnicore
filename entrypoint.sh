#!/bin/bash
set -e

if [[ "$1" == "bitcoin-tx" || "$1" == "omnicore-cli" || "$1" == "omnicore-qt" || "$1" == "omnicored" ]]; then

    if [[ ! -s "${APP_DIR}/${APP_NAME}/bitcoin.conf" ]]; then
        cat <<-EOF > "${APP_DIR}/${APP_NAME}/bitcoin.conf"
        server=1
        txindex=1
        printtoconsole=1
        omnilogfile=${LOG_OUTPUT}
        logtimestamps=1
        rpcallowip=${RPC_ALLOWIP}
        rpcuser=${BITCOIN_RPC_USER}
        rpcpassword=${BITCOIN_RPC_PASSWORD}
        EOF
        chown "${APP_USER}:${APP_GROUP}" "${APP_DIR}/${APP_NAME}/bitcoin.conf"
    fi

    # ensure correct ownership and linking of data directory
    # we do not update group ownership here, in case users want to mount
    # a host directory and still retain access to it
    chown -R "${APP_USER}" "${APP_DIR}/${APP_NAME}"
    ln -sfn "${APP_DIR}/${APP_NAME}" "/home/${APP_USER}/.bitcoin"
    chown -h "${APP_USER}:${APP_GROUP}" "/home/${APP_USER}/.bitcoin"

    exec gosu "${APP_USER}" "$@"
fi

exec "$@"
