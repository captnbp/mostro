#!/usr/bin/python

from optparse import OptionParser
import socket
import sys
import re
import os

LOCALHOST = "127.0.0.1"
KEYS = ["curr_connections", "total_connections", "cmd_get", "cmd_set", "cmd_flush", "cmd_touch", "get_hits", "get_misses", "delete_misses", "delete_hits", "incr_misses", "incr_hits", "decr_misses", "decr_hits", "cas_misses", "cas_hits", "cas_badval", "touch_hits", "touch_misses", "bytes_read", "bytes_written", "limit_maxbytes", "bytes", "curr_items", "total_items", "evictions", "reclaimed", "maxconns", "active_slabs", "total_malloced", "listen_disabled_num", "conn_yields", "reqs_per_event"]

print("---")
print("service: memcache")
print("version: 2015051901")

parser = OptionParser(add_help_option=False)
parser.add_option("-h", dest="host", default=LOCALHOST)
parser.add_option("-t", dest="timeout", type="int", default=5)

(options, args) = parser.parse_args()

if args:
    options.port = int(args[0])
else:
    options.port = 11211

if os.getenv("MEMCACHE_HOST"):
    options.host = os.getenv("MEMCACHE_HOST")

if options.host == LOCALHOST:
    print("argument: %s" % options.port)
else:
    print("argument: %s:%d" % (options.host, options.port))

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.settimeout(options.timeout)

try:
    data = ""

    sock.connect((options.host, options.port))

    sock.send("stats settings\n")
    data += sock.recv(16384)

    sock.send("stats\n")
    data += sock.recv(16384)

    sock.send("stats slabs\n")
    data += sock.recv(16384)

    sock.close()

    data = data.split("\n")

    for line in data:
        m = re.search(r'^STAT\s([^\s]+)\s([0-9]+)', line)

        if m:
            key = m.group(1)
            value = m.group(2)

            if key in KEYS:
                print("%s: %s" % (key, value))
except socket.timeout:
    print "error: Connection timed out"
    sys.exit(254)
except socket.error, error:
    print("error: \"%s\"" % error[1])
    sys.exit(254)
