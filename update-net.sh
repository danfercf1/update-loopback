#!/bin/bash
#set -ex
PATH="/etc/network/interfaces.d/lo10"
HOST=`/usr/bin/curl "http://api.ipify.org"`
while getopts ":h:p:" opt; do
  case $opt in
    h)
      echo "-h was triggered, Parameter: $OPTARG" >&2
      HOST="$OPTARG"
      ;;
    p)
      echo "-p was triggered, Parameter: $OPTARG" >&2
      PATH="$OPTARG"
      ;;
    \?)
      echo "No ip param, -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
    *) echo "Unimplemented option: -$OPTARG" >&2; 
       exit 1;;
  esac
done

NETFILE=$PATH

if [ -z "$HOST" ]
then
echo "Empty param Host -h"
exit 1
fi

if [ -f "$NETFILE" ]
then
/bin/cat > "$NETFILE" <<EOL
auto lo:10
iface lo:10 inet static
address $HOST
netmask 255.255.255.0
dns-nameservers 8.8.8.8
EOL

/bin/systemctl restart networking
/bin/cat "$NETFILE"
else
echo "Incorrect path"
fi
