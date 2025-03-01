#!/bin/sh

RESPONSE=$(curl -sSL -X POST "https://sso.sikalabs.com/realms/training/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=example_client_id" \
  -d "client_secret=example_client_secret" \
  -d "grant_type=password" \
  -d "scope=openid" \
  -d "username=example_username" \
  -d "password=example_password" )

echo RAW RESPONSE:
echo $RESPONSE | jq
echo

echo RAW ACCESS TOKEN:
RAW_ACCESS_TOKEN=$(echo $RESPONSE | jq -r .access_token)
echo $RAW_ACCESS_TOKEN
echo

echo PARSED ACCESS TOKEN:
PARSED_ACCESS_TOKEN=$(echo $RESPONSE | jq -r .access_token | slu jwt parse - | jq '.[1]')
echo $PARSED_ACCESS_TOKEN | jq
echo

echo VALIDATED ACCESS TOKEN:
slu jwt validate $(echo $PARSED_ACCESS_TOKEN | jq -r .iss) $RAW_ACCESS_TOKEN
echo

echo PARSED ID TOKEN:
PARSED_ID_TOKEN=$(echo $RESPONSE | jq -r .id_token | slu jwt parse - | jq '.[1]')
echo $PARSED_ID_TOKEN | jq
echo

echo RAW REFRESH TOKEN:
RAW_REFRESH_TOKEN=$(echo $RESPONSE | jq -r .refresh_token)
echo $RAW_REFRESH_TOKEN
echo

echo PARSED REFRESH TOKEN:
echo $RESPONSE | jq -r .refresh_token | slu jwt parse - | jq '.[1]'
echo

NEW_RESPONSE=$(curl -sSL -X POST "https://sso.sikalabs.com/realms/training/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=example_client_id" \
  -d "client_secret=example_client_secret" \
  -d "grant_type=refresh_token" \
  -d "refresh_token=$RAW_REFRESH_TOKEN" )

echo NEW RAW RESPONSE:
echo $NEW_RESPONSE | jq
echo
