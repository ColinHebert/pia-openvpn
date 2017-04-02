FROM alpine:latest
MAINTAINER Ignatius Teo <ignatius.teo@gmail.com>

RUN apk add --no-cache openvpn

COPY pia /pia
WORKDIR /pia
COPY openvpn.sh /usr/local/bin/openvpn.sh

ENV REGION="US East"
ENTRYPOINT ["openvpn.sh"]
