FROM phusion/baseimage:0.9.18
MAINTAINER Md. Shadmanul Islam <shadmanulislam@gmail.com>

# Set correct environment variables.
ENV HOME /root
ENV COTURN_VERSION 4.5.0.7

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# install the dependencies
RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install \
    libssl-dev \
    libevent-dev \
    libhiredis-dev \
    wget \
    make -y    

RUN apt-get install sqlite3 libsqlite3-dev -y

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
RUN chmod +x /etc/service/turnserver/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
