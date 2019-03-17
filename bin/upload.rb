#!/usr/bin/env ruby

require "bundler/setup"
Bundler.require(:default)
require 'active_support/core_ext/hash'
require 'net/ssh'
require 'yaml'

require_relative '../lib/config'

config = YAML.load_file("config.yml").deep_symbolize_keys!

c = Config.new(config)
c.upload
