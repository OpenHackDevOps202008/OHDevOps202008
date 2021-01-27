#!/bin/bash

declare -i duration=1
declare hasUrl=""
declare endpoint
declare endpoint_status

usage() {
    cat <<END
    polling.sh [-i] [-h] endpoint
    
    Report the health status of the endpoint
    -i: include Uri for the format
    -h: help
END
}

while getopts "ih" opt; do 
  case $opt in 
    i)
      hasUrl=true
      ;;
    h) 
      usage
      exit 0
      ;;
    \?)
     echo "Unknown option: -${OPTARG}" >&2
     exit 1
     ;;
  esac
done

shift $((OPTIND -1))

if [[ $1 ]]; then
  endpoint=$1
else
  echo "Please specify the endpoint."
  usage
  exit 1 
fi 


healthcheck() {
    declare url=$1
    # $endpoint_status = $(curl --head --location --connect-timeout 5 --write-out %{http_code} --silent --output /dev/null ${url} | grep HTTP/1.1)
    $endpoint_status = $(curl --head --location --connect-timeout 5 --write-out %{http_code} --silent --output /dev/null ${url})
    # result=$(curl -i $url 2>/dev/null | grep HTTP/1.1)
    # status=$(curl --head --location --connect-timeout 5 --write-out %{http_code} --silent --output /dev/null ${url})
    # [[ $status == 500 ]] || [[ $status == 000 ]] && echo restarting ${url} # do start/restart logic
    # echo $result
    echo $endpoint_status
}

while [[ true ]]; do
   # result=`healthcheck $endpoint` 
   declare local_status= `healthcheck $endpoint`  
   # local_status = healthcheck
   timestamp=$(date "+%Y%m%d-%H%M%S")
   if [[ $endpoint_status -eq 200 ]]; then 
      local_status="ALL GOOD - "
      echo "$timestamp | $endpoint_status | $endpoint " 
      exit 0
   else
      echo $local_status
      exit -1
   fi 

   if [[ -z $hasUrl ]]; then
     echo "$timestamp | $local_status "
   else
     echo "$timestamp | $local_status | $endpoint " 
   fi 
   sleep $duration
done