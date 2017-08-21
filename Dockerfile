FROM phusion/baseimage:0.9.18
MAINTAINER Md. Shadmanul Islam <shadmanulislam@gmail.com>

# Set correct environment variables.
ENV HOME /root
ENV COTURN_VERSION 4.5.0.6

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN apt-get update -qq

# # Build environment
# RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
# 	wget git \
# 	build-essential \
# 	cmake \
# 	python \
# 	ca-certificates \
# 	gettext-base

# # Dependencies
# RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
# 	sqlite3 libsqlite3-dev \
# 	libssl-dev \
# 	libpq-dev \
# 	libmysqlclient-dev \
# 	libmongoc-dev libmongoc-1.0-0 \
# 	libbson-1.0-0  libbson-dev \
# 	libhiredis-dev \
# 	libevent-dev libevent-2.0-5

# RUN git clone --branch ${COTURN_VERSION} https://github.com/coturn/coturn /coturn && \
#     cd /coturn && \
#     ./configure --prefix=/app && \
#     make install && \
#     rm -rf /coturn && \
#     rm -rf /var/cache/apk/*

# install the dependencies
RUN apt-get update && \
    apt-get install \
    libssl-dev \
    libevent-dev \
    libhiredis-dev \
    make -y    

# Download the source tar
RUN wget -O turn.tar.gz \
    http://turnserver.open-sys.org/downloads/v${COTURN_VERSION}/turnserver-${COTURN_VERSION}.tar.gz     

# unzip
RUN tar -zxvf turn.tar.gz && \
    cd turnserver-* && \
    ./configure && \
    make && make install 

RUN groupadd turnserver
RUN useradd -g turnserver turnserver

RUN mkdir /etc/service/turnserver

COPY turnserver.sh /etc/service/turnserver/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
