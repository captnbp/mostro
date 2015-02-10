#!/usr/bin/env ruby

# Usage:
# default queue:      ./queue.rb
# named queue:        ./queue.rb emails
# with redis options: REDIS_URL="redis://localhost:6379/0" ./queue.rb

# More about Sidekiq API: https://github.com/mperham/sidekiq/wiki/API

require 'rubygems'
require 'bundler/setup'
require 'sidekiq/api'

queue_name = ARGV[0] || "default"
queue = Sidekiq::Queue.new(queue_name)

puts "---"
puts "service: sidekiq_queue"
puts "argument: #{queue_name}"
puts "queue_size: #{queue.size}"
puts "queue_latency: #{queue.latency}"
