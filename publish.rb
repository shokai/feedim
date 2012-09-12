#!/usr/bin/env ruby
require File.expand_path 'bootstrap', File.dirname(__FILE__)
Bootstrap.init

Page.all(:conditions => {:status => 'stored'}).each{|page|
  puts mes = "#{page.url}\n#{page.description}"
  if page.filtered?
    puts ' => filtered!'
    page.status = 'filtered'
    begin
      page.save
    rescue => e
      STDERR.puts e
    end
    next
  end

  im_auth = nil
  if Conf['im_auth_type'] == 'sig'
    require 'digest/sha1'
    sig = Digest::SHA1.hexdigest(mes + Conf['im_auth'])
    im_auth = {:sig => sig}
  elsif Conf['im_auth_type'] == 'password'
    im_auth = {:password => Conf['im_auth']}
  end
  begin
    ImKayac.post(Conf["im"], mes, im_auth)
  rescue => e
    STDERR.puts e
    next
  end
  page.status = 'published'
  page.save
  sleep 3
}
