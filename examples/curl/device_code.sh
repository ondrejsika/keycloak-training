#!/bin/sh

DEVICE_RESPONSE=$(curl -sSL -X POST "https://sso.sikalabs.com/realms/training/protocol/openid-connect/auth/device" \
  -d "client_id=example_device_code" \
  -d "client_secret=example_device_code" \
  -d "scope=openid" )

echo RAW DEVICE RESPONSE:
echo "$DEVICE_RESPONSE" | jq
echo

DEVICE_CODE=$(echo "$DEVICE_RESPONSE" | jq -r .device_code)
INTERVAL=$(echo "$DEVICE_RESPONSE" | jq -r .interval)

echo "OPEN IN BROWSER:"
echo "$DEVICE_RESPONSE" | jq -r .verification_uri_complete
echo
echo "OR OPEN IN BROWSER:"
echo "$DEVICE_RESPONSE" | jq -r .verification_uri
echo
echo "WITH CODE:"
echo "$DEVICE_RESPONSE" | jq -r .user_code
echo

# Poll token endpoint until the user approves (or denies) the login
while true; do
  RESPONSE=$(curl -sSL -X POST "https://sso.sikalabs.com/realms/training/protocol/openid-connect/token" \
    -d "grant_type=urn:ietf:params:oauth:grant-type:device_code" \
    -d "client_id=example_device_code" \
    -d "client_secret=example_device_code" \
    -d "device_code=$DEVICE_CODE" )

  ERROR=$(echo "$RESPONSE" | jq -r '.error // empty')
  case "$ERROR" in
    "") break ;;
    authorization_pending) sleep "$INTERVAL" ;;
    slow_down) INTERVAL=$((INTERVAL + 5)); sleep "$INTERVAL" ;;
    *) echo "$RESPONSE" | jq; exit 1 ;;
  esac
done

echo RAW RESPONSE:
echo "$RESPONSE" | jq
echo

echo ACCESS TOKEN:
echo "$RESPONSE" | jq -r .access_token | slu jwt parse -
echo

echo ID TOKEN:
echo "$RESPONSE" | jq -r .id_token | slu jwt parse -
echo
