require 'rubygems'
require 'uri'

module ImKayac
  def ImKayac.send(user, message)
    puts uri = URI.parse("http://im.kayac.com/api/post/#{user}")
    message.gsub!(/&/, '_')
    Net::HTTP.start(uri.host, uri.port) {|http|
      response = http.post(uri.path, "message=#{URI.encode(message)}")
      puts response.body
    }
  end

end
