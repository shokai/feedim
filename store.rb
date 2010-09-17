#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/helper'
require 'rubygems'
require 'feed-normalizer'
require 'open-uri'
require 'kconv'
require 'hugeurl'

@conf["feeds"].each{|url|
  puts "[feed] : #{url}"
  feed = nil
  begin
    feed = FeedNormalizer::FeedNormalizer.parse open(url, 'User-Agent' => @conf['user_agent'])
  rescue
    STDERR.puts 'feed parse error!'
    next
  end
  feed.entries.reverse.each{|i|
    next if !i.description or i.description.size < 1
    i.description.gsub!(/<[^<>]+>/,'') # htmlタグ除去
    i.description = i.description.split(/(https?\:[\w\.\~\-\/\?\&\+\=\:\@\%\;\#\%]+)/).map{|str|
      res = nil
      if str =~ /^http\:\/\/bit\.ly\/.+/ or str =~ /^http\:\/\/tinyurl\.com\/.+/
        res = Hugeurl.get(str).to_s rescue next
      else
        res = str
      end
      res
    }.join('')
    next if Page.count(:conditions => {:url => i.url}) > 0
    page = Page.new(
                    :url => i.url,
                    :title => i.title.to_s.toutf8,
                    :description => i.description.to_s.toutf8,
                    :date_published => i.date_published
                    )
    page.save rescue next
    puts "stored : #{page.description} => #{page.url}"
  }
}
