#!/bin/bash


CONF_FILE=conf/cc.conf
USAGE="Usage: $0 [-c <config_file>]"

if [[ $# != 0 ]] && [[ $# != 2 ]];then
  echo $USAGE >&2
  exit -1
fi

if [[ $# == 2 ]] && [[ "$1" == "-c" ]];then
  CONF_FILE=$2
elif [[ $# != 0 ]];then
  echo $USAGE >&2
  exit -1
fi

if ! test -f $CONF_FILE;then
  echo "ERROR: No config file detected ($CONF_FILE)" >&2
  echo $USAGE >&2
  exit -1
fi

ACCESS_KEY=$(grep "^access_key:" < $CONF_FILE | awk '{print $2}')
ACCESS_SECRET=$(grep "^access_secret:" < $CONF_FILE | awk '{print $2}')

if [[ "$ACCESS_KEY" == "" ]] || [[ "$ACCESS_SECRET" == "" ]];then
  echo "ERROR: Bad config file ($CONF_FILE)" >&2
  echo $USAGE >&2
  exit -1
fi

NONCE=$RANDOM$RANDOM$RANDOM$RANDOM
TIMESTAMP=$(date +%s)
TO_SIGN=$ACCESS_KEY$NONCE$TIMESTAMP

HEX_KEY=$(base64 -d <<<$ACCESS_SECRET | xxd -p -c 32)
SIGNATURE=$(echo -n $TO_SIGN | openssl dgst -sha256 -mac HMAC -macopt hexkey:$HEX_KEY | awk '{print $2}')

echo -n "X-Signature: Signature "
echo -n "access-key=\"$ACCESS_KEY\", "
echo -n "nonce=\"$NONCE\", "
echo -n "timestamp=\"$TIMESTAMP\", "
echo -n "version=\"1\", "
echo "signature=\"$SIGNATURE\""


