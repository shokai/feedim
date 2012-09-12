#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
Bundler.require
require 'yaml'
require File.expand_path 'models/page', File.dirname(__FILE__)

begin
  @conf = YAML::load open(File.dirname(__FILE__)+'/config.yaml')
rescue
  STDERR.puts 'config.yaml load error!'
  exit 1
end

Mongoid.configure do |c|
  m = Mongo::Connection.new(@conf['mongo_server'], @conf['mongo_port'])
  c.master = m.db(@conf['mongo_db'])
end

