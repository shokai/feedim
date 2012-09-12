#!/usr/bin/env ruby
require File.expand_path '../bootstrap', File.dirname(__FILE__)
Bootstrap.init

Page.find_to_publish.each do |page|
  page.description = page.description.expand_shor_url
  puts mes = "#{page.url}\n#{page.description}"
  if page.filtered?
    puts ' => filtered!'
    page.status = Page::Status::FILTERED
    page.save
    next
  end

  begin
    IM::send mes
  rescue => e
    STDERR.puts e
    next
  end
  page.status = Page::Status::PUBLISHED
  page.save
  sleep 3
end
