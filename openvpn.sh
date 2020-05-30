#!/bin/sh
set -e -u -o pipefail

if [ -n "$REGION" ]; then
  set -- "$@" '--config' "${REGION}.ovpn"
fi

mkdir -p /run/secrets
touch /run/secrets/auth_conf

if [ -n "$USERNAME" -a -n "$PASSWORD" ]; then
  echo "$USERNAME" > /run/secrets/auth_conf
  echo "$PASSWORD" >> /run/secrets/auth_conf
fi

chmod 600 /run/secrets/auth_conf
set -- "$@" '--auth-nocache'
set -- "$@" '--auth-user-pass' '/run/secrets/auth_conf'

echo Starting OpenVPN with "$@"
openvpn "$@"
