#!/bin/sh

RESPONSE=$(curl -sSL -X POST "https://sso.sikalabs.com/realms/training/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=example_client_id" \
  -d "client_secret=example_client_secret" \
  -d "grant_type=password" \
  -d "username=example_username" \
  -d "password=example_password" )

echo RAW RESPONSE:
echo $RESPONSE | jq
echo
