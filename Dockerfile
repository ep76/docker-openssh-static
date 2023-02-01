FROM alpine:3.16.0 AS builder
ARG openssh_url=https://github.com/openssh/openssh-portable/archive/refs/tags/V_9_0_P1.tar.gz
RUN \
  apk add --no-cache \
    autoconf \
    automake \
    curl \
    gcc \
    make \
    musl-dev \
    linux-headers \
    openssl-dev \
    openssl-libs-static \
    patch \
    zlib-dev \
    zlib-static \
    && \
  cd /tmp && \
  curl -fsSL "${openssh_url}" | tar xz --strip-components=1 && \
  autoreconf && \
  ./configure \
    --prefix=/usr \
    --sysconfdir=/etc/ssh \
    --with-ldflags=-static \
    --with-privsep-user=nobody \
    --with-ssl-engine \
    && \
  aports=https://raw.githubusercontent.com/alpinelinux/aports/master/main/openssh && \
  curl -fsSL \
    "${aports}/{fix-utmp,fix-verify-dns-segfaults,ftp-interactive}.patch" \
    | patch -p1 && \
  make install-nosysconf exec_prefix=/openssh

FROM builder AS tester
RUN \
  TEST_SSH_UNSAFE_PERMISSIONS=1 \
    make -C /tmp file-tests interop-tests unit SK_DUMMY_LIBRARY=''

FROM busybox:1.36 AS openssh-static
LABEL maintainer="https://github.com/ep76/docker-openssh-static"
COPY --from=builder /openssh /usr
VOLUME [ "/var/run", "/var/empty" ]
ENTRYPOINT [ "/usr/sbin/sshd" ]
CMD [ "-D", "-e" ]
