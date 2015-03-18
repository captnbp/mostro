#!/usr/bin/python

print("---")
print("service: mongodb")

from optparse import OptionParser
import sys
import time

try:
    import pymongo
except:
    print "error: You need to install pymongo."
    sys.exit(254)

parser = OptionParser(add_help_option=False)
parser.add_option("-h", dest="host", default="127.0.0.1")
parser.add_option("-p", dest="port", type="int", default=27017)
parser.add_option("-t", dest="timeout", type="int", default=5)

(options, args) = parser.parse_args()
options_dict = vars(options)

timeout = options.timeout * 1000

try:
    mongo = pymongo.Connection(options.host, options.port, socketTimeoutMS=timeout, connectTimeoutMS=timeout)
    db = mongo['local']

    server_status = db.command("serverStatus", repl=0, recordStats=0, dur=0)
except Exception as exception:
    print "error: \"%s\"" % exception
    sys.exit(254)

def variable_exists(parent, variable):
    return parent in server_status and variable in server_status[parent]

def print_variable(name, parent, variable):
    if variable_exists(parent, variable):
        print "%s: %d" % (name, server_status[parent][variable])

print_variable("mem_resident", "mem", "resident")
print_variable("mem_virtual", "mem", "virtual")
print_variable("mem_mapped", "mem", "mapped")

print_variable("connections_current", "connections", "current")
print_variable("connections_available", "connections", "available")

print_variable("heap_usage_bytes", "extra_info", "heap_usage_bytes")
print_variable("page_faults", "extra_info", "page_faults")

if variable_exists("indexCounters", "btree"):
    server_status["indexCounters"] = server_status["indexCounters"]["btree"]

print_variable("index_counters_accesses", "indexCounters", "accesses")
print_variable("index_counters_hits", "indexCounters", "hits")
print_variable("index_counters_misses", "indexCounters", "misses")

print_variable("background_flushing_flushes", "backgroundFlushing", "flushes")
print_variable("background_flushing_total_ms", "backgroundFlushing", "total_ms")
print_variable("background_flushing_last_ms", "backgroundFlushing", "last_ms")

if variable_exists("backgroundFlushing", "last_finished"):
    background_flushing_last_finished = time.mktime(server_status["backgroundFlushing"]["last_finished"].timetuple())
    print("background_flushing_last_finished: %d" % background_flushing_last_finished)

print_variable("cursors_total_open", "cursors", "totalOpen")
print_variable("cursors_timed_out", "cursors", "timedOut")

print_variable("network_bytes_in", "network", "bytesIn")
print_variable("network_bytes_out", "network", "bytesOut")
print_variable("network_num_requests", "network", "numRequests")

print_variable("network_opcounters_insert", "opcounters", "insert")
print_variable("network_opcounters_query", "opcounters", "query")
print_variable("network_opcounters_update", "opcounters", "update")
print_variable("network_opcounters_delete", "opcounters", "delete")
print_variable("network_opcounters_getmore", "opcounters", "getmore")
print_variable("network_opcounters_command", "opcounters", "command")

print_variable("network_asserts_regular", "asserts", "regular")
print_variable("network_asserts_warning", "asserts", "warning")
print_variable("network_asserts_msg", "asserts", "msg")
print_variable("network_asserts_user", "asserts", "user")
print_variable("network_asserts_rollovers", "asserts", "rollovers")

print_variable("global_lock_total_time", "globalLock", "totalTime")
print_variable("global_lock_lock_time", "globalLock", "lockTime")
