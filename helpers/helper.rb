# -*- coding: utf-8 -*-
require 'hugeurl'
require 'open-uri'

def http_get(url)
  open(url.to_s, 'User-Agent' => Conf['user_agent']).read
end

class String
  def remove_html_tag
    self.gsub(/<[^<>]+>/,'')
  end

  def expand_shor_url
    pat = /(https?:\/\/[-_.!~*\'()a-zA-Z0-9;\/?:\@&=+\$,%#]+)/
    self.split(pat).map{|i|
      begin
        res = i =~ pat ? URI.parse(i).to_huge.to_s : i
      rescue
        res = i
      end
      res
    }.join('')
  end
end


if __FILE__ == $0
  s = "aaaaahttp://htn.to/KyWVg5"
  puts s
  puts s.expand_shor_url
end
