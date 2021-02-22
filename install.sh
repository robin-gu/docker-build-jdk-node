#!/usr/bin/env bash

set -eo pipefail

PROJECT_TOKEN="$1"
IN_DOCKER="${2:-false}"
POOL="${3:-default}"
SERVER="${CODING_SERVER:-wss://cci-websocket.coding.net}"
CUR_OS="$(uname | awk '{print tolower($0)}')"
CUR_ARCH=$(if [[ $(uname -m) == x86_64* ]];then echo 'amd64';elif [[ $(uname -m) == i*86 ]]; then echo '386'; else echo 'arm';fi)

supported="darwin linux"
[[ ${supported} =~ (^|[[:space:]])"$CUR_OS"($|[[:space:]]) ]] || (echo "支持的操作系统有: ${supported}" && exit 1)

SERVER_PARTS=(${SERVER//:\/\// })
if [[ ${#SERVER_PARTS[@]} -ne 2 ]]; then
    echo "地址无效，请按此格式指定：scheme://host"
    exit 1
fi

INSECURE=false
SCHEME=${SERVER_PARTS[0]}
if [[ ${SCHEME} != "wss" ]]; then
   INSECURE=true
fi

# mac arm install rosetta
if [[ "$CUR_OS" == 'darwin' && "$CUR_ARCH" == 'arm' ]]; then
    echo "The current system ${CUR_OS} ${CUR_ARCH} will install Rosetta"
		softwareupdate --install-rosetta --agree-to-license
		CUR_ARCH="amd64"
fi

echo "----> Download cci-agent client"
if [[ -e 'cci-agent' ]]; then
    ./cci-agent stop
fi
curl -L "https://coding-public-generic.pkg.coding.net/cci/release/cci-agent/${CUR_OS}/${CUR_ARCH}/cci-agent" -o cci-agent
echo '++++++++++++++++++++++++++++++++++++++++'

chmod +x "./cci-agent"

echo "----> Stop running agent"
./cci-agent stop

echo "----> Initialize environment"
./cci-agent init --pt ${PROJECT_TOKEN} -s ${SERVER_PARTS[1]} --docker=${IN_DOCKER} --insecure=${INSECURE} --pool=${POOL}
echo '++++++++++++++++++++++++++++++++++++++++'

echo "----> Start agent"
./cci-agent up -s ${SERVER_PARTS[1]} --insecure=${INSECURE} -d
