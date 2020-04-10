#Adapted from https://hub.docker.com/r/danielguerra/alpine-xfce4-xrdp
FROM centos:centos7.7.1908
LABEL maintainer="Daniel Webster"

ENV PATH=/usr/local/matlab/bin:/usr/lib64/openmpi3/bin:/usr/local/bin:$PATH \
    LD_LIBRARY_PATH=/usr/lib64/openmpi3/lib:/usr/local/lib64:/usr/local/lib:/opt/intel/psxe_runtime/linux/mkl/lib/intel64_lin \
    MATLABPATH=/usr/local/matlab/cSAXS_matlab_base:/usr/local/matlab/ptychoshelves \
    MLM_LICENSE_FILE=/usr/local/matlab/licenses/license.dat \
    MPI_HOME=/usr/lib64/openmpi3

RUN yum -y install epel-release \
    && yum -y update \
	&& yum -y install xrdp fvwm slim xorg-x11-server-utils \
	xorg-x11-drv-synaptics xorg-x11-drv-mouse xorg-x11-drv-keyboard \
	xorg-x11-xkb-utils util-linux gnu-free-serif-fonts gnu-free-sans-fonts \
	gnu-free-mono-fonts xorg-x11-xauth supervisor x11vnc libgomp sudo \
	numactl-devel libaec-devel dbus dejavu-lgc-sans-fonts gedit unzip gzip tar pam libXt GConf2 \
	gtk2 libXtst python xterm wget which curl bzip2 hdf5 hdf5-devel gtk2-devel libpng-devel \
	ncurses-devel fftw-devel gmp-devel mpfr-devel libmpc-devel autoconf automake m4 openmpi3 \
	libgcc.i686 glibc.i686 libstdc++.i686 libgcc-devel.i686 glibc-devel.i686 libstdc++-devel.i686 \
    && yum -y clean all

RUN yum install -y http://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-repo-rhel7-9.2.148-1.x86_64.rpm \
    && yum install -y cuda-curand-8-0 cuda-npp-8-0 cuda-cusolver-8-0 cuda-cusparse-8-0 cuda-cufft-8-0 cuda-nvgraph-8-0 \
	cuda-cublas-8-0 cuda-license-8-0 cuda-cudart-8-0 cuda-nvrtc-8-0

RUN yum install -y centos-release-scl \
	&& yum install -y devtoolset-8-gcc devtoolset-8-gcc-c++ \
    && echo "source scl_source enable devtoolset-8" >> /etc/bashrc

ADD intel-mkl.repo /etc/yum.repos.d/intel-mkl.repo
RUN rpm --import https://yum.repos.intel.com/2018/setup/RPM-GPG-KEY-intel-psxe-runtime-2018
RUN yum install -y intel-mkl-runtime\*


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
