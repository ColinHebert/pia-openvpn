FROM ubuntu:latest
MAINTAINER Colin Hebert <hebert.colin@gmail.com>

RUN apt-get update && apt-get install -y openvpn \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
COPY pia /pia
WORKDIR /pia
COPY openvpn.sh /usr/local/bin/openvpn.sh

ENV REGION="US East" USERNAME= PASSWORD=
ENTRYPOINT ["openvpn.sh"]
