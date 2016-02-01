#!/bin/bash


SIGNATURE_HEADER=$(./signature.sh -c conf/cc.conf)
TMP_FILE=/tmp/$RANDOM$RANDOM$RANDOM
curl -H "$SIGNATURE_HEADER" -H "Accept: application/json" "https://api.chip-chap.com/user/v1/wallet" -s > $TMP_FILE



#echo "scale=2;`jq '.data[6].available' < $TMP_FILE`*10^-`jq '.data[6].scale' < $TMP_FILE`" | bc
jq '.data[]' < $TMP_FILE | jq '"\(.currency) \(.available)"'
#jq '.data' < $TMP_FILE | jq 'map_values(has("multidivisa"))'




