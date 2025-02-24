#!/bin/sh

RESPONSE=$(curl -fsSL -X POST "https://sso.sikalabs.com/realms/training/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=example_client_id" \
  -d "client_secret=example_client_secret" \
  -d "grant_type=password" \
  -d "username=example_username" \
  -d "password=example_password" )

echo RAW RESPONSE:
echo $RESPONSE | jq
echo

echo RAW ACCESS TOKEN:
echo $RESPONSE | jq -r .access_token
echo

echo PARSED ACCESS TOKEN:
echo $RESPONSE | jq -r .access_token | slr parse-jwt | jq '.[1]'
echo

echo RAW REFRESH TOKEN:
RAW_REFRESH_TOKEN=$(echo $RESPONSE | jq -r .refresh_token)
echo $RAW_REFRESH_TOKEN
echo

echo PARSED REFRESH TOKEN:
echo $RESPONSE | jq -r .refresh_token | slr parse-jwt | jq '.[1]'
echo

NEW_RESPONSE=$(curl -fsSL -X POST "https://sso.sikalabs.com/realms/training/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=example_client_id" \
  -d "client_secret=example_client_secret" \
  -d "grant_type=refresh_token" \
  -d "refresh_token=$RAW_REFRESH_TOKEN" )

echo NEW RAW RESPONSE:
echo $NEW_RESPONSE | jq
echo
