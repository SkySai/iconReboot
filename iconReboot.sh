#!/bin/bash

auth="admin:admin"
PROGNAME=$(basename "$0")
if [ "$#" -eq 1 ]; then
    ip=$1
elif [ "$#" -eq 2 ]; then
    auth="admin:${1}"
    ip=$2
else
    echo "USAGE: setSipDetails [auth] ip"
    echo "auth: specify username and password when non default (admin:admin) include the colon to separate the username from the password"
    echo "ip: specify endpoint IP address"
    exit 1
fi

# 0 = SIP is not enabled
# 1 = SIP is enabled
bOverrideClusterDiscovery="0"
cssTargetNode=''
bIsStatsCollectionEnabled='1'
#eContextType="0"

echo "AUTH is ${auth}"
b64auth=$(echo -n ${auth} | base64)
echo "IP is ${ip}"

session=$( curl -H "Authorization: LSBasic ${b64auth}" -H "Content-Type: application/json" http://$ip/rest/new | awk -F\" '/session/ { print $4 }' )
echo "SESSION is ${session}"

curl -H "Authorization: LSBasic ${b64auth}" -H "Content-Type: application/json" --data "{\"call\":\"SysAdmin_reboot\",\"params\": [\"blips\"]}" http://${ip}/rest/request/${session} 

curl -H "Authorization: LSBasic ${b64auth}" -H "Content-Type: application/json" --data "{\"params\":{},\"call\":\"SysAdmin_getTime\"}" http://${ip}/rest/request/${session} 

