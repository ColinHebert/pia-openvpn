#!/bin/bash
set -e

openvpn_options=()

if [ -n "$REGION"  ]; then
  openvpn_options+=('--config' "${REGION}.ovpn")
fi

if [ -n "$USERNAME" -a -n "$PASSWORD" ]; then
  echo "$USERNAME" > auth.conf
  echo "$PASSWORD" >> auth.conf
  openvpn_options+=('--auth-user-pass' 'auth.conf')
fi

openvpn "${openvpn_options[@]}" "$@"
