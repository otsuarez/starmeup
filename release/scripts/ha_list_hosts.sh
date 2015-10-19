#!/bin/bash
#echo "show stat" | sudo socat unix-connect:/var/run/haproxy.sock stdio | egrep -v "FRONTEND|BACKEND" | grep UP | grep web | cut -f2 -d,
echo "show stat" | sudo socat unix-connect:/var/run/haproxy.sock stdio | egrep -v "FRONTEND|BACKEND" | grep UP | grep $1 | cut -f2 -d,
#ssh lb 'echo "show stat" | sudo socat unix-connect:/var/run/haproxy.sock stdio | egrep -v "FRONTEND|BACKEND" | grep UP | grep $1 | cut -f2 -d,'
