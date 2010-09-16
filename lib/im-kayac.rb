require 'rubygems'
require 'uri'
require 'net/http'

module ImKayac
  def ImKayac.send(user, message)
    uri = URI.parse("http://im.kayac.com/api/post/#{user}")
    message.gsub!(/&/, '_')
    Net::HTTP.start(uri.host, uri.port) {|http|
      response = http.post(uri.path, "message=#{URI.encode(message)}")
      return response.body
    }
    raise Error.new('ImKayac error')
  end

end
