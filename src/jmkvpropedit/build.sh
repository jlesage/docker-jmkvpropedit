#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

function log {
    echo ">>> $*"
}

JMKVPROPEDIT_URL="$1"

if [ -z "$JMKVPROPEDIT_URL" ]; then
    log "ERROR: JMkvpropedit URL missing."
    exit 1
fi

#
# Install required packages.
#
apk --no-cache add \
    curl \
    patch \
    apache-ant \

#
# Download sources.
#

log "Downloading JMkvpropedit package..."
mkdir /tmp/jmkvpropedit
curl -# -L -f ${JMKVPROPEDIT_URL} | tar xz --strip 1 -C /tmp/jmkvpropedit

#
# Compile.
#

log "Patching mkvpropedit..."
patch -p1 -d /tmp/jmkvpropedit < "$SCRIPT_DIR"/flatlaf.patch
patch -p1 -d /tmp/jmkvpropedit < "$SCRIPT_DIR"/hide-options-tab.patch

mkdir /tmp/jmkvpropedit/lib/flatlaf
cp -v "$SCRIPT_DIR"/flatlaf-3.0.jar /tmp/jmkvpropedit/lib/flatlaf/

log "Compiling mkvpropedit..."
(
    cd /tmp/jmkvpropedit && \
    ant jar
)
