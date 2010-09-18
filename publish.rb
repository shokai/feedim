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

  im_auth = nil
  if @conf['im_auth_type'] == 'sig'
    require 'digest/sha1'
    sig = Digest::SHA1.hexdigest(mes + @conf['im_auth'])
    im_auth = {:sig => sig}
  elsif @conf['im_auth_type'] == 'password'
    im_auth = {:password => @conf['im_auth']}
  end
  begin
    ImKayac.post(@conf["im"], mes, im_auth)
  rescue => e
    STDERR.puts e
    next
  end
  page.status = 'published'
  page.save
  sleep 3
}
