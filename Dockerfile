FROM alpine:3.18.0

RUN apk update && apk upgrade --available &&\
    apk add git cmake patch build-base pkgconf \
        json-c-dev libffi-dev cunit-dev bash llvm16 \
        clang16 bsd-compat-headers autoconf automake \
        autoconf-archive libtool bison c-ares-dev \
        elfutils-dev flex libcap-dev pcre-dev \
        linux-headers net-snmp-dev py3-sphinx python3-dev \
        readline-dev rtrlib-dev texinfo iproute2

# Build libxbgp
RUN git clone https://github.com/pluginized-protocols/libxbgp /opt/libxbgp && \
    cd /opt/libxbgp && \
    git submodule update --init --recursive && \
    patch -p0 < Make_dev_zero_fd_extern_in_header.patch && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j$(nproc)


# Build libyang v1
RUN git clone https://github.com/CESNET/libyang.git /opt/libyang && \
    cd /opt/libyang && \
    git checkout v1.0.240 && \
    mkdir build && \
    cd build && \
    cmake -DENABLE_LYD_PRIV=ON -DCMAKE_INSTALL_PREFIX:PATH=/usr \
      -D CMAKE_BUILD_TYPE:String="Release" .. && \
    make -j$(nproc) && \
    make install

# Build xbgp_plugins
# Plugins folder
WORKDIR /opt
RUN git clone https://github.com/pluginized-protocols/xbgp_plugins.git xbgp_plugins
WORKDIR /opt/xbgp_plugins
RUN make LIBXBGP=/opt/libxbgp/include

# xbgp_bird
WORKDIR /opt
RUN git clone https://github.com/pluginized-protocols/xbgp_bird.git xbgp_bird
WORKDIR /opt/xbgp_bird
RUN git checkout xbgp_compliant
RUN autoreconf -i && \
  ./configure \
  --prefix=/usr \
  --sysconfdir=/etc/bird \
  --localstatedir=/var/run/bird \
  --runstatedir=/var/run/bird \
  LIBUBPF=/opt/libxbgp/build \
  HUBPF=/opt/libxbgp/include \
  XBGP=/opt/xbgp_plugins
RUN make
RUN make install

# copying the plugin example to bird
RUN cp /opt/xbgp_plugins/monitoring/0_monitoring.meta /etc/bird/plugins/manifest.conf
RUN cp /opt/xbgp_plugins/monitoring/*.plugin /etc/bird/plugins
RUN cp /opt/xbgp_plugins/monitoring/*.o /etc/bird/plugins
COPY ./xproto /usr/bin/xproto
RUN /usr/bin/xproto bird start

WORKDIR /root
CMD /bin/bash
