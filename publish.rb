#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/helper'
require 'rubygems'
require 'im-kayac'

Page.all(:conditions => {:status => 'stored'}).each{|page|
  puts mes = "#{page.url}\n#{page.description}"
  if page.filtered?(@conf)
    puts 'filtered!'
    page.status = 'filtered'
    begin
      page.save
    rescue => e
      STDERR.puts e
    end
    next
  end

  begin
    ImKayac.post(@conf["im"], mes)
  rescue => e
    STDERR.puts e
    next
  end
  page.status = 'published'
  page.save
  sleep 3
}
