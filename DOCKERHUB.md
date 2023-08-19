# Docker container for JMkvpropedit
[![Release](https://img.shields.io/github/release/jlesage/docker-jmkvpropedit.svg?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-jmkvpropedit/releases/latest)
[![Docker Image Size](https://img.shields.io/docker/image-size/jlesage/jmkvpropedit/latest?logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/jmkvpropedit/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/jlesage/jmkvpropedit?label=Pulls&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/jmkvpropedit)
[![Docker Stars](https://img.shields.io/docker/stars/jlesage/jmkvpropedit?label=Stars&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/jmkvpropedit)
[![Build Status](https://img.shields.io/github/actions/workflow/status/jlesage/docker-jmkvpropedit/build-image.yml?logo=github&branch=master&style=for-the-badge)](https://github.com/jlesage/docker-jmkvpropedit/actions/workflows/build-image.yml)
[![Source](https://img.shields.io/badge/Source-GitHub-blue?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-jmkvpropedit)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg?style=for-the-badge)](https://paypal.me/JocelynLeSage)

This is a Docker container for [JMkvpropedit](https://github.com/BrunoReX/jmkvpropedit).

The GUI of the application is accessed through a modern web browser (no
installation or configuration needed on the client side) or via any VNC client.

---

[![JMkvpropedit logo](https://images.weserv.nl/?url=raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/jmkvpropedit-icon.png&w=110)](https://github.com/BrunoReX/jmkvpropedit)[![JMkvpropedit](https://images.placeholders.dev/?width=384&height=110&fontFamily=monospace&fontWeight=400&fontSize=52&text=JMkvpropedit&bgColor=rgba(0,0,0,0.0)&textColor=rgba(121,121,121,1))](https://github.com/BrunoReX/jmkvpropedit)

JMkvpropedit is batch GUI for mkvpropedit (part of MKVToolNix) written in Java.

---

## Quick Start

**NOTE**:
    The Docker command provided in this quick start is given as an example
    and parameters should be adjusted to your need.

Launch the JMkvpropedit docker container with the following command:
```shell
docker run -d \
    --name=jmkvpropedit \
    -p 5800:5800 \
    -v /docker/appdata/jmkvpropedit:/config:rw \
    -v /home/user:/storage:rw \
    jlesage/jmkvpropedit
```

Where:

  - `/docker/appdata/jmkvpropedit`: This is where the application stores its configuration, states, log and any files needing persistency.
  - `/home/user`: This location contains files from your host that need to be accessible to the application.

Browse to `http://your-host-ip:5800` to access the JMkvpropedit GUI.
Files from the host appear under the `/storage` folder in the container.

## Documentation

Full documentation is available at https://github.com/jlesage/docker-jmkvpropedit.

## Support or Contact

Having troubles with the container or have questions?  Please
[create a new issue].

For other great Dockerized applications, see https://jlesage.github.io/docker-apps.

[create a new issue]: https://github.com/jlesage/docker-jmkvpropedit/issues
