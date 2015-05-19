#!/usr/bin/env ruby

# Usage:              ./stats.rb
# with redis options: REDIS_URL="redis://localhost:6379/0" ./stats.rb

# More about Sidekiq API: https://github.com/mperham/sidekiq/wiki/API

require 'rubygems'
require 'bundler/setup'
require 'sidekiq/api'

stats = Sidekiq::Stats.new

puts "---"
puts "service: sidekiq_stats"
puts "version: 2015051901"
puts "processed: #{stats.processed}"
puts "failed: #{stats.failed}"
puts "enqueued: #{stats.enqueued}"
puts "scheduled_size: #{stats.scheduled_size}"
puts "retry_size: #{stats.retry_size}"
puts "dead_size: #{stats.dead_size}"
