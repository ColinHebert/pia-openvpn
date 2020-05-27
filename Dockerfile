FROM alpine:3.11 AS config

RUN apk --no-cache add wget=~1.20.3-r0
RUN apk --no-cache add unzip=~6.0-r6

# download and install the latest default recommended ovpn configs
RUN wget -q https://www.privateinternetaccess.com/openvpn/openvpn-strong.zip
RUN unzip -uq openvpn-strong.zip -d /pia

FROM alpine:3.11

RUN apk --no-cache add openvpn=~2.4.8-r1

WORKDIR /pia
COPY --from=config /pia /pia
COPY openvpn.sh /usr/local/bin/openvpn.sh
RUN chmod +x /usr/local/bin/openvpn.sh

ENV REGION="US East" \
    USERNAME="" \
    PASSWORD=""

ENTRYPOINT ["openvpn.sh"]
