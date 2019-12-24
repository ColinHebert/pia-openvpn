FROM alpine:3.11
MAINTAINER Ignatius Teo <ignatius.teo@gmail.com>

RUN apk update && apk add --no-cache openvpn

COPY pia /pia
WORKDIR /pia
COPY openvpn.sh /usr/local/bin/openvpn.sh

ENV REGION="US East"
ENTRYPOINT ["openvpn.sh"]
