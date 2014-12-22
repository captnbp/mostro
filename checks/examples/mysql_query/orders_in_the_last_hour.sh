#!/bin/bash -e

# This is a check that gets connection informations from mostro.conf
# (MYSQL_HOST, MYSQL_USER and MYSQL_PASSWORD), connects to the MySQL server,
# and returns the total number of orders in the last hour from the
# "orders" table.

# You could then add a trigger if the number drops below a certain
# threshold, which could indicate an issue in the ordering process.

echo "---"
echo "service: orders_in_the_last_hour"

ORDERS=$(mysql --skip-column-names --host="${MYSQL_HOST:-localhost}" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" my_database -e "SELECT COUNT(*) FROM orders WHERE created_at >= DATE_SUB(NOW(), INTERVAL 1 HOUR)")

echo "orders_in_the_last_hour: $ORDERS"
