# About

*Work In Progress*

CentOS 7 Linux with xrdp/x11vnc, and fvwm2.
Adapted from https://hub.docker.com/r/danielguerra/alpine-xfce4-xrdp - thanks Daniel!

This is to serve as the base image for a Ptychography application, and is probably not
for general purpose, unless you like vintage fvwm2 widgets (who doesn't..?).

**This image does not include any ptychographical solver application - which are subject to patent law**

The paper relating to the `ptychoshelves` application is [here](http://scripts.iucr.org/cgi-bin/paper?zy5001)

# Usage

Quick start to test things:

user: xray
pass: xray

```bash
podman run -dt -p 3389:3389/tcp cloudbusting/ptycho-xrdp-x11vnc
podman run -dt -p 5900:5900/tcp cloudbusting/ptycho-xrdp-x11vnc
```

With data
---------
```bash
podman run -dt -p 3389:3389/tcp -v /path/to/data:/home/xray/data cloudbusting/ptycho-xrdp-x11vnc
podman run -dt -p 5900:5900/tcp -v /path/to/data:/home/xray/data cloudbusting/ptycho-xrdp-x11vnc
```

