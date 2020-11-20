FROM alpine:3.12 AS config

RUN apk --no-cache add wget=~1.20.3-r1
RUN apk --no-cache add unzip=~6.0-r8

# download and install the latest default recommended ovpn configs
RUN wget -q https://www.privateinternetaccess.com/openvpn/openvpn-strong-tcp-nextgen.zip
RUN unzip -uq openvpn-strong-tcp-nextgen.zip -d /pia

FROM alpine:3.12

RUN apk --no-cache add openvpn=~2.4.9-r0

WORKDIR /pia
COPY --from=config /pia /pia
COPY openvpn.sh /usr/local/bin/openvpn.sh
RUN chmod +x /usr/local/bin/openvpn.sh

ENV REGION="Switzerland" \
    USERNAME="" \
    PASSWORD=""

ENTRYPOINT ["openvpn.sh"]
