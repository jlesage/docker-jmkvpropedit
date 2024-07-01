#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

# Set the working directory.
cd /config

# Set theme.
if is-bool-val-true "${DARK_MODE:-0}"; then
    THEME="FlatDarkLaf"
else
    THEME="FlatLightLaf"
fi

exec java \
    -Duser.home=/storage \
    -Dcom.formdev.flatlaf.theme=$THEME \
    -jar /opt/jmkvpropedit/JMkvpropedit.jar

# vim:ft=sh:ts=4:sw=4:et:sts=4
