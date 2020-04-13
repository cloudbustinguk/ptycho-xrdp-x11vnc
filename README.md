# About

*Work In Progress*

Minimal CentOS7 with xrdp/x11vnc, and fvwm2.

Adapted from https://hub.docker.com/r/danielguerra/alpine-xfce4-xrdp - thanks Daniel!

This is to serve as the base image for a Ptychography application, and is probably not
for general purpose, unless you like vintage fvwm2 widgets (who doesn't..?).

Will need MATLAB mounted into the container.

**This image does not include any ptychographical solver application - which are subject to patent law**

**This image does not include MATLAB, which is the property of The Mathworks, Inc**

The paper relating to the `ptychoshelves` application is [here](http://scripts.iucr.org/cgi-bin/paper?zy5001)

Find this image on the Docker Hub: [ptycho-xrdp-x11vnc](https://hub.docker.com/repository/docker/cloudbusting/ptycho-xrdp-x11vnc)

# Usage

Quick start to test things:

```bash
user: xray
pass: xray
```

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

# Screenshot

![screenshot](https://user-images.githubusercontent.com/56673286/78801228-50821d00-79b4-11ea-92f0-c8dffe632a81.png)
