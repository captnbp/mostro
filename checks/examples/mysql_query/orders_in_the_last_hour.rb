#!/usr/bin/env ruby

# This is a check that gets connection informations from mostro.conf
# (MYSQL_HOST, MYSQL_USER and MYSQL_PASSWORD), connects to the MySQL server,
# and returns the total number of orders in the last hour from the
# "orders" table.

# You could then add a trigger if the number drops below a certain
# threshold, which could indicate an issue in the ordering process.

require "rubygems"
require "mysql"

puts "---"
puts "service: orders_in_the_last_hour"

connection = Mysql.new(ENV["MYSQL_HOST"] || "localhost", ENV["MYSQL_USER"], ENV["MYSQL_PASSWORD"], "my_database")

result = connection.query("SELECT COUNT(*) FROM orders WHERE created_at >= DATE_SUB(NOW(), INTERVAL 1 HOUR)").fetch_row().first

puts "orders_in_the_last_hour: #{result}"
