require 'rubygems'
require 'socialskk'
require 'cgi'
require 'json'

class GoogleSuggestSkk < SocialSKK
  VERSION_STRING   = "GoogleSuggestSKK0.1"

  def social_ime_search(text)
    uri = URI.parse 'http://clients1.google.co.jp/'
    http = Net::HTTP.new(uri.host, uri.port)
    http = Net::HTTP.new(uri.host, uri.port, @proxy.host, @proxy.port) if @proxy
    begin
      http.read_timeout = 1
      http.open_timeout = 1
      http.start do |h|
        res = h.get("/complete/search?client=hp&hl=ja&ie=euc-jp&oe=euc-jp&q=" + CGI.escape(text))
        content = res.body.sub(/^[^\(]+\((.+)\)$/, '\1')
        obj = JSON.parse(content)
        obj.shift
        obj[0].map do |item|
          item[0]
        end.join('/')
      end
    rescue => e
      warn e
      return ""
    end
  end
end


