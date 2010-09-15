#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/lib/im-kayac'
require 'pp'
require 'yaml'
require 'rubygems'
require 'tokyocabinet'
include TokyoCabinet
require 'feed-normalizer'
require 'open-uri'
require 'kconv'


begin
  config = YAML::load open(File.dirname(__FILE__)+'/config.yaml')
rescue
  STDERR.puts 'config.yaml load error!'
  exit 1
end

pages = HDB.new
pages.open(File.dirname(__FILE__)+"/pages.tch", HDB::OWRITER|HDB::OCREAT)

config["feeds"].each{|url|
  puts "[feed] : #{url}"
  feed = nil
  begin
    feed = FeedNormalizer::FeedNormalizer.parse open(url, 'User-Agent' => 'feedim')
  rescue
    STDERR.puts 'feed parse error!'
    next
  end
  feed.entries.reverse.each{|i|
    next if !i.description or i.description.size < 1
    i.description.gsub!(/<[^<>]+>/,'') # htmlタグ除去
    filtered = false
    if !filtered and config["filters"]
      config["filters"].each{|f|
        if i.description.toutf8 =~ /#{f}/i or i.url =~ /#{f}/i
          filtered = true
          break
        end
      }
    end
    if !filtered and config["description_filters"]
      config["description_filters"].each{|f|
        if i.description.toutf8 =~ /#{f}/i
          filtered = true
          break
        end
      }
    end
    if !filtered and config["url_filters"]
      config["url_filters"].each{|f|
        if i.url =~ /#{f}/i
          filtered = true
          break
        end
      }
    end
    unless filtered
      next if pages[i.url] != nil
      puts mes = "#{i.url}\n#{i.description.toutf8}"
      res = ImKayac.send(config["im"], mes) unless config["debug"]
      pages[i.url] = i.description.toutf8 if res
      sleep 3
    end
  }
  
}

pages.close

