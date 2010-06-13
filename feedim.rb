#!/usr/bin/env ruby
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
  config = YAML::load open('config.yaml')
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
    filterd = false
    config["filters"].each{|f|
      if i.description.toutf8 =~ /#{f}/
        filterd = true
        break
      end
    }
    if !filterd
      next if pages[i.url] != nil
      pages[i.url] = i.description.toutf8
      puts mes = "#{i.url}\n#{i.description.toutf8}"
      ImKayac.send(config["im"], mes) if !config["debug"]
    end
    sleep 10
  }
  
}

pages.close

