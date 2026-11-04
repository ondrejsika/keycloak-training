#!/bin/sh

RESPONSE=$( curl -X POST "https://sso.sikalabs.com/realms/training/protocol/openid-connect/token" \
  -d "grant_type=client_credentials" \
  -d "client_id=example_sa" \
  -d "client_secret=example_sa" )

echo RAW RESPONSE:
echo "$RESPONSE" | jq
echo

echo ACCESS TOKEN:
echo "$RESPONSE" | jq -r .access_token | slu jwt parse -
echo
