#Program versions
ARG REDIR_VERSION=3.3
ARG UREDIR_VERSION=3.3
ARG LIBUEV_VERSION=2.4.0

#Build redir and uredir
FROM alpine:3.14 as builder
WORKDIR /build

ARG REDIR_VERSION
ARG UREDIR_VERSION
ARG LIBUEV_VERSION

#Install build tools
RUN apk add build-base autoconf automake libtool linux-headers pkgconfig bsd-compat-headers

#Download latest release
RUN wget https://github.com/troglobit/redir/releases/download/v${REDIR_VERSION}/redir-${REDIR_VERSION}.tar.xz
RUN wget https://github.com/troglobit/uredir/releases/download/v${UREDIR_VERSION}/uredir-${UREDIR_VERSION}.tar.gz
RUN wget https://github.com/troglobit/libuev/releases/download/v${LIBUEV_VERSION}/libuev-${LIBUEV_VERSION}.tar.xz

#Unpack source files
RUN tar xf redir-${REDIR_VERSION}.tar.xz
RUN tar xf uredir-${UREDIR_VERSION}.tar.gz
RUN tar xf libuev-${LIBUEV_VERSION}.tar.xz

#Compile & build
RUN cd libuev-${LIBUEV_VERSION} && ./configure && make install-strip
RUN cd redir-${REDIR_VERSION} && ./configure && make
RUN cd uredir-${UREDIR_VERSION} && ./configure && make

#Run port forwarding
FROM alpine:3.14 as runner
WORKDIR /port-redir

ARG REDIR_VERSION
ARG UREDIR_VERSION
ARG LIBUEV_VERSION

#Copy programs & libs from builder
COPY --from=builder /usr/local/lib/libuev* /usr/local/lib/
COPY --from=builder /build/redir-${REDIR_VERSION}/redir /usr/bin/
COPY --from=builder /build/uredir-${UREDIR_VERSION}/uredir /usr/bin/
COPY . .

RUN chmod +x ./map-ports.sh

ENTRYPOINT '/port-redir/map-ports.sh'