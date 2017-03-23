#!/usr/bin/env bash

R=1
Array=(
lib/_tls_wrap.js
src/env.h
src/node_crypto.cc
src/node_crypto.h
src/tls_wrap.cc
src/tls_wrap.h
test/parallel/test-tls-client-getephemeralkeyinfo.js
test/parallel/test-tls-cnnic-whitelist.js
test/parallel/test-tls-sni-server-client.js
)

_SCRIPT=$(readlink -f $0)
_SCRIPT_PATH=$(dirname $_SCRIPT)
_NODEJS_DIR=$(basename $PWD)
_NODEJS_VER=${_NODEJS_DIR##*v}

if [[ -z ${R} ]]; then
    for i in ${Array[@]}; do
        echo cp -av ${i} ${i}.BAK
	cp -av ${i} ${i}.BAK
    done
else
    for i in ${Array[@]}; do
        echo cp -av ${i}.BAK ${i}
	cp -av ${i}.BAK ${i}
    done
    patch -p1 -g0 -E --no-backup-if-mismatch -f < "${_SCRIPT_PATH}/nodejs-${_NODEJS_VER}-libressl.patch"
fi
