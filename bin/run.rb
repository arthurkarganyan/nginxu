#!/usr/bin/env ruby

require "bundler/setup"
require "thor"
require_relative '../lib/nginxu'

Nginxu::CLI.start(ARGV)
