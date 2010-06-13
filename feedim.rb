#!/usr/bin/env ruby
$:.unshift(File.dirname(__FILE__)+'/lib') unless
  $:.include?(File.dirname(__FILE__)+'/lib') || $:.include?(File.expand_path(File.dirname(__FILE__)+'/lib'))
require 'im-kayac'
require 'rubygems'
require 'tokyocabinet'
include TokyoCabinet
require 'feed-normalizer'
require 'open-uri'
require 'yaml'
require 'kconv'
require 'pp'
require 'cgi'

begin
  config = YAML::load open(File.dirname(__FILE__) + '/config.yaml')
rescue
  puts 'config.yaml load error!'
  exit 1
end

pages = HDB.new
pages.open(File.dirname(__FILE__)+"/pages.tch", HDB::OWRITER|HDB::OCREAT)

config["feeds"].each{|url|
  puts url
  feed = nil
  begin
    feed = FeedNormalizer::FeedNormalizer.parse open(url, 'User-Agent' => 'feedim')
  rescue
    puts 'feed parse error!'
  end
  next if !feed
  feed.entries.each{|i|
    next if !i.description or i.description.size < 1
    filterd = false
    config["filters"].each{|f|
      
      if i.description.toutf8 =~ /#{f}/
        filterd = true
        break
      end
    }
    if !filterd
      next if pages[i.url] != nil
      puts mes = "#{i.url}\n#{i.description.toutf8}"
      res = ImKayac.send(config["im"], mes) if !config["debug"]
      pages[i.url] = i.description.toutf8 if res
    end
    sleep 10
  }
  
}

pages.close

