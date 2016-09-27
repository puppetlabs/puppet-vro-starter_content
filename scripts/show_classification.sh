#!/bin/bash

PATH="/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin:/opt/puppet/bin:$PATH"

declare -x PE_CERT=$(puppet agent --configprint hostcert)
declare -x PE_KEY=$(puppet agent --configprint hostprivkey)
declare -x PE_CA=$(puppet agent --configprint localcacert)

declare -x NC_CURL_OPT="-s --cacert $PE_CA --cert $PE_CERT --key $PE_KEY --insecure"

find_guid()
{
  echo $(curl $NC_CURL_OPT --insecure https://localhost:4433/classifier-api/v1/groups| python -m json.tool |grep -C 2 "$1" | grep "id" | cut -d: -f2 | sed 's/[\", ]//g')
}

show_classification()
{
  curl $NC_CURL_OPT --insecure https://localhost:4433/classifier-api/v1/groups/$1| python -m json.tool
}

show_classification `find_guid "$1"`

