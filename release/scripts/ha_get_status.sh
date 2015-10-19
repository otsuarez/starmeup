#!/bin/bash
echo "show stat" | sudo socat unix-connect:/var/run/haproxy.sock stdio | egrep -v "FRONTEND|BACKEND" | grep $1 | cut -d, -f18
