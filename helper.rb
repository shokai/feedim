#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'bson'
require 'mongoid'
require File.dirname(__FILE__)+'/page'
$KCODE = 'u'

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

