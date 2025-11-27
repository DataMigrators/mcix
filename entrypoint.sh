#!/bin/sh -l

MCIX_BIN_DIR="/usr/share/mcix/bin/"
MCIX_CMD="/usr/share/mcix/bin/mcix"
PATH=$PATH:$MCIX_BIN_DIR

env

${MCIX_CMD} system version 

echo ${?} >> GITHUB_OUTPUT
