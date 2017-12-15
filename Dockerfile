FROM alpine:latest
MAINTAINER Colin Hebert <hebert.colin@gmail.com>

RUN apk add --no-cache openvpn unzip
ADD https://www.privateinternetaccess.com/openvpn/openvpn.zip /
WORKDIR /pia
RUN unzip /openvpn.zip && rm /openvpn.zip
COPY openvpn.sh /usr/local/bin/openvpn.sh

ENV REGION="US East"
ENTRYPOINT ["openvpn.sh"]