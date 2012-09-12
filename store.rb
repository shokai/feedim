#!/usr/bin/env ruby
require File.expand_path 'bootstrap', File.dirname(__FILE__)
Bootstrap.init
require 'open-uri'
require 'kconv'

Conf["feeds"].each{|feed_url|
  puts "[feed] : #{feed_url}"
  feed = nil
  begin
    feed = FeedNormalizer::FeedNormalizer.parse open(feed_url, 'User-Agent' => Conf['user_agent'])
  rescue
    STDERR.puts 'feed parse error!'
    next
  end
  feed.entries.reverse.each{|i|
    next if !i.description or i.description.size < 1
    i.description.gsub!(/<[^<>]+>/,'') # remove html tag
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
                    :date_published => i.date_published,
                    :source => feed_url
                    )
    page.save rescue next
    puts "stored : #{page.description} => #{page.url}"
  }
}
