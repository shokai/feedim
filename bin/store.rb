#!/usr/bin/env ruby
require File.expand_path '../bootstrap', File.dirname(__FILE__)
Bootstrap.init
require 'kconv'

results = Conf["feeds"].each{|feed_url|
  puts "[feed] : #{feed_url}"
  begin
    feed = FeedNormalizer::FeedNormalizer.parse http_get(feed_url)
  rescue
    STDERR.puts 'feed parse error!'
    next
  end
  feed.entries.reverse.each{|i|
    next if i.description.empty?
    desc = i.description.toutf8.remove_html_tag
    page = Page.new(
                    :url => i.url,
                    :title => i.title.to_s.toutf8,
                    :description => desc,
                    :date_published => i.date_published,
                    :source => feed_url
                    )
    puts page.url
    puts page.description
    if page.save
      puts " => stored!"
    else
      puts " => skip"
    end
  }
}
