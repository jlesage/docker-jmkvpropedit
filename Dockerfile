#
# jmkvpropedit Dockerfile
#
# https://github.com/jlesage/docker-jmkvpropedit
#
# NOTES:
#   - We are using JRE version 8 because recent versions are much bigger.
#   - JRE for ARM 32-bits on Alpine is very hard to get:
#     - The version in Alpine repo is very, very slow.
#     - The glibc version doesn't work well on Alpine with a compatibility
#       layer (gcompat or libc6-compat).  The `__xstat` symbol is missing and
#       implementing a wrapper is not straight-forward because the `struct stat`
#       is not constant across architectures (32/64 bits) and glibc/musl.
#

# Docker image version is provided via build arg.
ARG DOCKER_IMAGE_VERSION=

# Define software versions.
ARG JMKVPROPEDIT_VERSION=1.5.2
ARG MKVTOOLNIX_VERSION=73.0.0

# Define software download URLs.
#ARG JMKVPROPEDIT_URL=https://github.com/BrunoReX/jmkvpropedit/releases/download/v${JMKVPROPEDIT_VERSION}/jmkvpropedit-v${JMKVPROPEDIT_VERSION}.zip
ARG JMKVPROPEDIT_URL=https://github.com/BrunoReX/jmkvpropedit/archive/refs/tags/v${JMKVPROPEDIT_VERSION}.tar.gz
ARG MKVTOOLNIX_URL=https://mkvtoolnix.download/sources/mkvtoolnix-${MKVTOOLNIX_VERSION}.tar.xz

# Get Dockerfile cross-compilation helpers.
FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx

# Download JMkvpropedit
#FROM --platform=$BUILDPLATFORM alpine:3.16 AS jmkvpropedit
#ARG JMKVPROPEDIT_URL
#RUN \
#    apk --no-cache add curl && \
#    curl -# -L -o /tmp/jmkvpropedit.zip "$JMKVPROPEDIT_URL" && \
#    unzip -d /tmp /tmp/jmkvpropedit.zip

# Build JMkvpropedit
FROM --platform=$BUILDPLATFORM alpine:3.16 AS jmkvpropedit
ARG TARGETPLATFORM
ARG JMKVPROPEDIT_URL
COPY src/jmkvpropedit /build
RUN /build/build.sh "$JMKVPROPEDIT_URL"

# Build mkvpropedit (part of MKVToolNix).
FROM --platform=$BUILDPLATFORM alpine:3.16 AS mkvpropedit
ARG TARGETPLATFORM
ARG MKVTOOLNIX_URL
COPY --from=xx / /
COPY src/mkvtoolnix /build
RUN /build/build.sh "$MKVTOOLNIX_URL"
RUN xx-verify /tmp/mkvtoolnix-install/usr/bin/mkvpropedit

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.17-v4.6.7

ARG DOCKER_IMAGE_VERSION

# Define working directory.
WORKDIR /tmp

# Install dependencies.
RUN \
    add-pkg \
        java-common \
        openjdk8-jre \
        qt5-qtbase \
        gmp \
        # We need a font.
#        ttf-dejavu
    && true

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/jmkvpropedit-icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY rootfs/ /
COPY --from=jmkvpropedit /tmp/jmkvpropedit/dist/JMkvpropedit.jar /opt/jmkvpropedit/
COPY --from=mkvpropedit /tmp/mkvtoolnix-install/usr/bin/mkvpropedit /usr/bin/

# Set internal environment variables.
RUN \
    set-cont-env APP_NAME "JMkvpropedit" && \
    set-cont-env DOCKER_IMAGE_VERSION "$DOCKER_IMAGE_VERSION" && \
    true

# Define mountable directories.
VOLUME ["/storage"]

# Metadata.
LABEL \
      org.label-schema.name="jmkvpropedit" \
      org.label-schema.description="Docker container for JMkvpropedit" \
      org.label-schema.version="${DOCKER_IMAGE_VERSION:-unknown}" \
      org.label-schema.vcs-url="https://github.com/jlesage/docker-jmkvpropedit" \
      org.label-schema.schema-version="1.0"
