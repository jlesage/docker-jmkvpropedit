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

# Define software download URLs.
ARG JMKVPROPEDIT_URL=https://github.com/BrunoReX/jmkvpropedit/archive/refs/tags/v${JMKVPROPEDIT_VERSION}.tar.gz

# Get Dockerfile cross-compilation helpers.
FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx

# Build JMkvpropedit
FROM --platform=$BUILDPLATFORM alpine:3.20 AS jmkvpropedit
ARG TARGETPLATFORM
ARG JMKVPROPEDIT_URL
COPY src/jmkvpropedit /build
RUN /build/build.sh "$JMKVPROPEDIT_URL"

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.20-v4.12.6

ARG DOCKER_IMAGE_VERSION

# Define working directory.
WORKDIR /tmp

# Install dependencies.
RUN \
    add-pkg \
        java-common \
        openjdk8-jre \
        mkvtoolnix \
    && true

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/jmkvpropedit-icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY rootfs/ /
COPY --from=jmkvpropedit /tmp/jmkvpropedit/dist/JMkvpropedit.jar /opt/jmkvpropedit/

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
