#!/usr/bin/env ruby

require 'yaml'

config = YAML.load_file('config.yml')
%x(scp -r #{config['user']}@#{config['ip']}:/etc/nginx/sites-enabled .)
puts "Downloaded to sites-enabled"
