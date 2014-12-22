#!/usr/bin/env perl
# This is a check that gets connection informations from mostro.conf
# (MYSQL_HOST, MYSQL_USER and MYSQL_PASSWORD), connects to the MySQL server,
# and returns the total number of orders in the last hour from the
# "orders" table.

# You could then add a trigger if the number drops below a certain
# threshold, which could indicate an issue in the ordering process.

use DBI;
use DBD::MySQL;

print "---\n";
print "service: orders_in_the_last_hour\n";

my $host = $ENV["MYSQL_HOST"];

if($host eq "") {
  $host = "localhost";
}

my $dbh = DBI->connect("dbi:mysql:database=my_database;host=${host}", $ENV{"MYSQL_USER"}, $ENV{"MYSQL_PASSWORD"});

my $query = $dbh->prepare("SELECT COUNT(*) FROM orders WHERE created_at >= DATE_SUB(NOW(), INTERVAL 1 HOUR)");
$query->execute;

@result = $query->fetchrow_array;

print "orders_in_the_last_hour: ", $result[0], "\n"
