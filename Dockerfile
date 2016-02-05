FROM alpine:latest
MAINTAINER Colin Hebert <hebert.colin@gmail.com>

RUN apk add --update openvpn && rm -rf /var/cache/apk/*
COPY pia /pia
WORKDIR /pia
COPY openvpn.sh /usr/local/bin/openvpn.sh

ENV REGION="US East" USERNAME= PASSWORD=
ENTRYPOINT ["openvpn.sh"]
