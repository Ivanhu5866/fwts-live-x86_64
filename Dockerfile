FROM ubuntu:bionic
RUN echo "deb-src http://archive.ubuntu.com/ubuntu/ bionic main universe" >> /etc/apt/sources.list && \
    echo "deb-src http://archive.ubuntu.com/ubuntu/ bionic-updates main universe" >> /etc/apt/sources.list && \
    echo "deb-src http://archive.ubuntu.com/ubuntu/ bionic-security main universe" >> /etc/apt/sources.list
RUN apt update && apt -y install build-essential git snapcraft ubuntu-image && apt-get -y build-dep livecd-rootfs
RUN git clone --depth 1 https://github.com/alexhungce/pc-amd64-gadget-focal.git pc-amd64-gadget && \
    cd pc-amd64-gadget && snapcraft prime
RUN git clone --depth 1 https://github.com/alexhungce/fwts-livecd-rootfs-focal.git fwts-livecd-rootfs && \
    cd fwts-livecd-rootfs && debian/rules binary && \
    dpkg -i ../livecd-rootfs_*_amd64.deb
VOLUME /image
ENTRYPOINT ubuntu-image classic -a amd64 -d -p ubuntu-cpc -s focal -i 850M -O /image \
    --extra-ppas firmware-testing-team/ppa-fwts-stable pc-amd64-gadget/prime && \
    xz /image/pc.img
