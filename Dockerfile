FROM ubuntu:jammy
COPY --from=snapcore/snapcraft:stable /snap /snap
ENV PATH="/snap/bin:$PATH"
ENV SNAP="/snap/snapcraft/current"
ENV SNAP_NAME="snapcraft"
ENV SNAP_ARCH="amd64"
RUN echo "deb-src http://archive.ubuntu.com/ubuntu/ jammy main universe" >> /etc/apt/sources.list && \
    echo "deb-src http://archive.ubuntu.com/ubuntu/ jammy-updates main universe" >> /etc/apt/sources.list && \
    echo "deb-src http://archive.ubuntu.com/ubuntu/ jammy-security main universe" >> /etc/apt/sources.list
RUN apt update && apt -y install build-essential git ubuntu-image && apt-get -y build-dep livecd-rootfs
RUN git clone --depth 1 https://github.com/ivanhu5866/pc-amd64-gadget.git && \
    cd pc-amd64-gadget && snapcraft prime
RUN git clone --depth 1 https://github.com/ivanhu5866/fwts-livecd-rootfs-jammy.git && \
    cd fwts-livecd-rootfs-jammy && debian/rules binary && \
    dpkg -i ../livecd-rootfs_*_amd64.deb
VOLUME /image
ENTRYPOINT ubuntu-image classic -a amd64 -d -p ubuntu-cpc -s jammy -i 850M -O /image \
    --extra-ppas firmware-testing-team/ppa-fwts-stable pc-amd64-gadget/prime && \
    xz /image/pc.img
