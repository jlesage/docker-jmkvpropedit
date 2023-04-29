#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

# Set same default compilation flags as abuild.
export CFLAGS="-Os -fomit-frame-pointer"
export CXXFLAGS="$CFLAGS"
export CPPFLAGS="$CFLAGS"
export LDFLAGS="-Wl,--strip-all -Wl,--as-needed"

export CC=xx-clang
export CXX=xx-clang++

function log {
    echo ">>> $*"
}

MKVTOOLNIX_URL="$1"

if [ -z "$MKVTOOLNIX_URL" ]; then
    log "ERROR: MKVToolNix URL missing."
    exit 1
fi

#
# Install required packages.
#
apk --no-cache add \
    curl \
    imagemagick \
    py3-pip \
    clang \
    binutils \
    ruby-rake \
    pkgconf \
    qtchooser \
    qt5-qtbase-dev \

xx-apk --no-cache --no-scripts add \
    musl-dev \
    gcc \
    g++ \
    boost-dev \
    gmp-dev \
    flac-dev \
    libogg-dev \
    libvorbis-dev \
    zlib-dev \
    qt5-qtbase-dev \
    qt5-qtmultimedia-dev \
    qt5-qtsvg-dev \

#xx-apk --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community add \
#    cmark-dev \

#
# Download sources.
#

log "Downloading MKVToolNix package..."
mkdir /tmp/mkvtoolnix
curl -# -L -f ${MKVTOOLNIX_URL} | tar xJ --strip 1 -C /tmp/mkvtoolnix

#
# Compile.
#

log "Configuring MKVToolNix..."
(
    cd /tmp/mkvtoolnix && \
    env LIBINTL_LIBS=-lintl ./configure \
        --build=$(TARGETPLATFORM= xx-clang --print-target-triple) \
        --host=$(xx-clang --print-target-triple) \
        --prefix=/usr \
        --disable-update-check \
        --disable-gui \
)

log "Compiling mkvpropedit..."
rake -f /tmp/mkvtoolnix/Rakefile -j$(nproc) apps:mkvpropedit

log "Installing mkvpropedit..."
mkdir -p /tmp/mkvtoolnix-install/usr/bin
cp -v /tmp/mkvtoolnix/src/mkvpropedit /tmp/mkvtoolnix-install/usr/bin/
