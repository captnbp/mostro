#!/usr/bin/env python

# This is a check that gets connection informations from mostro.conf
# (MYSQL_HOST, MYSQL_USER and MYSQL_PASSWORD), connects to the MySQL server,
# and returns the total number of orders in the last hour from the
# "orders" table.

# You could then add a trigger if the number drops below a certain
# threshold, which could indicate an issue in the ordering process.

import MySQLdb
import os

print "---"
print "service: orders_in_the_last_hour"

connection = MySQLdb.connect(os.getenv("MYSQL_HOST", "localhost"), os.getenv("MYSQL_USER"), os.getenv("MYSQL_PASSWORD"), "my_database")

connection.query("SELECT COUNT(*) FROM orders WHERE created_at >= DATE_SUB(NOW(), INTERVAL 1 HOUR)")

result = connection.use_result()

print "orders_in_the_last_hour: %s" % result.fetch_row()[0]
