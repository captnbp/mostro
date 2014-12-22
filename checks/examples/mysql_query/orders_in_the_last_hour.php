#!/usr/bin/env php
<?php
# This is a check that gets connection informations from mostro.conf
# (MYSQL_HOST, MYSQL_USER and MYSQL_PASSWORD), connects to the MySQL server,
# and returns the total number of orders in the last hour from the
# "orders" table.

# You could then add a trigger if the number drops below a certain
# threshold, which could indicate an issue in the ordering process.

echo "---\n";
echo "service: orders_in_the_last_hour\n";

$host = getenv("MYSQL_HOST");

if(empty($host)) {
  $host = "localhost";
}

mysql_connect($host, getenv("MYSQL_USER"), getenv("MYSQL_PASSWORD"));
mysql_select_db("my_database");

$query = mysql_query("SELECT COUNT(*) FROM orders WHERE created_at >= DATE_SUB(NOW(), INTERVAL 1 HOUR)");
$result = mysql_fetch_row($query);

echo "orders_in_the_last_hour: " . $result[0] . "\n";
?>
