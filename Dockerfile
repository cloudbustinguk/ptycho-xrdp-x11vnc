#Adapted from https://hub.docker.com/r/danielguerra/alpine-xfce4-xrdp
FROM centos:centos7.7.1908
LABEL maintainer="Daniel Webster <dsw@cloudbusting.io>"

RUN yum -y install epel-release \
    && yum -y update \
	&& yum -y install xrdp fvwm slim xorg-x11-server-utils \
	xorg-x11-drv-synaptics xorg-x11-drv-mouse xorg-x11-drv-keyboard \
	xorg-x11-xkb-utils util-linux gnu-free-serif-fonts gnu-free-sans-fonts \
	gnu-free-mono-fonts xorg-x11-xauth supervisor x11vnc libgomp sudo \
	numactl-devel libaec-devel \
    && yum -y clean all

COPY etc /etc/
COPY docker-entrypoint.sh /bin
COPY usr/bin/ptycho /usr/bin/

RUN groupadd xray \
&& useradd -g xray -s /bin/bash -m xray\
&& echo "xray:xray" | /usr/sbin/chpasswd \
&& echo "xray ALL=(ALL) ALL" >> /etc/sudoers
COPY xray /home/xray

RUN xrdp-keygen xrdp auto

EXPOSE 3389 5900
ENTRYPOINT ["/bin/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
