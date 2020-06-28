ARG CENTOS_VERSION=7
FROM centos:$CENTOS_VERSION

RUN yum -y install epel-release

WORKDIR /usr/local/etc/i3/deps
RUN yum --downloadonly --downloaddir=. -y install i3 \
    && rm -v i3*.rpm \
    && yum install -y \
        alsa-lib-devel \
        asciidoc \
        gcc-c++ \
        git \
        libcap-devel \
        libconfuse-devel \
        libev-devel \
        libnl3-devel \
        libtool \
        libxkbcommon-x11-devel \
        make \
        pango-devel \
        pcre-devel \
        pulseaudio-libs-devel \
        startup-notification-devel \
        which \
        xcb-util-cursor-devel \
        xcb-util-devel \
        xcb-util-keysyms-devel \
        xcb-util-wm-devel \
        xorg-x11-util-macros \
        yajl-devel

ENV XORG_CONFIG=/etc/X11/
ENV PKG_CONFIG_LIBDIR=/usr/lib/pkgconfig:/usr/lib64/pkgconfig
ENV PKG_CONFIG_PATH=/usr/share/pkgconfig

COPY entrypoint.sh /
COPY i3-deps /usr/local/bin/
ENTRYPOINT ["bash", "/entrypoint.sh"]
