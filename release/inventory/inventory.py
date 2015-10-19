#!/usr/bin/env python

import sys
import yaml
import json
import os
import sys
import socket

#print(socket.gethostname())
__location__ = os.path.realpath(
    os.path.join(os.getcwd(), os.path.dirname(__file__)))

if len(sys.argv) == 1:
    sys.stderr.write('Usage: %s --list|--host host\n' % (sys.argv[0]))
    sys.exit(1)

if sys.argv[1] == "--list":
    hostname = socket.getfqdn()
    os.system("logger inside inventory.py")
    #file = open('conf/'+hostname+'.yml','r')
    file = open(os.path.join(__location__, '../conf/'+hostname+'.yml'),'r')
    #file = open(hostname+'.yml','r')
    hosts = yaml.load(file)
    file.close()
    # json.dump(hosts, sys.stdout, indent=4)
    #output = json.dumps(hosts)
    output = json.dumps(hosts,sort_keys = False, indent = 1)
    output = output+'\n'
    print output.replace('"empty"','')
