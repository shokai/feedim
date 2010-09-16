#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/helper'
require File.dirname(__FILE__)+'/lib/im-kayac'
require 'json'

Page.all(:conditions => {:status => 'stored'}).each{|page|
  puts mes = "#{page.url}\n#{page.description}"
  if page.filtered?(@conf)
    begin
      puts 'filtered!'
      page.status = 'filtered'
      page.save
    rescue => e
      STDERR.puts e
    end
    next
  end

  begin
    res = JSON.parse ImKayac.send(@conf["im"], mes)
    if res and res['error'].to_s.size < 1
      page.status = 'published'
      page.save
      sleep 3
    end
  rescue => e
    STDERR.puts e
  end
}
