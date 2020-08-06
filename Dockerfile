#Adapted from https://hub.docker.com/r/danielguerra/alpine-xfce4-xrdp
#Adapted from a Singularity file by various people at DESY
FROM centos:centos7.7.1908
LABEL maintainer="Daniel Webster <dsw@cloudbusting.io>"


RUN yum -y install epel-release \
    && yum -y update \
	&& yum -y install xrdp fvwm slim xorg-x11-server-utils \
	xorg-x11-drv-synaptics xorg-x11-drv-mouse xorg-x11-drv-keyboard \
	xorg-x11-xkb-utils util-linux gnu-free-serif-fonts gnu-free-sans-fonts \
	gnu-free-mono-fonts xorg-x11-xauth supervisor x11vnc libgomp glibc-devel sudo file \
	numactl-devel libaec-devel dbus dejavu-lgc-sans-fonts gedit unzip gzip tar pam libXt GConf2 \
	gtk2 libXtst python xterm xcalc wget which curl bzip2 hdf5 hdf5-devel gtk2-devel libpng-devel \
	ncurses-devel fftw-devel gmp-devel mpfr-devel libmpc-devel autoconf automake m4 openmpi3 \
	libgcc.i686 glibc.i686 libstdc++.i686 libgcc-devel.i686 glibc-devel.i686 libstdc++-devel.i686 \
	&& yum -y clean all


RUN yum install -y http://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-repo-rhel7-9.2.148-1.x86_64.rpm \
    && yum install -y cuda-curand-8-0 cuda-npp-8-0 cuda-cusolver-8-0 cuda-cusparse-8-0 cuda-cufft-8-0 cuda-nvgraph-8-0 \
	cuda-cublas-8-0 cuda-license-8-0 cuda-cudart-8-0 cuda-nvrtc-8-0 cuda-curand-9-1 cuda-npp-9-1 cuda-cusolver-9-1 \
	cuda-cusparse-9-1 cuda-cufft-9-1 cuda-nvgraph-9-1 cuda-cublas-9-1 cuda-license-9-1 cuda-cudart-9-1 cuda-nvrtc-9-1

RUN yum install -y centos-release-scl \
	&& yum install -y devtoolset-8-gcc devtoolset-8-gcc-c++ devtoolset-8-gcc-gfortran.x86_64 \
    && echo "source scl_source enable devtoolset-8" >> /etc/bashrc

COPY intel-mkl.repo /etc/yum.repos.d/intel-mkl.repo
RUN rpm --import https://yum.repos.intel.com/2018/setup/RPM-GPG-KEY-intel-psxe-runtime-2018 \
	&& yum install -y intel-mkl-runtime\*

# Source in compiler first
RUN source /etc/bashrc \
	&& wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/hdf5-1.8.21/src/hdf5-1.8.21.tar.gz \
	&& tar --no-same-owner -xf hdf5-1.8.21.tar.gz && cd hdf5-1.8.21 \
	&& ./configure --enable-cxx --enable-fortran2003 --enable-fortran --prefix=/usr/local --libdir=/usr/local/lib64 \
	&& make -j 2 && make install || cat config.log

# Mount your matlab dir into the container at /usr/local/matlab
# Don't include this before any compilation
ENV PATH=/usr/local/matlab/bin:/usr/lib64/openmpi3/bin:/usr/local/bin:$PATH \
    LD_LIBRARY_PATH=/usr/lib64/openmpi3/lib:/usr/local/lib64:/usr/local/lib:/opt/intel/psxe_runtime/linux/mkl/lib/intel64_lin \
    MATLABPATH=/usr/local/matlab/cSAXS_matlab_base:/usr/local/matlab/ptychoshelves \
    MLM_LICENSE_FILE=/usr/local/matlab/licenses/license.dat \
    MPI_HOME=/usr/lib64/openmpi3

RUN dbus-uuidgen > /var/lib/dbus/machine-id

COPY etc /etc/
COPY docker-entrypoint.sh /bin
COPY usr/ /usr/

RUN groupadd xray \
&& useradd -g xray -s /bin/bash -m xray\
&& echo "xray:xray" | /usr/sbin/chpasswd \
&& echo "xray ALL=(ALL)NOPASSWD:ALL" >> /etc/sudoers
COPY xray /home/xray

RUN xrdp-keygen xrdp auto

EXPOSE 3389 5900
ENTRYPOINT ["/bin/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
