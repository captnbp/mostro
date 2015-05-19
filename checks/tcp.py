#!/usr/bin/python

from optparse import OptionParser
import socket
import sys
import datetime

LOCALHOST = "127.0.0.1"

print("---")
print("service: tcp")
print("version: 2015051901")

parser = OptionParser(add_help_option=False)
parser.add_option("-h", dest="host", default=LOCALHOST)
parser.add_option("-t", dest="timeout", type="int", default=5)

(options, args) = parser.parse_args()

if not args:
    print("error: No port specified.")
    sys.exit(254)

options.port = int(args[0])

if options.host == LOCALHOST:
    print("argument: %s" % options.port)
else:
    print("argument: %s:%d" % (options.host, options.port))

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.settimeout(options.timeout)

try:
    start_time = datetime.datetime.now()
    sock.connect((options.host, options.port))
except socket.timeout:
    print "error: Connection timed out"
    sys.exit(254)
except socket.error as (code, reason):
    print("error: \"%s\"" % reason)
    sys.exit(254)
finally:
    end_time = datetime.datetime.now()
    time_total = end_time - start_time
    print("time_total: %d.%06d" % (time_total.seconds, time_total.microseconds))
